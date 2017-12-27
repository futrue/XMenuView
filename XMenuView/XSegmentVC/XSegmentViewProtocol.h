//
//  XSegmentViewProtocol.h
//  XMenuView
//
//  Created by SongGuoxing on 2017/12/13.
//  Copyright © 2017年 SGX. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XSegmentViewProtocol <NSObject>
/** 位于目录和容器中间的特殊view */
- (UIView *)viewBetweenMenuAndContent;
/** index更新 */
- (void)segmentChangedIndex:(NSInteger)index;
@end
