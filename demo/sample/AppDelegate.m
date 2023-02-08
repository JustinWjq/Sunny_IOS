//
//  AppDelegate.m
//  sample
//
//  Created by 洪青文 on 2020/9/4.
//  Copyright © 2020 洪青文. All rights reserved.
//
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "TXTThirdSDK/OpenSDK1.8.7.1_NoPay/WXApi.h"
#import <TXTWhiteBoard/TXTManage.h>
#import "hehhheViewController.h"


@interface AppDelegate ()<WXApiDelegate,TXTManageDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    HomeViewController *baseView = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:baseView];
    
    hehhheViewController *baseView = [[hehhheViewController alloc]initWithNibName:@"hehhheViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:baseView];
    [nav setNavigationBarHidden:YES animated:NO];
    
//把背景设为空，image设为nil的话会有一个半透明黑色图层，设为一个没有内容的图片，导航栏就是透明的了，view的布局从0，0开始，会被遮挡。
    [nav.navigationBar setBackgroundImage:[AppDelegate imageWithColor:[UIColor redColor] withFrame:CGRectMake(0, 0, 1, 1)]
                            forBarMetrics:UIBarMetricsDefault];
    
    // 导航栏标题颜色
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
    // 导航栏按钮颜色
    [nav.navigationBar setTintColor:[UIColor blueColor]];

    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [TXTManage sharedInstance].manageDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationAction:) name:@"addFriendBtListener" object:nil];

//    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
//        NSLog(@"log : %@", log);
//    }];
//    [WXApi registerApp:@"wx8e6096173bff1149" universalLink:@"https://video-sells-test.ikandy.cn/txWhiteBoard/"];
//    //调用自检函数
//    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
//        NSLog(@"checkUniversalLinkReady = %@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
//    }];
    return YES;
}

///// 如果属性值为YES，仅允许屏幕向左旋转，否则仅允许竖屏。
//-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    if (self.allowRotation) {
//        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
//    }else if(self.rightRotation) {
//        return UIInterfaceOrientationMaskLandscapeRight;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//
//}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    NSLog(@"handleOpenUniversalLink");
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

//- (void)onReq:(BaseReq *)req{
//    NSLog(@"onReq = %@",req);
//}

- (void)onFriendBtListener:(NSString *)roomId AndserviceId:(NSString *)serviceId inviteAccount:(NSString *)userId CurrentWindow:(UIWindow *)window{
    NSLog(@"onFriendBtListener==========");
    //    [self didtxt];
}

- (void)getNotificationAction:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];
    // 这样就得到了我们在发送通知时候传入的字典了
    NSLog(@"分享成功");
    NSString *roomId = [infoDic valueForKey:@"inviteNumber"];
    NSString *serviceId = [infoDic valueForKey:@"serviceId"];
    NSString *userId = [infoDic valueForKey:@"userId"];
    NSLog(@"%@--%@--%@--%@",roomId,serviceId,userId,[infoDic valueForKey:@"currentWindow"]);
    [[NSUserDefaults standardUserDefaults] setObject:serviceId forKey:@"testserviceId"];
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if(window == self.window) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return  UIInterfaceOrientationMaskAll;
    }
}

+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame
{
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
