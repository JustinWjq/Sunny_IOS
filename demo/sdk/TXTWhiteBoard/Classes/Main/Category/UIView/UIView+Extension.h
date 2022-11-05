//
//  HAScrollLabel.m
//  仿网易新闻滚动列表
//
//  Created by haha on 15/3/19.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign,readonly) CGFloat maxX;
@property (nonatomic, assign,readonly) CGFloat maxY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;


/**
 * 自己写的view添加事件
 */
- (void)addTarget:(id)target action:(SEL)action;

- (UIView *)subViewByClassString:(NSString *)classString;
+ (void)drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius;

@end
