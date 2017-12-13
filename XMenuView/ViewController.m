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

@interface ViewController ()

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
    vc.view.frame = CGRectMake(10, 10, self.view.bounds.size.width - 20, 300);
    vc.subViewControllers = controlArray;
    [vc addToParentViewController:self];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
