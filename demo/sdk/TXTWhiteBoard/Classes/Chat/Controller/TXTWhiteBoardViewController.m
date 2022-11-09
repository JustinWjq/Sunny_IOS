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

@interface TXTWhiteBoardViewController () <TEduBoardDelegate>
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
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.whiteBoardView];
    [self.whiteBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];;
    
    
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
            [[JMToast sharedToast] showDialogWithMsg:@"他人正在操作"];
        }
        NSLog(@"shareStatus == %@",[response description]);
    } failure:^(NSError *error, id response) {
        [[JMToast sharedToast] showDialogWithMsg:@"网络连接错误"];
    }];
    
    UIButton *back = [UIButton buttonWithTitle:@"back" titleColor:[UIColor colorWithHexString:@"000000"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(backClick)];
    [self.view addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(50);
    }];
    
}

/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.allowRotation = YES;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
       
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
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, id response) {
        [[JMToast sharedToast] showDialogWithMsg:@"网络连接错误"];
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
}

#pragma mark - 🔄overwrite

#pragma mark - 🚪public

#pragma mark - 🍐delegate

#pragma mark - ☎️notification

#pragma mark - 🎬event response

#pragma mark - ☸getter and setter
- (TXTWhiteBoardView *)whiteBoardView {
    if (!_whiteBoardView) {
        TXTWhiteBoardView *whiteBoardView = [[TXTWhiteBoardView alloc] init];
        self.whiteBoardView = whiteBoardView;
    }
    return _whiteBoardView;
}

@end
