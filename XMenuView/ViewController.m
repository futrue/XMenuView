//
//  ViewController.m
//  XMenuView
//
//  Created by SongGuoxing on 2017/12/13.
//  Copyright © 2017年 SGX. All rights reserved.
//

#import "ViewController.h"
#import "XSegmentVC.h"
#define RandomColor [UIColor colorWithRed:(random()%255)/255.0 green:(random()%255)/255.0 blue:(random()%255)/255.0 alpha:1]

@interface ViewController ()<XSegmentViewProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"-menu-";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
        
    XSegmentVC *vc = [[XSegmentVC alloc]init];
    NSArray *titleArray = @[@"推荐", @"订阅", @"健康", @"资讯"];
    NSMutableArray *controlArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < titleArray.count; i ++) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.title = titleArray[i];
        vc.view.backgroundColor = RandomColor;
        [controlArray addObject:vc];
    }
    vc.menuViewBackgroundColor = [UIColor orangeColor];
    vc.defaultSelectIndex = 1;
    vc.indicatorLineWidth = 30;
//    vc.view.frame = CGRectMake(10, 10, self.view.bounds.size.width - 20, 300);
    vc.delegate = self;
    vc.subViewControllers = controlArray;
    [vc addToParentViewController:self];
    
}

#pragma mark - XSegmentViewProtocol
- (UIView *)viewBetweenMenuAndContent {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor purpleColor];
    label.text = @"这里可以放一些特殊的东西，比如广告啊啥的,因为现在是一个广告时代，很多APP会在各种地方加广告，也可能有其他的东西，若是不需要，不遵从代理不实现代理方法即可";
    [label sizeToFit];
    return label;
}

- (void)segmentChangedIndex:(NSInteger)index {
    NSLog(@"index == %li",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
