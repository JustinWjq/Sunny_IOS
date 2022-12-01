//
//  TXTNavigationController.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/11/9.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTNavigationController.h"

@interface TXTNavigationController ()
/** isGoBackgroud */
@property (nonatomic, assign) BOOL isGoBackgroud;
@end

@implementation TXTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#424548"];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationBar.barStyle = UIBarStyleBlack;
    
    
    //进入后台UIApplicationDidEnterBackgroundNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    //进入后台UIApplicationDidEnterBackgroundNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    self.isGoBackgroud = NO;
}

/// didBecomeActive
- (void)didBecomeActive {
    self.isGoBackgroud = NO;
}

/// didEnterBackground
- (void)didEnterBackground {
    self.isGoBackgroud = YES;
}

//是否自动旋转,返回YES可以自动旋转
- (BOOL)shouldAutorotate {
    if (self.isGoBackgroud) return NO;
    return YES;
}
//返回支持的方向
- (NSUInteger)supportedInterfaceOrientations {
    return self.interfaceOrientationMask;
}
//这个是返回优先方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.interfaceOrientation;
}
@end
