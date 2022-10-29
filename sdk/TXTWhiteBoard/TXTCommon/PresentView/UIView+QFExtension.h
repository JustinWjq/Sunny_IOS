//
//  UIView+QFExtension.h
//  QFun
//
//  Created by tulin on 2020/5/15.
//  Copyright © 2020 ndm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (QFExtension)

@property (nonatomic, assign) CGFloat qf_x;
@property (nonatomic, assign) CGFloat qf_y;
@property (nonatomic, assign) CGFloat qf_width;
@property (nonatomic, assign) CGFloat qf_height;
@property (nonatomic, assign) CGFloat qf_centerX;
@property (nonatomic, assign) CGFloat qf_centerY;
@property (nonatomic, assign) CGSize  qf_size;
@property (nonatomic, assign) CGPoint qf_origin;
@property (nonatomic, assign, readonly) CGFloat qf_maxX;
@property (nonatomic, assign, readonly) CGFloat qf_maxY;


/// 增加渐变色
/// @param colors 渐变色数组
- (void)addGradualLayerWithColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 从 XIB 中加载视图
 */
+ (instancetype)qf_loadViewFromXib;

@end

NS_ASSUME_NONNULL_END
