//
//  XSegmentVC.h
//  XMenuView
//
//  Created by SongGuoxing on 2017/12/12.
//  Copyright © 2017年 SongGuoxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSegmentViewProtocol.h"

typedef NS_ENUM(NSInteger, SegmentMenuType) {
    SegmentMenuTypeScroll, // 标签栏滚动
    SegmentMenuTypeFixed   // 标签栏固定
};

typedef NS_ENUM(NSInteger, SegmentContentStyle) {
    SegmentContentStyleScroll, // 内容可滚动
    SegmentContentStyleFixed   // 内容固定
};

@interface XSegmentVC : UIViewController

//每个标签对应ViewController数组
@property (nonatomic, strong) NSArray *subViewControllers;
//标签栏背景色
@property (nonatomic, strong) UIColor *menuViewBackgroundColor;
//非选中状态下标签字体颜色
@property (nonatomic, strong) UIColor *titleColor;
//选中标签字体颜色
@property (nonatomic, strong) UIColor *titleSelectedColor;
//标签字体大小
@property (nonatomic, assign) CGFloat fontSize;
//标签栏每个按钮高度
@property (nonatomic, assign) CGFloat menuHeight;
//选中标签下划宽度
@property (nonatomic, assign) CGFloat indicatorLineWidth;
//选中标签下划线高度
@property (nonatomic, assign) CGFloat indicatorLineHeight;
//选中标签底部划线颜色
@property (nonatomic, strong) UIColor *indicatorLineColor;
//标签栏类型，默认为滚动
@property (nonatomic, assign) SegmentMenuType menuType;
//内容类型，默认为滚动
@property (nonatomic, assign) SegmentContentStyle contentStyle;
//默认选中，默认为0
@property (nonatomic, assign) NSInteger defaultSelectIndex;


// 位于目录和滚动视图的中间的view，特殊情况会有
@property (nonatomic, weak) id <XSegmentViewProtocol> delegate;


- (void)addToParentViewController:(UIViewController *)parent;

@end
