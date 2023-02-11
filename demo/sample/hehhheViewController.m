//
//  hehhheViewController.m
//  txWhiteBoardSample
//
//  Created by 洪青文 on 2020/9/3.
//  Copyright © 2020 洪青文. All rights reserved.
//

#import "hehhheViewController.h"

#import "Masonry.h"
#import <WebKit/WebKit.h>
#import <TXTWhiteBoard/TXTManage.h>
#import <TXTWhiteBoard/TXTCustomConfig.h>
#import "NSString+TXTAES.h"
#import "BRPickerView.h"
#import "settingViewController.h"
#import <TXTWhiteBoard/TXTFileModel.h>
//#import "QFHttpTool.h"
#import "AFNetworking.h"

@interface hehhheViewController ()<TXTManageDelegate,WKUIDelegate,WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *agentName;
@property (weak, nonatomic) IBOutlet UITextField *orgName;
@property (weak, nonatomic) IBOutlet UILabel *smalllab;
@property (weak, nonatomic) IBOutlet UILabel *phonelab;
@property (weak, nonatomic) IBOutlet UIButton *smallbtn;
@property (weak, nonatomic) IBOutlet UIButton *appbtn;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@property (strong, nonatomic) TXTCustomConfig *config;

@property (weak, nonatomic) NSMutableString *cookieStr;

@property (assign, nonatomic) UIEdgeInsets safe;
@end

@implementation hehhheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号登录";
    
    [self initSDK];
    
    [self setUI];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-200);
    }];
    
    [self.smallbtn setTitle:@" 生产环境" forState:UIControlStateNormal];
    [self.appbtn setTitle:@" 测试环境" forState:UIControlStateNormal];
    //    self.phonelab.text = @"app是生产环境";
    self.smallbtn.layer.borderWidth = 0.5;
    self.smallbtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.smallbtn.layer.cornerRadius = 3;
    self.smallbtn.layer.masksToBounds = YES;
    self.appbtn.layer.borderWidth = 0.5;
    self.appbtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.appbtn.layer.cornerRadius = 3;
    self.appbtn.layer.masksToBounds = YES;
    
    //    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    //    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

-(void)initSDK {
    self.config = [TXTCustomConfig sharedInstance];
    self.config.appid = @"wx8e6096173bff1149";//wx8ac1db9b5f5e385e  wx8e6096173bff1149
    self.config.universalLink = @"https://video-sells-test.ikandy.cn/txWhiteBoard/";
    self.config.userName = @"gh_c7b7987a7660";//gh_534ca5cd3ab2
    self.config.miniprogramTitle = @"诚邀您参与贵宾专属会议";
    self.config.miniprogramCard = @"诚邀您参与贵宾专属会议";
    self.config.miniprogramCardURL = @"https://l106.oss-cn-szfinance.aliyuncs.com/0activityV3/shareExprien/newMiniShare.png";
    self.config.isShowInviteButton = YES;
    self.config.isShowTemporaryButton = YES;
    self.config.miniProgramPath = @"/pages/index/index";
    self.config.enableVideo = YES;
    self.config.isChat = NO;
    self.config.isDebug = YES;
    self.config.debugCookieDict = @{
        @"webViewFlag":@"WKWeb",
        @"agentLevel":@"5",
        @"statusBarHeigh":@"0.0",
        @"userType_s":@"S",
        
        @"agentCodeQNB":@"1090000001",
        @"bundleId":@"com.sinosig.jzyx",
        @"BusSrePcMac":@"",
        @"BusSrePcIp":@"172.20.10.8",
        
        @"agentCodeoc":@"ZUZkbE5VVlhRMUZyT1ZaVU5WVmtNelF6YURaTlVuUXhTRWRIUkdoVmQzaFlZbUZLYVU1Sk9VVlFaRTh5YmtsalNuSXlNREJSTjBWRFl6QjJNR0V3SzBsbWNWWnFZbTVuUmpOdGJsWnZSV2RLYUZwMFEwRTlQUT09",
        @"managecomName":@"%E9%98%B3%E5%85%89%E4%BA%BA%E5%AF%BF%E4%BF%9D%E9%99%A9%E8%82%A1%E4%BB%BD%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8%E5%8C%97%E4%BA%AC%E5%88%86%E5%85%AC%E5%8F%B8",
        @"managecom":@"8601",
        @"agentkind":@"NA",
        
        @"userType":@"4",
        @"version":@"4.9.2",
        @"fgsName":@"",
        @"platform":@"slup",
        
        @"deviceString":@"iPhone 6s Plus",
        @"token":@"WlRCalkxcEdZelpIV0doMlprTm5NazFNYzAxNVNYVlFjelpDUjJjNFFVRm5kalZMWVdwbEsySlZWV2d6U1ZKT04zVkJVRXhzUVdWVlZYQnhha2hxWjNCR2JuUkJiVTk0TkM5WlNFRjZOekpJWWtoUE1HYzlQUT09",
        @"phoneId":@"@00000000-0000-0000-0000-000000000000",
        @"mobile":@"18618128372",
        
        @"userCode":@"1090000001",
        @"licencenum":@"",
        @"gradeName":@"SBM",
        @"QingniuSDKVersion":@"1.3.0.84",
        
        @"branchtype":@"1",
        @"userName":@"%E6%9D%8E%E6%9C%9D%E5%85%89",
        @"picStr":@"https://precisemkttest.sinosig.com/resourceNginx/headPic/10900000011671606414117.jpg",
        @"systemVersion":@"15.7.3",
    };
    
    [TXTManage sharedInstance].manageDelegate = self;
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
    
    if (@available(iOS 13.0, *)) {
        configuration.preferences.fraudulentWebsiteWarningEnabled = NO;
    } else {
        // Fallback on earlier versions
    }
    //初始化
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    //1.网络
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    
//    CGFloat statusBarHeight;
//    if (@available(iOS 13.0, *)) {
//          statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
//      } else {
//          statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//      }
//    _webView.scrollView.contentInset = UIEdgeInsetsMake(statusBarHeight, 0, [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom, 0);
    
    
    //    NSString *url = @"https://sync-web-test.cloud-ins.cn/demo/index.html#/";
    //    NSString *url = @"https://www.baidu.com";
    NSString *url = @"https://precisemkttest.sinosig.com/resourceNginx/H5Project/qnbProjectV3/index.html#/rayVisitIndex";
    
    NSDictionary *cookieDict = [TXTCustomConfig sharedInstance].debugCookieDict;
    NSDictionary *dictCookies = nil;
    NSArray *cookieArray = nil;
    if(cookieDict != nil) {
        NSMutableArray *tempArrCookies = [NSMutableArray array];
        //取出字典所有key
        NSArray *keyArray = [cookieDict allKeys];
        for (NSString *key in keyArray) {
            NSDictionary *dictCookie = [NSDictionary dictionaryWithObjectsAndKeys:
                                        key, NSHTTPCookieName,
                                        cookieDict[key], NSHTTPCookieValue,
                                        @"/", NSHTTPCookiePath,
                                        url, NSHTTPCookieDomain, nil];
            
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dictCookie];
            [tempArrCookies addObject:cookie];
        }
        NSArray *arrCookies = [tempArrCookies copy];
        cookieArray = arrCookies;
        dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    }
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    if(dictCookies != nil) {
        [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField: @"Cookie"];
        
        NSMutableString *cookieStr = [NSMutableString stringWithFormat:@""];
        if (cookieArray) {
            for (NSHTTPCookie *cookie in cookieArray) {
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
            for (NSHTTPCookie *cookie in cookieArray) {
                [cookieStore setCookie:cookie completionHandler:^{
                    
                }];
            }
        }
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookieArray
                                                           forURL:[NSURL URLWithString:url]
                                                  mainDocumentURL:nil];
    }
    
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.route isEqualToString:@"creat"]) {
        [self.actionBtn setTitle:@"预约会议" forState:UIControlStateNormal];
    }else{
        [self.actionBtn setTitle:@"开始会议" forState:UIControlStateNormal];
    }
}

-(IBAction)reload:(id)sender {
    NSString *url = @"https://precisemkttest.sinosig.com/resourceNginx/H5Project/qnbProjectV3/index.html#/rayVisitIndex";
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.webView loadRequest:request];
}

-(void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    NSLog(@"URL = %@", URL);
    NSLog(@"scheme = %@", scheme);
    
    [webView evaluateJavaScript:self.cookieStr completionHandler:^(id result, NSError *error) {
        NSLog(@"evaluateJavaScript ------- %@ ", result);
        decisionHandler(WKNavigationActionPolicyAllow);
    }];
}

static AFHTTPSessionManager *instance;
- (IBAction)start:(id)sender {
    
    self.safe = self.webView.scrollView.contentInset;
    
    [self.view endEditing:YES];
    NSString *agentName = self.agentName.text;
    NSString *orgName = self.orgName.text;
    if ([agentName isEqualToString:@""] || agentName == nil) {
        
        return;
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%@%.0f",orgName,time];
    //    NSString *sign = [timeString aci_encryptWithAES];
    
    
    //@"gh_9fd3da8ad9f6"
    NSString *smallstr = self.smallbtn.titleLabel.text;
    NSString *miniprogramType = @"1";
    //    if ([smallstr isEqualToString:@" 生产环境"]) {
    //        miniprogramType = @"2";
    //    }else if ([smallstr isEqualToString:@" 开发环境"]) {
    //        miniprogramType = @"0";
    //    }
    
    NSString *appstr = self.appbtn.titleLabel.text;
    NSString *appType = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:@"net02d2geftdt4tj" forKey:@"PSW_AES_KEY"];
    [[NSUserDefaults standardUserDefaults] setObject:@"4kz8rn8a7yxdy9u8" forKey:@"AES_IV_PARAMETER"];
    //    if ([appstr isEqualToString:@" 生产环境"]) {
    //        appType = @"2";
    //        [[NSUserDefaults standardUserDefaults] setObject:@"nvvmjk1hi8qlvoy4" forKey:@"PSW_AES_KEY"];
    //        [[NSUserDefaults standardUserDefaults] setObject:@"fstvas2suhosmvjl" forKey:@"AES_IV_PARAMETER"];
    //    }else if ([appstr isEqualToString:@" 开发环境"]) {
    //        appType = @"0";
    //    }
    NSString *sign = [timeString aci_encryptWithAES];
    //    NSDictionary *dict = @{@"appid":@"wx8e6096173bff1149",@"universalLink":@"https://video-sells-test.ikandy.cn/txWhiteBoard/",@"userName":@"gh_9fd3da8ad9f6",@"miniprogramType":miniprogramType};
    
    NSDictionary *addressDict = @{@"adr":@"eeeeeee",@"city":@"ddd111111111",@"latitude":@11.22,@"longitude":@123.9,@"province":@"hhhhhhhhhhhhh",@"accuracy":@1};
    
    self.config.miniprogramType = miniprogramType;
    
    
    [[TXTManage sharedInstance] setEnvironment:appType wechat:self.config appGroup:@"com.tx.txWhiteBoard.ReplaykitUpload"];
    
    //创建会话
    instance = [AFHTTPSessionManager manager];
    instance.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    instance.securityPolicy.allowInvalidCertificates = YES;
    [instance.securityPolicy setValidatesDomainName:NO];
    NSString *urlstr = @"";
    if ([appType isEqualToString:@"1"]) {
        urlstr = [NSString stringWithFormat:@"%@%@",@"https://video-sells-test.ikandy.cn",@"/api/serviceRoom/create"];
    }else if([appType isEqualToString:@"2"]) {
        urlstr = [NSString stringWithFormat:@"%@%@",@"https://video-sells.cloud-ins.cn",@"/api/serviceRoom/create"];
    }else{
        urlstr = [NSString stringWithFormat:@"%@%@",@"https://dev1.ikandy.cn:60312",@"/api/serviceRoom/create"];
    }
    NSLog(@"%@",urlstr);
    urlstr = [urlstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]requestWithMethod:@"POST" URLString:urlstr parameters:nil error:nil];
    request.timeoutInterval = 10;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionary];
    [bodyDic setValue:agentName forKey:@"account"];
    [bodyDic setValue:orgName forKey:@"orgAccount"];
    [bodyDic setValue:sign forKey:@"sign"];
    NSData *data1 = [NSJSONSerialization dataWithJSONObject:bodyDic options:0 error:nil];
    NSString *jsonstr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    [request setHTTPBody:[jsonstr dataUsingEncoding:NSUTF8StringEncoding]];
    [[instance dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSLog(@"%@",[responseDict description]);
            NSString *errCode = [responseObject valueForKey:@"errCode"];
            if ([errCode intValue] == 0) {
                NSDictionary *result = [responseObject valueForKey:@"result"];
                NSString *inviteNumber = [result valueForKey:@"inviteNumber"];
                [[TXTManage sharedInstance] startVideo:inviteNumber andAgent:agentName UserName:@"测试" OrgName:orgName SignOrgName:sign CallBack:^(int code, NSString * _Nonnull desc) {
                    if (code == 0) {
                    }else if(code == 111111111){
                        
                    }else{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:desc preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            //确认处理
                        }];
                        [alert addAction:action2];
                        [self.navigationController presentViewController:alert animated:YES completion:nil];
                    }
                }];
            } else {
                NSString *errInfo = [responseObject valueForKey:@"errInfo"];
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:[NSString stringWithFormat:@"错误码：%@", errCode]
                                            message:errInfo
                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //确认处理
                }];
                [alert addAction:action2];
                [self.navigationController presentViewController:alert animated:YES completion:nil];
            }
            
        }
        else
        {
            
        }
    }] resume];
    
    
}


- (IBAction)chooseSmall:(id)sender {
    /// 1.单列字符串选择器（传字符串数组）
    [self.view endEditing:YES];
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.title = @"选择环境";
    stringPickerView.dataSourceArr = @[@" 测试环境", @" 生产环境",@" 开发环境"];
    stringPickerView.selectIndex = 0;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        NSLog(@"选择的值：%@", resultModel.value);
        [self.smallbtn setTitle:resultModel.value forState:UIControlStateNormal];
        if ([resultModel.value isEqualToString:@" 生产环境"]) {
            self.smalllab.text = @"小程序是生产环境";
        }else if ([resultModel.value isEqualToString:@" 测试环境"]){
            self.smalllab.text = @"小程序是测试环境";
        }else{
            self.smalllab.text = @"小程序是开发环境";
        }
    };
    
    [stringPickerView show];
    
}
- (IBAction)chooseApp:(id)sender {
    [self.view endEditing:YES];
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.title = @"选择环境";
    stringPickerView.dataSourceArr = @[@" 测试环境", @" 生产环境",@" 开发环境"];
    stringPickerView.selectIndex = 0;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        NSLog(@"选择的值：%@", resultModel.value);
        [self.appbtn setTitle:resultModel.value forState:UIControlStateNormal];
        if ([resultModel.value isEqualToString:@" 生产环境"]) {
            self.phonelab.text = @"app是生产环境";
            self.orgName.text = @"gsc_test";
        }else if ([resultModel.value isEqualToString:@" 测试环境"]){
            self.phonelab.text = @"app是测试环境";
            self.orgName.text = @"test_org2";
        }else{
            self.phonelab.text = @"app是开发环境";
        }
    };
    
    [stringPickerView show];
}

- (void)addOnFileClickListenerRoomId:(NSInteger)roomId {
    NSLog(@"addOnFileClickListenerRoomId ++ %ld", roomId);
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.agentName resignFirstResponder];
    [self.orgName resignFirstResponder];
}

- (void)setting{
    settingViewController *vc = [[settingViewController alloc] initWithNibName:@"settingViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

-(BOOL)shouldAutorotate {
    return YES;
}

- (void)onEndRoom{
    NSLog(@"结束了");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setNeedsStatusBarAppearanceUpdate];
    });
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //        [self.webView removeFromSuperview];
    //
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [self.view addSubview:self.webView];
    //            [self.view sendSubviewToBack:self.webView];
    //
    //            [self.webView reload];
    //            [self.webView layoutSubviews];
    //
    //            [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //                make.edges.equalTo(self.view);
    //            }];
    //        });
    //        self.navigationController.navigationBar.frame = CGRectMake(0, statusBarHeight, windowFrame.size.width, self.navigationController.navigationBar.bounds.size.height);
    //    });
    
}

@end

