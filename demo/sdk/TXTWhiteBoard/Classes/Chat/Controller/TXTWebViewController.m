//
//  TXTWebViewController.m
//  62580
//
//  Created by JYJ on 2020/4/15.
//  Copyright © 2020 qscx. All rights reserved.
//

#import "TXTWebViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "WeakScriptMessageDelegate.h"

@interface TXTWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic , strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIButton *closeBtn;

/** cookieStr */
@property (nonatomic, copy) NSMutableString *cookieStr;
/** cookieArray */
@property (nonatomic, strong) NSArray *cookieArray;

/** scriptMessageDelegate */
@property (nonatomic, strong) WeakScriptMessageDelegate *scriptMessageDelegate;
@end

@implementation TXTWebViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(1);
    }];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;


//    UIButton *reloadBtn = [UIButton buttonWithTitle:@"刷新" titleColor:[UIColor colorWithHexString:@"5C667F"] font:[UIFont kd_regularFontWithSize:KDRate(15)] target:self action:@selector(refreshClick)];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:reloadBtn];
//    self.navigationItem.rightBarButtonItem = backItem;
//    UIButton *leftBtn = [UIButton buttonWithTitle:@"退出登录" titleColor:[UIColor colorWithHexString:@"5C667F"] font:[UIFont kd_regularFontWithSize:KDRate(15)] target:self action:@selector(leftBtnClick)];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftItem;
}
/// leftBtnClick
- (void)leftBtnClick {
    [self clearCache];
}


/// clearCache
- (void)clearCache {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}

- (void)leftBtnItemAction {
    if (self.webView.canGoBack==YES) {
        // 返回上级页面
        [self.webView goBack];
    } else {
        //退出控制器
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/// closeAction
- (void)closeAction {
    //退出控制器
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)refreshClick {
    [self.webView reload];
}

- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.preferences.minimumFontSize = 10;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // 默认认为YES
        configuration.preferences.javaScriptEnabled = YES;
        configuration.userContentController = [[WKUserContentController alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        configuration.processPool = [[WKProcessPool alloc]init];

        if (@available(iOS 10.0, *)) {
            if ([configuration respondsToSelector:@selector(mediaTypesRequiringUserActionForPlayback)]) {
                configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
            }
        } else if(@available(iOS 9.0, *)){
            if([configuration respondsToSelector:@selector(setRequiresUserActionForMediaPlayback:)]) {
                configuration.requiresUserActionForMediaPlayback = NO;
            }
        } else if([configuration respondsToSelector:@selector(setMediaPlaybackRequiresUserAction:)]){
            configuration.mediaPlaybackRequiresUserAction = NO;
        }
//        // web内容处理池
//        configuration.processPool = [[WKProcessPool alloc] init];
        
        
        NSMutableArray *tempArrCookies = [NSMutableArray array];
        //取出字典所有key
        NSArray *keyArray = [self.cookieDict allKeys];
        for (NSString *key in keyArray) {
            NSDictionary *dictCookie = [NSDictionary dictionaryWithObjectsAndKeys:key, NSHTTPCookieName,
                                               self.cookieDict[key], NSHTTPCookieValue,
                                            @"/", NSHTTPCookiePath,
                                            self.urlStr, NSHTTPCookieDomain,nil];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dictCookie];
            [tempArrCookies addObject:cookie];
        }
        NSArray *arrCookies = [tempArrCookies copy];
        self.cookieArray = arrCookies;
        NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];//将cookie设置到头中

//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
        [request setValue:[dictCookies objectForKey:@"Cookie"] forHTTPHeaderField: @"Cookie"];

        // 这里注入cookie。所有的cookie拼接成一个字符串。用分号和换行符隔开,如下：
        NSMutableString *cookieStr = [NSMutableString stringWithFormat:@""];
        if (self.cookieArray) {
            for (NSHTTPCookie *cookie in self.cookieArray) {
                [cookieStr appendFormat:@"document.cookie = '%@=%@';\n", cookie.name, cookie.value];
            }
        }
        self.cookieStr = cookieStr.mutableCopy;

        WKUserContentController *userContentController = [WKUserContentController new];
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:self.cookieStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];

        configuration.userContentController = userContentController;

//        //添加函数监听
//        [self onRegisFuns:configuration];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) configuration:configuration];
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        if (@available(iOS 11.0, *)) {
            WKHTTPCookieStore *cookieStore = _webView.configuration.websiteDataStore.httpCookieStore;
            for (NSHTTPCookie *cookie in self.cookieArray) {
                 [cookieStore setCookie:cookie completionHandler:nil];
            }
        }
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:self.cookieArray forURL:[NSURL URLWithString:self.urlStr] mainDocumentURL:nil];
        _webView.allowsBackForwardNavigationGestures = YES;

        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:NULL];

        [_webView loadRequest:request];
    }

    return _webView;
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    QSLog(@"开始加载网页");
    BOOL isPush = NO;
    if ([webView.URL.absoluteString rangeOfString:@"//itunes.apple."].location != NSNotFound) {
        isPush = YES;
    }
    QSLog(@"%@",webView.URL);
    if ([[UIApplication sharedApplication] canOpenURL:webView.URL] && isPush) {
        [[UIApplication sharedApplication] openURL:webView.URL options:@{} completionHandler:nil];
    }
}


// 加载完成  什么意思？
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    NSString *injectionJSString = @"var script = document.createElement('meta');"
                                      "script.name = 'viewport';"
                                      "script.content=\"width=device-width, user-scalable=no\";"
                                      "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
//    [self.webView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败%@",error);
//    [self.webView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [webView evaluateJavaScript:self.cookieStr completionHandler:^(id result, NSError *error) {
        QSLog(@"cookie-------%@",result);
        decisionHandler(WKNavigationActionPolicyAllow);
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

    //允许跳转
    NSString *urlStr = navigationResponse.response.URL.absoluteString;
    if ([urlStr containsString:@".pdf"] || [urlStr containsString:@".PDF"]) {
        NSData *data = [NSData dataWithContentsOfURL:navigationResponse.response.URL];
        NSURL *weburl = [NSURL URLWithString:urlStr];
        [self.webView loadData:data MIMEType:@"application/pdf" characterEncodingName:@"UTF-8" baseURL:weburl];
    }

#pragma mark - App Store监听
    NSURL *url = [NSURL URLWithString:urlStr];
    BOOL isPush = NO;
    if ([urlStr rangeOfString:@"//itunes.apple."].location != NSNotFound) {
        isPush = YES;
    }
    if ([[UIApplication sharedApplication] canOpenURL:url] && isPush) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationResponsePolicyCancel);
        return;
    }
    
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.webView  && [keyPath isEqualToString:@"estimatedProgress"]) {
//        self.progressView.progress = self.webView.estimatedProgress;
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (self.progressView.hidden) self.progressView.hidden = NO;
        [self.progressView setProgress:newprogress animated:YES];
        if (newprogress == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
            });
        }
    } else if (object == self.webView && [keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = self.webView.title;
    } else if (object == self.webView && [keyPath isEqualToString:@"canGoBack"]) {
//        if (self.navigationController.childViewControllers.count > 1) {
//            if (self.webView.canGoBack) {
//                UIImage *closeImage = [[UIImage imageNamed:@"webview_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
//                closeButton.frame = CGRectMake(0, 0, 40, 36);
//            //    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
//                [closeButton setImage:closeImage forState:UIControlStateNormal];
//                closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//                [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
//                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
//            } else {
//                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
//            }
//        } else {
//            if (self.webView.canGoBack) {
//                [self kd_setLeftBarButtonItemWithImageName:@"nav_back_blackIcon"];
//            } else {
//                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
//            }
//        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - JS与原生交互
///注册JS监听
- (void)onRegisFuns:(WKWebViewConfiguration *)config {
//    self.scriptMessageDelegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
//    [config.userContentController addScriptMessageHandler:self.scriptMessageDelegate name:@"getMessage"];
//    [config.userContentController addScriptMessageHandler:self.scriptMessageDelegate name:@"nativeMethod"];
    
}

- (void)removeRegisFuns {
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"getMessage"];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"nativeCustomMethod"];
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"nativeMethod"];
}

// 监听js调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    QSLog(@"11111");
    QSLog(@"name = %@, body = %@", message.name, message.body);
//    NSDictionary *dict = message.body;
//    if ([message.name isEqualToString:@"nativeMethod"]) {
//        [self runJsFun_nativeMethod:message.body];
//    }
}

#pragma mark - 执行js调用

/// runJsFun_nativeCustomMethod
- (void)runJsFun_nativeCustomMethod:(id)body {
   
}


#pragma mark 执行js回调
- (void)callbackJsFuns:(NSString *)callbackInfo {
    [self.webView evaluateJavaScript:callbackInfo completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"执行JS的回调error:%@",error);
    }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
//
//    [self removeRegisFuns];
}

- (UIProgressView *)progressView {
    if(!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
        _progressView.tintColor = [UIColor colorWithHexString:@"F67E32"];
        _progressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:_progressView];
        [self.view insertSubview:_progressView belowSubview:self.webView];
    }
    return _progressView;
}

@end
