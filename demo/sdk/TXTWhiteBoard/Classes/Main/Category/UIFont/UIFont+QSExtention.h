//
//  UIFont+QSExtention.h
//  CalfSports
//
//  Created by 周结兵 on 2017/12/5.
//  Copyright © 2017年 宏鹿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (QSExtention)

/**
 苹果semi字体
 
 @param size 大小
 @return 字体
 */
+ (UIFont *)qs_semiFontWithSize:(CGFloat)size;

/**
 苹果light字体
 
 @param size 大小
 @return 字体
 */
+ (UIFont *)qs_lightFontWithSize:(CGFloat)size;

/**
 苹果regular字体
 
 @param size 大小
 @return 字体
 */
+ (UIFont *)qs_regularFontWithSize:(CGFloat)size;
/**
 苹果medium字体
 
 @param size 大小
 @return 字体
 */
+ (UIFont *)qs_mediumFontWithSize:(CGFloat)size;

/**
 苹果Arial-BoldMT字体
 
 @param size 大小
 @return 字体
 */
+ (UIFont *)qs_arialBoldFontWithSize:(CGFloat)size;

/**
 苹果Arial-Black字体
 
 @param size 大小
 @return 字体
 */
+ (UIFont *)qs_arialBlackFontWithSize:(CGFloat)size;

/**
 苹果Arial字体
 
 @param size 大小
 @return 字体
 */
+ (UIFont *)qs_arialFontWithSize:(CGFloat)size;

/**
 苹果Reeji-CloudRuiHei-GB-Regular字体
 
 @param size 大小
 @return 字体
 */
+ (UIFont *)qs_reejiGBFontWithSize:(CGFloat)size;

@end
