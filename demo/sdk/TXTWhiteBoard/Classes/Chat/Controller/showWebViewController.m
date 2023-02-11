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


@interface showWebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) WKWebViewConfiguration *config;
@property (strong, nonatomic) UIButton *muteBtn;
@property (strong, nonatomic) UIButton *endButton;

@property (nonatomic, copy) NSMutableString *cookieStr;
@property (nonatomic, strong) NSArray *cookieArray;
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
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    configuration.preferences = [[WKPreferences alloc] init];
    configuration.preferences.minimumFontSize = 10;
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // 默认认为YES
    configuration.preferences.javaScriptEnabled = YES;
    WKUserContentController *userContentController = [WKUserContentController new];
    configuration.userContentController = userContentController;
    configuration.allowsInlineMediaPlayback = YES;
    configuration.processPool = [[WKProcessPool alloc]init];

    //初始化
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) configuration:configuration];
    
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    
    //1.网络
    _webView.allowsBackForwardNavigationGestures = YES;
    NSLog(@"_webView = %@",self.url);

    NSDictionary *dictCookies = nil;
    if(self.cookieDict != nil) {
        NSMutableArray *tempArrCookies = [NSMutableArray array];
        //取出字典所有key
        NSArray *keyArray = [self.cookieDict allKeys];
        for (NSString *key in keyArray) {
            NSDictionary *dictCookie = [NSDictionary dictionaryWithObjectsAndKeys:key, NSHTTPCookieName,
                                               self.cookieDict[key], NSHTTPCookieValue,
                                            @"/", NSHTTPCookiePath,
                                            self.url, NSHTTPCookieDomain,nil];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dictCookie];
            [tempArrCookies addObject:cookie];
        }
        NSArray *arrCookies = [tempArrCookies copy];
        self.cookieArray = arrCookies;
        dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    if(dictCookies != nil) {
        [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField: @"Cookie"];
        
        NSMutableString *cookieStr = [NSMutableString stringWithFormat:@""];
        if (self.cookieArray) {
            for (NSHTTPCookie *cookie in self.cookieArray) {
                [cookieStr appendFormat:@"document.cookie = '%@=%@';\n", cookie.name, cookie.value];
            }
        }
        self.cookieStr = cookieStr.mutableCopy;

        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:self.cookieStr
                                                            injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                         forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        
        if (@available(iOS 11.0, *)) {
            WKHTTPCookieStore *cookieStore = _webView.configuration.websiteDataStore.httpCookieStore;
            for (NSHTTPCookie *cookie in self.cookieArray) {
                [cookieStore setCookie:cookie completionHandler:^{
                    
                }];
            }
        }
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:self.cookieArray forURL:[NSURL URLWithString:self.url] mainDocumentURL:nil];
    }
    
    [_webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    self.muteBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width- Adapt(70), Screen_Height-Adapt(100), Adapt(50), Adapt(50))];
//   [self.muteBtn addTarget:self action:@selector(muteLocalAudio) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.muteBtn];
    if (self.userModel.showAudio) {
        [self.muteBtn setImage:[UIImage imageNamed:@"landscape-unmute" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }else{
        [self.muteBtn setImage:[UIImage imageNamed:@"landscape-mute" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(muteLocalAudio)];
    [self.muteBtn addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.muteBtn addGestureRecognizer:pan];
    
    
    self.endButton = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width-116, kTopHeight+20, 100, 30)];
    [self.endButton setTitle:@"结束共享" forState:UIControlStateNormal];
    [self.endButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.endButton setBackgroundColor:[UIColor redColor]];
    self.endButton.tag = 90;
//    [self.endButton addTarget:self action:@selector(onQuitClassRoom) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.endButton];
    if ([self.type isEqualToString:@"0"]) {
        self.endButton.hidden = NO;
    }else{
        self.endButton.hidden = YES;
    }
    
    UIPanGestureRecognizer *endPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndPanGesture:)];
    [self.endButton addGestureRecognizer:endPan];
    
    UITapGestureRecognizer *endTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onQuitClassRoom)];
    [self.endButton addGestureRecognizer:endTap];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [webView evaluateJavaScript:self.cookieStr completionHandler:^(id result, NSError *error) {
        QSLog(@"cookie-------%@",result);
        decisionHandler(WKNavigationActionPolicyAllow);
    }];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    [self handlePanGesture:recognizer view:self.muteBtn];
}

- (void)handleEndPanGesture:(UIPanGestureRecognizer *)recognizer
{
    [self handlePanGesture:recognizer view:self.endButton];
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)recognizer view:(UIView *)view
{
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    //    CGFloat btnW = 100;
    CGFloat btnW = view.width;
    CGFloat btnH = view.height;
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
        {
            
            CGPoint translation = [recognizer translationInView:self.muteBtn];
            if (recognizer.view.center.x + translation.x >= Screen_Width - btnW/2.0) {
                recognizer.view.center = CGPointMake(Screen_Width - btnW/2.0, recognizer.view.center.y + translation.y);
            }else if(recognizer.view.center.x + translation.x < btnW/2.0){
                recognizer.view.center = CGPointMake(btnW/2.0, recognizer.view.center.y + translation.y);
            }else{
                recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
            }
            
            if (recognizer.view.center.y + translation.y >= Screen_Height - btnH/2.0) {
                recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, Screen_Height - btnH/2.0);
            }else if(recognizer.view.center.y + translation.y < btnW/2.0){
                recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, btnH/2.0);
            }else{
                recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint translation = [recognizer translationInView:self.muteBtn];
            if (recognizer.view.center.x + translation.x >= Screen_Width - btnW/2) {
                recognizer.view.center = CGPointMake(Screen_Width - btnW/2, recognizer.view.center.y + translation.y);
            }else if(recognizer.view.center.x + translation.x < btnW/2){
                recognizer.view.center = CGPointMake(btnW/2, recognizer.view.center.y + translation.y);
            }else{
                recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
            }
            
            if (recognizer.view.center.y + translation.y >= Screen_Height - btnH/2) {
                recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, Screen_Height - btnH/2);
            }else if(recognizer.view.center.y + translation.y < btnH/2){
                recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, btnH/2);
            }else{
                recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
            }
        }
            break;
            
        default:
            break;
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:view];
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
