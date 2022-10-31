//
//  UIView+cornerSide.m
//  KYH
//
//  Created by tulin on 2020/3/19.
//  Copyright © 2020 AIA. All rights reserved.
//

#import "UIView+cornerSide.h"


@implementation UIView (cornerSide)


- (void)cornerSideType:(QFSideType)sideType withCornerRadius:(CGFloat)cornerRadius
{
    CGSize cornerSize = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *maskPath;
    
    switch (sideType) {
        case QFSideTypeTop:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                   cornerRadii:cornerSize];
        }
            break;
        case QFSideTypeLeft:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft)
                                                   cornerRadii:cornerSize];
        }
            break;
        case QFSideTypeBottom:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                                   cornerRadii:cornerSize];
        }
            break;
        case QFSideTypeRight:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight)
                                                   cornerRadii:cornerSize];
        }
            break;
        default:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:UIRectCornerAllCorners
                                                   cornerRadii:cornerSize];
        }
            break;
    }
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.layer.mask = maskLayer;
    
    [self.layer setMasksToBounds:YES];
}
 
 
- (void)cornerSideAngleType:(QFSideAngleType)sideType withCornerRadius:(CGFloat)cornerRadius
{
    CGSize cornerSize = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *maskPath;
    
    switch (sideType) {
        case QFSideAngleTypeTopLeft:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopLeft)
                                                   cornerRadii:cornerSize];
        }
            break;
        case QFSideAngleTypeTopRight:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerTopRight)
                                                   cornerRadii:cornerSize];
        }
            break;
        case QFSideAngleTypeBottomLeft:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerBottomLeft)
                                                   cornerRadii:cornerSize];
        }
            break;
        case QFSideAngleTypeBottomRight:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:(UIRectCornerBottomRight)
                                                   cornerRadii:cornerSize];
        }
            break;
        default:
        {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                             byRoundingCorners:UIRectCornerAllCorners
                                                   cornerRadii:cornerSize];
        }
            break;
    }
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.layer.mask = maskLayer;
    
    [self.layer setMasksToBounds:YES];
}
 
- (void)cornerSideType:(QFSideType)sideType lineColor:(UIColor *)color lineWidth:(CGFloat)width
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    switch (sideType) {
        case QFSideTypeTop:
        {
            [aPath moveToPoint:CGPointMake(0.0, 0.0)];
            [aPath addLineToPoint:CGPointMake(self.frame.size.width, 0.0)];
        }
            break;
        case QFSideTypeLeft:
        {
            [aPath moveToPoint:CGPointMake(0.0, 0.0)];
            [aPath addLineToPoint:CGPointMake(0.0, self.frame.size.height)];
        }
            break;
        case QFSideTypeBottom:
        {
            [aPath moveToPoint:CGPointMake(0.0, self.frame.size.height)];
            [aPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        }
            break;
        case QFSideTypeRight:
        {
            [aPath moveToPoint:CGPointMake(self.frame.size.width,0.0)];
            [aPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
            
        }
            break;
        default:
        {
            
        }
            break;
    }
    
    layer.path = aPath.CGPath;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = width;
    [self.layer addSublayer:layer];
}


/**
 设置大小不同的圆角
 @param cornerRadii    每个圆角的大小
 */
- (void)cornerTopLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight{
    
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    
    //获取四个圆心
    CGFloat topLeftCenterX = minX +  topLeft;
    CGFloat topLeftCenterY = minY + topLeft;
     
    CGFloat topRightCenterX = maxX - topRight;
    CGFloat topRightCenterY = minY + topRight;
    
    CGFloat bottomLeftCenterX = minX +  bottomLeft;
    CGFloat bottomLeftCenterY = maxY - bottomLeft;
     
    CGFloat bottomRightCenterX = maxX -  bottomRight;
    CGFloat bottomRightCenterY = maxY - bottomRight;
    
    //  设置路径
    //虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY, topLeft, M_PI, M_PI*3/2, false);
    CGPathAddArc(path, NULL, topRightCenterX, topRightCenterY, topRight, M_PI*3/2, 0, false);
    CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, bottomRight, 0, M_PI/2, false);
    CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, bottomLeft, M_PI/2, M_PI, false);
    
    CGPathCloseSubpath(path);
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path;
    
    self.layer.mask = maskLayer;
    
    CGPathRelease(path);
    
    
}


@end
