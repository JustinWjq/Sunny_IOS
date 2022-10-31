//
//  AppDelegate.m
//  sample
//
//  Created by 洪青文 on 2020/9/4.
//  Copyright © 2020 洪青文. All rights reserved.
//

#import "AppDelegate.h"
#import "hehhheViewController.h"
#import "TXTThirdSDK/OpenSDK1.8.7.1_NoPay/WXApi.h"

@interface AppDelegate ()<WXApiDelegate>
/// 是否允许转向


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    hehhheViewController *baseView = [[hehhheViewController alloc]initWithNibName:@"hehhheViewController" bundle:[NSBundle mainBundle]];
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:baseView];
      
      self.window.rootViewController = nav;
      [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

///// 如果属性值为YES，仅允许屏幕向左旋转，否则仅允许竖屏。
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {

    if (self.allowRotation) {

        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;

    }else if(self.rightRotation) {

        return UIInterfaceOrientationMaskLandscapeRight;

    }

    return UIInterfaceOrientationMaskPortrait;

}


@end
