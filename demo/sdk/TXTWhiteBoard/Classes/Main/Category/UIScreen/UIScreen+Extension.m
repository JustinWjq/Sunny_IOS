//
//  UIScreen+Extension.m
//  Weibo11
//
//  Created by JYJ on 15/12/8.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import "UIScreen+Extension.h"

@implementation UIScreen (Extension)

+ (CGSize)ff_screenSize {
    return [UIScreen mainScreen].bounds.size;
}

+ (BOOL)ff_isRetina {
    return [UIScreen ff_scale] >= 2;
}

+ (CGFloat)ff_scale {
    return [UIScreen mainScreen].scale;
}

+ (BOOL)isIPhoneXSeries {
    BOOL iPhoneXSeries = NO;
    // 先判断设备是否是iPhone/iPod
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        // 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

@end
