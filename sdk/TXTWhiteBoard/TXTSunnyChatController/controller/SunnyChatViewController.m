//
//  SunnyChatViewController.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/10/21.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "SunnyChatViewController.h"
#import "bottomButtons.h"

@interface SunnyChatViewController ()<bottomButtonsDelegate>
@property (nonatomic, strong) bottomButtons *bottomToos;
@end

@implementation SunnyChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"远程会议";
    UIToolbar*tools=[[UIToolbar alloc]initWithFrame:CGRectMake(5, 0, 80, 39)];
    //解决出现的那条线
    tools.clipsToBounds = YES;
    //解决tools背景颜色的问题
    [tools setBackgroundImage:[UIImage new]forToolbarPosition:UIBarPositionAny                      barMetrics:UIBarMetricsDefault];
    [tools setShadowImage:[UIImage new]
       forToolbarPosition:UIToolbarPositionAny];
    //添加两个button
    NSMutableArray*buttons=[[NSMutableArray alloc]initWithCapacity:2];
    //扬声器
    UIBarButtonItem*button3=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"notextQuit" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStyleDone target:self action:@selector(press2)];
    //切换摄像头
    UIBarButtonItem*button2=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"switchCamera_select" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStyleDone target:self action:@selector(switchCamera)];
    button3.tintColor=[UIColor whiteColor];
    button2.tintColor=[UIColor whiteColor];
    [buttons addObject:button3];
    [buttons addObject:button2];
    [tools setItems:buttons animated:NO];
    UIBarButtonItem*btn=[[UIBarButtonItem alloc]initWithCustomView:tools];
    self.navigationItem.leftBarButtonItem=btn;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setBottomToolsUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)setBottomToolsUI{
    _bottomToos = [[bottomButtons alloc] init];
    [self.view addSubview:self.bottomToos];
    [_bottomToos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(80);
    }];
    _bottomToos.delegate = self;
}

- (bottomButtons *)bottomToos{
    if (!_bottomToos) {
        //WithFrame:CGRectMake(0, Screen_Height-80, Screen_Width, 80)
        
    }
    return _bottomToos;
}

#pragma  mark 横屏设置

//- (BOOL)shouldAutorotate{
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationLandscapeLeft;
//}



@end
