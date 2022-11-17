//
//  HAScrollLabel.m
//  仿网易新闻滚动列表
//
//  Created by haha on 15/3/19.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "UIView+Extension.h"

static char kLAActionHandlerTapGestureKey;
static char kLAActionHandlerTapBlockKey;

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}


- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
//    self.width = size.width;
//    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}


- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (void)addTarget:(id)target action:(SEL)action;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target
                                                                         action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (UIView *)subViewByClassString:(NSString *)classString
{
    UIView *subview = nil;
    for (UIView *view in self.subviews) {
        if ([NSStringFromClass(view.class) isEqualToString:classString]) {
            subview = view;
            break;
        }
    }
    if (!subview) {
        for (UIView *view in self.subviews) {
            subview = [view subViewByClassString:classString];
            if (subview) {
                break;
            }
        }
    }
    return subview;
}

+ (void)drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rrect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
}

//- (void)setTapActionWithBlock:(void (^)(void))block {
//    // 运行时获取单击对象
//    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kLAActionHandlerTapGestureKey);
//    if (!gesture) {
//        // 如果没有该对象，就创建一个
//        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
//        [self addGestureRecognizer:gesture];
//        // 绑定一下gesture
//        objc_setAssociatedObject(self, &kLAActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
//    }
//    // 绑定一下block
//    objc_setAssociatedObject(self, &kLAActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
//}
//
//- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
//    if (gesture.state == UIGestureRecognizerStateRecognized) {
//        // 取出上面绑定的block
//        void(^action)(void) = objc_getAssociatedObject(self, &kLAActionHandlerTapBlockKey);
//        if (action) {
//            action();
//        }
//    }
//}



@end
