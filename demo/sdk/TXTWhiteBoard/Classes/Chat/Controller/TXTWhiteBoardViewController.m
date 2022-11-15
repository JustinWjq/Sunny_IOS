//
//  TXTWhiteBoardViewController.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/8.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTWhiteBoardViewController.h"
#import "TXTWhiteBoardView.h"
#import "TICManager.h"
#import "TXTToast.h"
#import "TXTNavigationController.h"

@interface TXTWhiteBoardViewController () <TEduBoardDelegate, TXTWhiteBoardViewDelegate>
/** whiteBoardView */
@property (nonatomic, strong) TXTWhiteBoardView *whiteBoardView;
@end

@implementation TXTWhiteBoardViewController

#pragma mark - ♻️life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self qs_initData];
    [self qs_initSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - 🔒private

- (void)qs_initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)qs_initSubViews {
    TXTNavigationController *navigationController = (TXTNavigationController *)self.navigationController;
    navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskAll;
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.whiteBoardView];
    [self.whiteBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.isShowWhiteBoard) {
        [self showWhiteBoard];
    } else {
        [self getWhiteBoard];
    }
}

/// getWhiteBoard
- (void)getWhiteBoard {
    NSString *serviceId = TXUserDefaultsGetObjectforKey(ServiceId);
    NSDictionary *bodyDict = @{@"serviceId":serviceId,@"shareStatus":@(YES),@"userId":[TICConfig shareInstance].userId};
    NSLog(@"shareStatusoooo == %@",[bodyDict description]);
    [[AFNHTTPSessionManager shareInstance] requestURL:ServiceRoom_ShareStatus RequestWay:@"POST" Header:nil Body:bodyDict params:nil isFormData:NO success:^(NSError *error, id response) {
        NSLog(@"仅共享白板 = %@",[response description]);
        NSString *errCode = [response valueForKey:@"errCode"];
        if ([errCode intValue] == 0) {
            //发送消息
            NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":@"shareWhiteboard",@"shareUserId":[TICConfig shareInstance].userId};
            NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
            [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
                [self showWhiteBoard];
            }];
        } else {
//            [[JMToast sharedToast] showDialogWithMsg:@"他人正在操作"];
            [TXTToast toastWithTitle:@"他人正在操作" type:TXTToastTypeWarn];
        }
        NSLog(@"shareStatus == %@",[response description]);
    } failure:^(NSError *error, id response) {
//        [[JMToast sharedToast] showDialogWithMsg:@"网络连接错误"];
        [TXTToast toastWithTitle:@"网络连接错误" type:TXTToastTypeWarn];
    }];
}


/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    app.allowRotation = YES;
    if (![UIWindow isLandscape]) {
       
    } else {
        
    }
}


/// backClick
- (void)backClick {
    [[[TICManager sharedInstance] getBoardController] removeDelegate:self];
    //发送消息
    NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":@"endWhiteboard",@"shareUserId":[TICConfig shareInstance].userId};
    NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
    [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
        [[[TICManager sharedInstance] getBoardController] reset];
    }];
    
    NSString *serviceId = TXUserDefaultsGetObjectforKey(ServiceId);
    NSDictionary *bodyDict = @{@"serviceId":serviceId,@"shareStatus":@(NO),@"userId":[TICConfig shareInstance].userId};
    NSLog(@"shareStatusoooo == %@",[bodyDict description]);
    [[AFNHTTPSessionManager shareInstance] requestURL:ServiceRoom_ShareStatus RequestWay:@"POST" Header:nil Body:bodyDict params:nil isFormData:NO success:^(NSError *error, id response) {
        NSLog(@"shareStatus == %@",[response description]);
//        [self.navigationController popViewControllerAnimated:YES];
        if (self.closeBlock) {
            self.closeBlock();
        }
    } failure:^(NSError *error, id response) {
//        [JMToast showDialogWithMsg:@"网络连接错误"];
        [TXTToast toastWithTitle:@"网络连接错误" type:TXTToastTypeWarn];
    }];
}

/// showWhiteBoard
- (void)showWhiteBoard {
//    NSString *str = @"1:1";
//    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
//
//        [[[TICManager sharedInstance] getBoardController] setBoardRatio:str];
//    } else {
//        [[[TICManager sharedInstance] getBoardController] setBoardRatio:str];
//    }
    //白板视图
    QSLog(@"getWhiteBoard=== %@", [TEduBoardController getVersion]);
    [[[TICManager sharedInstance] getBoardController] addDelegate:self];
    UIView *boardView = [[[TICManager sharedInstance] getBoardController] getBoardRenderView];
    [self.whiteBoardView insertSubview:boardView atIndex:0];
    [boardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.whiteBoardView);
    }];
    
//    [[[TICManager sharedInstance] getBoardController] addH5File:@"https://slupweb.sinosig.com/H5/qnbProjectV3/index.html#/rayVisitFile"];
//https://upload-images.jianshu.io/upload_images/3096441-6c7b84a6c44c4ba2.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200
//    - (NSString *)addH5File:(NSString *)url
//    [TEduBoardResourceController loadCustomResource:@"https://res.qcloudtiw.com/demo/tiw-vod.mp4" resouceType:TEDU_BOARD_PRELOAD_RESOURCE_TYPE_MEDIA expireTime:259200 callback:^(NSString * _Nonnull url, NSInteger progress, NSError * _Nonnull error) {
//        NSLog(@"%@:  下载进度：%ld, err: %@......", url, (long)progress, error);
//    }];
//测试：https://precisemkttest.sinosig.com/resourceNginx/H5Project/qnbProjectV3/index.html#/rayVisitFile
//生产：https://slupweb.sinosig.com/H5/qnbProjectV3/index.html#/rayVisitFile
}

#pragma mark - 🔄overwrite

#pragma mark - 🚪public

#pragma mark - 🍐delegate
- (void)whiteBoardViewDidClickEndBtn:(UIButton *)endBtn {
    [self backClick];
}
#pragma mark - ☎️notification

#pragma mark - 🎬event response
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - ☸getter and setter
- (TXTWhiteBoardView *)whiteBoardView {
    if (!_whiteBoardView) {
        TXTWhiteBoardView *whiteBoardView = [[TXTWhiteBoardView alloc] init];
        whiteBoardView.delegate = self;
        self.whiteBoardView = whiteBoardView;
    }
    return _whiteBoardView;
}

@end
