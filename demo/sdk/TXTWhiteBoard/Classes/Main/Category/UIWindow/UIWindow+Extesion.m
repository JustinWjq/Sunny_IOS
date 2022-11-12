//
//  UIWindow+UIWindow_Extesion.m
//  62580
//
//  Created by JYJ on 2020/4/15.
//  Copyright © 2020 qscx. All rights reserved.
//

#import "UIWindow+Extesion.h"



@implementation UIWindow (UIWindow_Extesion)

+ (UIWindow *)getKeyWindow {
    UIWindow *window = nil;
    // 先判断系统
    if (@available(iOS 13, *)) {
        // 判断设备
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            // iPhone设备直接取windows第一个元素
            for (UIWindow *a_w in [UIApplication sharedApplication].windows) {
                if (a_w.isKeyWindow) {
                    window = a_w;
                }
            }
            // 没有keywindow 直接取第一个
            if (!window) { window = [UIApplication sharedApplication].windows.firstObject; }
            if (!window) {   // 如果window还是不存在
                // 检测是否未支持iOS 13新特性，未采用兼容方案，看AppDelegate中是否有window
                if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
                    window = [UIApplication sharedApplication].delegate.window;
                }
            }
        } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            // ipad设备获取keywindow
            for (UIWindow *a_w in [UIApplication sharedApplication].windows) {
                if (a_w.isKeyWindow) {
                    window = a_w;
                }
            }
            if (!window) {  // 如果也没取到keyWindow，拿第一个Window
                window = [UIApplication sharedApplication].windows.firstObject;
            }
        }
    } else {
        window = UIApplication.sharedApplication.keyWindow;
    }
    return window;
}


+ (BOOL)isLandscape {
    if (@available(iOS 13.0, *)) {
        UIWindow *firstWindow = [[[UIApplication sharedApplication] windows] firstObject];
        if (firstWindow == nil) { return NO; }

        UIWindowScene *windowScene = firstWindow.windowScene;
        if (windowScene == nil){ return NO; }

        return UIInterfaceOrientationIsLandscape(windowScene.interfaceOrientation);
    } else {
        return (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation));
    }
}
@end
