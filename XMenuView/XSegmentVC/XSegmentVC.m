//
//  XSegmentVC.m
//  XMenuView
//
//  Created by SongGuoxing on 2017/12/12.
//  Copyright © 2017年 SongGuoxing. All rights reserved.
//

#import "XSegmentVC.h"

#define HEADBTN_TAG                 10000

@interface XSegmentVC ()<UIScrollViewDelegate>
// 标签栏
@property (nonatomic, strong) UIScrollView *menuView;
// 指示条
@property (nonatomic, strong) UIView *lineView;
// 容器视图
@property (nonatomic, strong) UIScrollView *mainScrollView;


// 选中index
@property (nonatomic, assign) NSInteger selectIndex;
// 选中Button
@property (nonatomic, strong) UIButton *selectedBtn;
// 指示线移动中标识
@property (nonatomic, assign) BOOL isLineAnimation;
// 标签栏每个目录的宽度
@property (nonatomic, assign) CGFloat menuItemWidth;

@end

@implementation XSegmentVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 默认配置
- (void)defaultConfig {
    _menuViewBackgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    _titleColor = [UIColor blackColor];
    _titleSelectedColor = [UIColor redColor];
    _fontSize = 16;
    _menuHeight = 40;
    _indicatorLineColor = [UIColor redColor];
    _indicatorLineHeight = 3;
}

- (void)addToParentViewController:(UIViewController *)parent {
    // 加载子视图
    [self.view addSubview:self.menuView];
    
    UIView *middleView = [[UIView alloc] init];
    if ([self.delegate respondsToSelector:@selector(viewBetweenMenuAndContent)]) {
        middleView = [self.delegate viewBetweenMenuAndContent];
        // 不能超过self的maxY
        CGFloat maxWidth = MIN(self.view.bounds.size.width, middleView.frame.size.width - middleView.frame.origin.x);
        middleView.frame = CGRectMake(middleView.frame.origin.x, self.menuView.bounds.size.height, maxWidth, middleView.frame.size.height);
        [self.view addSubview:middleView];
    }
    self.mainScrollView.frame = CGRectMake(0, self.menuHeight + middleView.bounds.size.height, self.view.frame.size.width, self.view.frame.size.height - self.menuHeight - middleView.bounds.size.height);
    [self.view addSubview:self.mainScrollView];
    // 默认选中
    [self setMenuWithIndex:self.defaultSelectIndex];
    [self.mainScrollView scrollRectToVisible:CGRectMake(self.selectIndex  * self.mainScrollView.bounds.size.width, 0, self.mainScrollView.bounds.size.width, self.mainScrollView.bounds.size.height) animated:NO];
    // 加到父视图
    [parent addChildViewController:self];
    [parent.view addSubview:self.view];
}

- (void)btnClick:(UIButton *)button {
    if (self.selectedBtn == button) {
        return;
    }
    [self setSelectSegmentIndex:button.tag - HEADBTN_TAG];
}

#pragma mark - Selected Index
- (void)setSelectSegmentIndex:(NSInteger)index {
    [self setMenuWithIndex:index];
    CGFloat space = (self.menuItemWidth - self.indicatorLineWidth) / 2;
    CGFloat x = index * self.menuItemWidth + space;
    self.isLineAnimation = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self setLineWithOriginX:x];
        [self.mainScrollView scrollRectToVisible:CGRectMake(index  * self.mainScrollView.bounds.size.width, 0, self.mainScrollView.bounds.size.width, self.mainScrollView.bounds.size.height) animated:YES];
    } completion:^(BOOL finished) {
        self.isLineAnimation = NO;
    }];
    if ([self.delegate respondsToSelector:@selector(segmentChangedIndex:)]) {
        [self.delegate segmentChangedIndex:index];
    }
}

#pragma mark - Menu Button
- (void)setMenuWithIndex:(NSInteger)index {
    // 原先的不选中
    self.selectedBtn.selected = NO;
    // 新选中Btn
    UIButton *currentSelectBtn = (UIButton *)[self.view viewWithTag:index + HEADBTN_TAG];
    currentSelectBtn.selected = YES;
    self.selectedBtn = currentSelectBtn;
    self.selectIndex = index;
}

#pragma mark - Menu Line
- (void)setLineWithOriginX:(CGFloat)x {
    CGRect rect = self.lineView.frame;
    rect.origin.x = x;
    self.lineView.frame = rect;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView && self.isLineAnimation == NO) {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat scrollViewWidth = scrollView.frame.size.width;
        
        // lineX
        CGFloat space = (self.menuItemWidth - self.indicatorLineWidth) / 2;
        CGFloat x = (offsetX / scrollViewWidth) * self.menuItemWidth + space;
        [self setLineWithOriginX:x];
        // > half
        NSInteger idx = (offsetX + scrollViewWidth * 0.5) / scrollViewWidth;
        [self setMenuWithIndex:idx];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        float xx = scrollView.contentOffset.x * (_menuItemWidth / self.view.bounds.size.width) - _menuItemWidth;
        [_menuView scrollRectToVisible:CGRectMake(xx, 0, self.view.bounds.size.width, _menuView.frame.size.height) animated:YES];
        NSInteger currentIndex = scrollView.contentOffset.x / self.view.bounds.size.width;
        [self setSelectSegmentIndex:currentIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; {
    float xx = scrollView.contentOffset.x * (_menuItemWidth / self.view.bounds.size.width) - _menuItemWidth;
    [_menuView scrollRectToVisible:CGRectMake(xx, 0, self.view.bounds.size.width, _menuView.frame.size.height) animated:YES];
}

#pragma mark - setter/getter
- (UIScrollView *)menuView {
    if (_menuView == nil) {
        _menuView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.menuHeight)];
        [_menuView setShowsVerticalScrollIndicator:NO];
        [_menuView setShowsHorizontalScrollIndicator:NO];
        _menuView.bounces = NO;
        _menuView.backgroundColor = self.menuViewBackgroundColor;
        
        if (self.menuType == SegmentMenuTypeScroll) {
            _menuView.contentSize = CGSizeMake(self.menuItemWidth * self.subViewControllers.count, self.menuHeight);
        } else {
            _menuView.contentSize = CGSizeMake(self.view.bounds.size.width, self.menuHeight);
        }
        
        NSMutableArray *titleArray = @[].mutableCopy;
        for (UIViewController *vc in self.subViewControllers) {
            [titleArray addObject:vc.title];
        }
        
        if (self.menuItemWidth == 0) {
            self.menuItemWidth = self.view.bounds.size.width / [titleArray count];
        }
        if (self.indicatorLineWidth == 0) {
            self.indicatorLineWidth = self.menuItemWidth;
        }

        for (NSInteger index = 0; index < titleArray.count; index++) {
            UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            segmentBtn.frame = CGRectMake(self.menuItemWidth * index, 0, self.menuItemWidth, self.menuHeight);
            [segmentBtn setTitle:titleArray[index] forState:UIControlStateNormal];
            segmentBtn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
            segmentBtn.tag = index + HEADBTN_TAG;
            [segmentBtn setTitleColor:self.titleColor forState:UIControlStateNormal];
            [segmentBtn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
            [segmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_menuView addSubview:segmentBtn];
        }
        
        [_menuView addSubview:self.lineView];
    }
    return _menuView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.menuHeight - self.indicatorLineHeight, self.indicatorLineWidth, self.indicatorLineHeight)];
        _lineView.backgroundColor = self.indicatorLineColor;
    }
    return _lineView;
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.menuHeight, self.view.frame.size.width, self.view.frame.size.height - self.menuHeight)];
        _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * [self.subViewControllers count], self.view.frame.size.height - self.menuHeight);
        [_mainScrollView setPagingEnabled:YES];
        if (self.contentStyle == SegmentContentStyleScroll) {
            _mainScrollView.scrollEnabled = YES;
        } else {
            _mainScrollView.scrollEnabled = NO;
        }
        [_mainScrollView setShowsVerticalScrollIndicator:NO];
        [_mainScrollView setShowsHorizontalScrollIndicator:NO];
        _mainScrollView.bounces = NO;
        _mainScrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }

        [self.subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
            viewController.view.frame = CGRectMake(idx * self.mainScrollView.frame.size.width, 0, self.mainScrollView.frame.size.width, _mainScrollView.frame.size.height);
            [_mainScrollView addSubview:viewController.view];
            [self addChildViewController:viewController];
        }];
    }
    return _mainScrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
