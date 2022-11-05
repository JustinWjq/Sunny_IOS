//
//  UIColor+Extention.h
//  PublicBus
//
//  Created by chefeng on 16/9/21.
//  Copyright © 2016年 Hangzhou Reformer Holding CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extention)

+ (UIColor *)colorWithHexStr:(NSString *)hexColorStr;
+ (UIColor *)colorWithHexStr:(NSString *)hexColorStr alpha:(CGFloat )alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexColorStr;
+ (UIColor *)colorWithHexString:(NSString *)hexColorStr alpha:(CGFloat )alpha;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
