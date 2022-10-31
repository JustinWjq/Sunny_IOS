//
//  UIButton+Extension.m
//  Innersect
//
//  Created by ndm on 2019/7/22.
//  Copyright © 2019 innersect. All rights reserved.
//

#import "UIButton+Extension.h"
#import "objc/runtime.h"

static const void * bindValueP = &bindValueP;

@implementation UIButton (Extension)

static char ActionTag;

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;
  
- (void)setEnlargeEdge:(CGFloat) size
{
 objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
 objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
 objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
 objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
  
- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
 objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
 objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
 objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
 objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
  
- (CGRect) enlargedRect
{
 NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
 NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
 NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
 NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
 if (topEdge && rightEdge && bottomEdge && leftEdge)
 {
  return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
       self.bounds.origin.y - topEdge.floatValue,
       self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
       self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
 }
 else
 {
  return self.bounds;
 }
}
  
- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
 CGRect rect = [self enlargedRect];
 if (CGRectEqualToRect(rect, self.bounds))
 {
  return [super hitTest:point withEvent:event];
 }
 return CGRectContainsPoint(rect, point) ? self : nil;
}



- (void)addAction:(ButtonBlock)block forControlEvents:(UIControlEvents)controlEvents {
    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(action:) forControlEvents:controlEvents];
}

- (void)action:(id)sender {
    ButtonBlock blockAction = (ButtonBlock)objc_getAssociatedObject(self, &ActionTag);
    if (blockAction) {
        blockAction(self);
    }
}

- (void)edgePosition:(ButtonPosition)edgePosition gap:(CGFloat)gap {
    if (edgePosition == ButtonPositionWithLeftTitleRightImage) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width-gap/2, 0, self.imageView.bounds.size.width)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width+gap/2, 0, -self.titleLabel.bounds.size.width)];
    }else if(edgePosition == ButtonPositionWithTopImageBottomTitle){
        [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.bounds.size.height+gap/2 ,-self.imageView.bounds.size.width, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width/2, self.titleLabel.bounds.size.height+gap/2, -self.titleLabel.bounds.size.width/2)];
    }else if(edgePosition == ButtonPositionWithTopTitleBottomImage){
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-self.imageView.bounds.size.height-gap/2 ,-self.imageView.bounds.size.width, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(self.titleLabel.bounds.size.height+gap/2, 0, 0, -self.titleLabel.bounds.size.width)];
    }else{
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, gap/2, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, -gap/2, 0, 0)];
    }
}

@dynamic bindValue;

-(void)setBindValue:(NSString *)bindValue{
    objc_setAssociatedObject(self, bindValueP, bindValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)bindValue {
  return objc_getAssociatedObject(self, bindValueP);
}



//-(void)drawRect:(CGRect)rect {
//    // 获取图形上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGFloat width = rect.size.width;
//    
//    /**
//     
//     画实心圆
//     */
//    CGRect frame = CGRectMake(self.frame.size.width + width/4,
//                              self.frame.size.width + width/4,
//                              rect.size.width - self.frame.size.width*2 - width/2,
//                              rect.size.height - self.frame.size.width*2 - width/2);
//    //填充当前绘画区域内的颜色
//    [[UIColor whiteColor] set];
//    //填充当前矩形区域
//    CGContextFillRect(ctx, rect);
//    //以矩形frame为依据画一个圆
//    CGContextAddEllipseInRect(ctx, frame);
//    //填充当前绘画区域内的颜色
//    [[UIColor orangeColor] set];
//    //填充(沿着矩形内围填充出指定大小的圆)
//    CGContextFillPath(ctx);
//    
//    /**
//     *  画空心圆
//     */
//    CGRect bigRect = CGRectMake(rect.origin.x + self.frame.size.width,
//                                rect.origin.y+ self.frame.size.width,
//                                rect.size.width - self.frame.size.width*2,
//                                rect.size.height - self.frame.size.width*2);
//    
//    //设置空心圆的线条宽度
//    CGContextSetLineWidth(ctx, self.frame.size.width);
//    //以矩形bigRect为依据画一个圆
//    CGContextAddEllipseInRect(ctx, bigRect);
//    //填充当前绘画区域的颜色
//    [[UIColor greenColor] set];
//    //(如果是画圆会沿着矩形外围描画出指定宽度的（圆线）空心圆)/（根据上下文的内容渲染图层）
//    CGContextStrokePath(ctx);
//}

@end
