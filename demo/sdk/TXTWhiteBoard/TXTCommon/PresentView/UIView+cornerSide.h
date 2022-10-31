//
//  UIView+cornerSide.h
//  KYH
//
//  Created by tulin on 2020/3/19.
//  Copyright © 2020 AIA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,QFSideType) {
    QFSideTypeTop    = 0,
    QFSideTypeLeft   = 1,
    QFSideTypeBottom = 2,
    QFSideTypeRight  = 3,
    QFSideTypeAll    = 4,
};
 
typedef NS_ENUM(NSInteger,QFSideAngleType) {
    QFSideAngleTypeTopLeft         = 0,
    QFSideAngleTypeTopRight        = 1,
    QFSideAngleTypeBottomLeft      = 2,
    QFSideAngleTypeBottomRight     = 3,
    QFSideAngleTypeAll             = 4,
};


@interface UIView (cornerSide)

/**
 设置不同边的圆角
 @param sideType        圆角类型
 @param cornerRadius    圆角半径
 */
- (void)cornerSideType:(QFSideType)sideType withCornerRadius:(CGFloat)cornerRadius;
 
 
/**
 设置不同角的圆角
 @param sideType        圆角类型
 @param cornerRadius    圆角半径
 */
- (void)cornerSideAngleType:(QFSideAngleType)sideType withCornerRadius:(CGFloat)cornerRadius;
 
 
/**
 设置view某一边框
 @param sideType    哪个边
 @param color       边框颜色
 @param width       边框宽度
 */
- (void)cornerSideType:(QFSideType)sideType lineColor:(UIColor *)color lineWidth:(CGFloat)width;


/**
 设置大小不同的圆角
 @param topLeft    顶左圆角的大小
 @param topRight    顶右圆角的大小
 @param bottomLeft    底左圆角的大小
 @param bottomRight    底右圆角的大小
 */
- (void)cornerTopLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight;



@end

NS_ASSUME_NONNULL_END
