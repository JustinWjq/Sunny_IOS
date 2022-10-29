//
//  UIView+QFExtension.m
//  QFun
//
//  Created by tulin on 2020/5/15.
//  Copyright © 2020 ndm. All rights reserved.
//

#import "UIView+QFExtension.h"

@implementation UIView (QFExtension)

- (void)setQf_x:(CGFloat)qf_x{
    
    CGRect frame = self.frame;
    frame.origin.x = qf_x;
    self.frame = frame;
}
- (CGFloat)qf_x
{
    return self.frame.origin.x;
}

- (void)setQf_y:(CGFloat)qf_y{
    
    CGRect frame = self.frame;
    frame.origin.y = qf_y;
    self.frame = frame;
}
- (CGFloat)qf_y
{
    return self.frame.origin.y;
}

- (void)setQf_centerX:(CGFloat)qf_centerX{
    CGPoint center = self.center;
    center.x = qf_centerX;
    self.center = center;
}
- (CGFloat)qf_centerX
{
    return self.center.x;
}

- (void)setQf_centerY:(CGFloat)qf_centerY
{
    CGPoint center = self.center;
    center.y = qf_centerY;
    self.center = center;
}
- (CGFloat)qf_centerY
{
    return self.center.y;
}

- (void)setQf_width:(CGFloat)qf_width
{
    CGRect frame = self.frame;
    frame.size.width = qf_width;
    self.frame = frame;
}
- (CGFloat)qf_width
{
    return self.frame.size.width;
}

- (void)setQf_height:(CGFloat)qf_height
{
    CGRect frame = self.frame;
    frame.size.height = qf_height;
    self.frame = frame;
}
- (CGFloat)qf_height
{
    return self.frame.size.height;
}

- (void)setQf_size:(CGSize)qf_size
{
    CGRect frame = self.frame;
    frame.size = qf_size;
    self.frame = frame;
}
- (CGSize)qf_size
{
    return self.frame.size;
}

- (void)setQf_origin:(CGPoint)qf_origin
{
    CGRect frame = self.frame;
    frame.origin = qf_origin;
    self.frame = frame;
}

- (CGPoint)qf_origin
{
    return self.frame.origin;
}
- (CGFloat)qf_maxX{
    return self.frame.origin.x + self.frame.size.width;
}
- (CGFloat)qf_maxY{
    return self.frame.origin.y + self.frame.size.height;
}


/// 增加渐变色
/// @param colors 渐变色数组
- (void)addGradualLayerWithColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    
    CAGradientLayer *_gradientLayer = [CAGradientLayer layer];
    
    _gradientLayer.startPoint = startPoint;//第一个颜色开始渐变的位置
    _gradientLayer.endPoint = endPoint;//最后一个颜色结束的位置
    _gradientLayer.frame = self.bounds;//设置渐变图层的大小
    if (colors.count != 0) {
        _gradientLayer.colors = colors;
    }
    
    [self.layer insertSublayer:_gradientLayer atIndex:0];
}


/**
 从 XIB 中加载视图
 */
+ (instancetype)qf_loadViewFromXib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

@end
