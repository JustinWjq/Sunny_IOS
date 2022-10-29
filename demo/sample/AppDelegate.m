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



@end
