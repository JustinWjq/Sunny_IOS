//
//  showWebViewController.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2021/4/12.
//  Copyright © 2021 洪青文. All rights reserved.
//

#import "showWebViewController.h"
#import <WebKit/WebKit.h>
#import "UIAlertUtil.h"
#import "TXTCommon.h"


@interface showWebViewController ()
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) WKWebViewConfiguration *config;
@property (strong, nonatomic) UIButton *muteBtn;
@property (strong, nonatomic) UIButton *endButton;
@end

@implementation showWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化导航栏
    UIBarButtonItem *lefBarItem = [[UIBarButtonItem alloc] initWithTitle:@" <" style:UIBarButtonItemStylePlain target:self action:@selector(onQuitClassRoom)];
    self.navigationItem.leftBarButtonItem = lefBarItem;
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    // 导航栏左右按钮字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)setType:(NSString *)type{
    _type = type;
    if ([_type isEqualToString:@"0"]) {
        self.endButton.hidden = NO;
    }else{
        if ([_actionType isEqualToString:@"0"]) {
            //推送
            NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":@"wxPushWebFileSuccess",@"userId":_type};
            NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
            [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
                NSLog(@"发消息");
            }];
        }
        self.endButton.hidden = YES;
    }
    self.title = [NSString stringWithFormat:@"%@",_productName];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setUI];
}

- (void)setUI{
    
    //初始化
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    //1.网络
    _webView.allowsBackForwardNavigationGestures = YES;
    NSLog(@"_webView = %@",self.url);

    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    self.muteBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width- Adapt(70), Screen_Height-Adapt(100), Adapt(50), Adapt(50))];
   [self.muteBtn addTarget:self action:@selector(muteLocalAudio) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.muteBtn];
    if (self.userModel.showAudio) {
        [self.muteBtn setImage:[UIImage imageNamed:@"landscape-unmute" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }else{
        [self.muteBtn setImage:[UIImage imageNamed:@"landscape-mute" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }
    self.endButton = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width-116, kTopHeight+20, 100, 30)];
    [self.endButton setTitle:@"结束共享" forState:UIControlStateNormal];
    [self.endButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.endButton setBackgroundColor:[UIColor redColor]];
    self.endButton.tag = 90;
    [self.endButton addTarget:self action:@selector(onQuitClassRoom) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.endButton];
    if ([self.type isEqualToString:@"0"]) {
        self.endButton.hidden = NO;
    }else{
        self.endButton.hidden = YES;
    }
}

- (void)setUserModel:(TXTUserModel *)userModel{
    _userModel = userModel;
    if (_userModel.showAudio) {
        [self.muteBtn setImage:[UIImage imageNamed:@"landscape-unmute" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }else{
        [self.muteBtn setImage:[UIImage imageNamed:@"landscape-mute" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }
}


- (void)onQuitClassRoom{
    [UIAlertUtil showAlertWithPersentViewController:self alertCallBack:^(NSInteger index) {
        if (index == 0) {
            
        }else{
            if ([self.type isEqualToString:@"0"]) {
                //结束共享
                NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),
                                              @"type":@"wxShareWebFileEnd",
                                              @"userId":TXUserDefaultsGetObjectforKey(@"miniUserId"),
                                              @"fromUserId":[TICConfig shareInstance].userId,
                                              @"toUserId":TXUserDefaultsGetObjectforKey(@"miniUserId")};
                NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
                [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
                    
                    NSDictionary *bodydic = @{@"webId":self.webId,@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"userId":[TICConfig shareInstance].userId};
                    [[AFNHTTPSessionManager shareInstance] requestURL:ShareWebs_Stop RequestWay:@"POST" Header:nil Body:bodydic params:nil isFormData:NO success:^(NSError *error, id response) {
                        NSString *errCode = [response valueForKey:@"errCode"];
                        if ([errCode intValue] == 0) {
                            [self.navigationController popViewControllerAnimated:YES];
                            if (self.delegate && [self.delegate respondsToSelector:@selector(hideshowview)]) {
                                NSLog(@"=======++++++==");
                                [self.delegate hideshowview];
                            }
    //                        [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    } failure:^(NSError *error, id response) {
                        
                    }];
                    
                }];
            }else{
                NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),
                                              @"type":@"wxShareWebFileEnd",
                                              @"userId":self.type,
                                              @"fromUserId":self.type,
                                              @"toUserId":[TICConfig shareInstance].userId};
                NSLog(@"wxShareWebFileEnd = %@",[messagedict description]);
                NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
                [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
                    [self.navigationController popViewControllerAnimated:YES];
                    NSLog(@"=========");
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(hideshowview)]) {
//                        [self.delegate hideshowview];
//                    }
                }];
            }
            
        }
    } title:@"请问是否结束共享" message:@"" cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
}

- (void)muteLocalAudio{
    if (self.delegate && [self.delegate respondsToSelector:@selector(muteAction:)]) {
        NSLog(@"muteLocalAudio");
        [self.delegate muteAction:self];
    }
}


@end
