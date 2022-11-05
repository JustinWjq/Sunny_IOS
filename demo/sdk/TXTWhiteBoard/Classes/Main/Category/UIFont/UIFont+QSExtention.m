//
//  UIFont+QSExtention.m
//  CalfSports
//
//  Created by 周结兵 on 2017/12/5.
//  Copyright © 2017年 宏鹿. All rights reserved.
//

#import "UIFont+QSExtention.h"

@implementation UIFont (QSExtention)

+ (UIFont *)qs_semiFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    if (!font)
    {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (UIFont *)qs_lightFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Light" size:size];
    if (!font)
    {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (UIFont *)qs_regularFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    if (!font)
    {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (UIFont *)qs_mediumFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    if (!font)
    {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (UIFont *)qs_arialBoldFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:size];
    if (!font)
    {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}



+ (UIFont *)qs_arialBlackFontWithSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"Arial-Black" size:size];
    if (!font)
    {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

/**
 苹果Arial字体
 
 @param size 大小
 @return 字体
 */
+ (UIFont *)qs_arialFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"Arial" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (UIFont *)qs_reejiGBFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"Reeji-CloudRuiHei-GB-Regular" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}
@end
