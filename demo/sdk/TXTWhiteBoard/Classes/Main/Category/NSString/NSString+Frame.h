//
//  NSString+Frame.h
//  KDLC
//
//  Created by appleMac on 16/3/24.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Frame)

/**
 *  获取字符串占得size
 *
 *  @param fontSize 字体大小（使用默认字体）
 *
 *  @return size
 */
- (CGSize)sizeWithFontSize:(CGFloat)fontSize;

/**
 *  获取字符串占得size
 *
 *  @param font 字体
 *
 *  @return size
 */
- (CGSize)sizeWithSystemFont:(UIFont *)font;

/**
 *  获取在固定宽度/高度的组件中占得size
 *
 *  @param fontSize 字体大小
 *  @param width    宽度
 *  @param height   高度
 *
 *  @return size
 */
- (CGSize)sizewithFontSize:(CGFloat)fontSize maxWidth:(CGFloat)width maxHeight:(CGFloat)height;

/**
 *  获取在固定宽度/高度的组件中占得size
 *
 *  @param font     字体
 *  @param width    宽度
 *  @param height   高度
 *
 *  @return size
 */
- (CGSize)sizewithSystemFont:(UIFont *)font maxWidth:(CGFloat)width maxHeight:(CGFloat)height;

/**
 *  获取字符串在宽度为整个屏幕宽度情况下所占高度
 *
 *  @param fontSize 字体大小
 *
 *  @return 高度
 */
- (CGFloat)heightWIthFontSize:(CGFloat)fontSize;

/**
 *  获取字符串在宽度为整个屏幕宽度情况下所占高度
 *
 *  @param font     字体
 *
 *  @return 高度
 */
- (CGFloat)heightWithSystemFont:(UIFont *)font;

/**
 *  获取在值定宽度情况下的高度
 *
 *  @param fontSize 字体大小
 *  @param width    制定宽度
 *
 *  @return 高度
 */
- (CGFloat)heightWIthFontSize:(CGFloat)fontSize maxWidth:(CGFloat)width;

/**
 *  获取在值定宽度情况下的高度
 *
 *  @param font  字体
 *  @param width 指定宽度
 *
 *  @return 高度
 */
- (CGFloat)heightWithSystemFont:(UIFont *)font maxWidth:(CGFloat)width;

/**
 *  获取字符串在不考虑换行情况下所占的最大宽度
 *
 *  @param fontSize 字体大小
 *
 *  @return 宽度
 */
- (CGFloat)widthWithFontSize:(CGFloat)fontSize;

/**
 *  获取字符串在不考虑换行情况下所占的最大宽度
 *
 *  @param font 字体
 *
 *  @return 宽度
 */
- (CGFloat)widthWithSystemFont:(UIFont *)font;

@end
