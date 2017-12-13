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
@property (nonatomic, strong) UIScrollView *menuView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, assign) BOOL isLineAnimation;
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
    _buttonHeight = 40;
    _bottomLineColor = [UIColor redColor];
    _bottomLineHeight = 3;
}

- (void)addToParentViewController:(UIViewController *)parent {
    // 加载子视图
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.menuView];
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
    CGFloat x = index * _buttonWidth;
    self.isLineAnimation = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self setLineWithOriginX:x];
        [self.mainScrollView scrollRectToVisible:CGRectMake(index  * self.mainScrollView.bounds.size.width, 0, self.mainScrollView.bounds.size.width, self.mainScrollView.bounds.size.height) animated:YES];
    } completion:^(BOOL finished) {
        self.isLineAnimation = NO;
    }];
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
        CGFloat x = (offsetX / scrollViewWidth) * _buttonWidth;
        [self setLineWithOriginX:x];
        // > half
        NSInteger idx = (offsetX + scrollViewWidth * 0.5) / scrollViewWidth;
        [self setMenuWithIndex:idx];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        float xx = scrollView.contentOffset.x * (_buttonWidth / self.view.bounds.size.width) - _buttonWidth;
        [_menuView scrollRectToVisible:CGRectMake(xx, 0, self.view.bounds.size.width, _menuView.frame.size.height) animated:YES];
        NSInteger currentIndex = scrollView.contentOffset.x / self.view.bounds.size.width;
        [self setSelectSegmentIndex:currentIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; {
    if (scrollView == _mainScrollView) {
    }
    float xx = scrollView.contentOffset.x * (_buttonWidth / self.view.bounds.size.width) - _buttonWidth;
    [_menuView scrollRectToVisible:CGRectMake(xx, 0, self.view.bounds.size.width, _menuView.frame.size.height) animated:YES];
}

#pragma mark - setter/getter
- (UIScrollView *)menuView {
    if (_menuView == nil) {
        _menuView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.buttonHeight)];
        [_menuView setShowsVerticalScrollIndicator:NO];
        [_menuView setShowsHorizontalScrollIndicator:NO];
        _menuView.bounces = NO;
        _menuView.backgroundColor = self.menuViewBackgroundColor;
        
        if (self.menuType == SegmentMenuTypeScroll) {
            _menuView.contentSize = CGSizeMake(self.buttonWidth * self.subViewControllers.count, self.buttonHeight);
        } else {
            _menuView.contentSize = CGSizeMake(self.view.bounds.size.width, self.buttonHeight);
        }
        
        NSMutableArray *titleArray = @[].mutableCopy;
        for (UIViewController *vc in self.subViewControllers) {
            [titleArray addObject:vc.title];
        }
        
        if (self.buttonWidth == 0) {
            self.buttonWidth = self.view.bounds.size.width / [titleArray count];
        }

        for (NSInteger index = 0; index < titleArray.count; index++) {
            UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            segmentBtn.frame = CGRectMake(self.buttonWidth * index, 0, self.buttonWidth, self.buttonHeight);
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
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.buttonHeight - self.bottomLineHeight, self.buttonWidth, self.bottomLineHeight)];
        _lineView.backgroundColor = self.bottomLineColor;
    }
    return _lineView;
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.buttonHeight, self.view.frame.size.width, self.view.frame.size.height - self.buttonHeight)];
        _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * [self.subViewControllers count], self.view.frame.size.height - self.buttonHeight);
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
