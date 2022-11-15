//
//  TXTGroupMemberViewController.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/5.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTGroupMemberViewController.h"
#import "TXTMemberView.h"
#import "TXTTeleprompView.h"
#import "TXTNavigationController.h"
#import "QSTapGestureRecognizer.h"

@interface TXTGroupMemberViewController () <TXTMemberViewDelegate, TXTTeleprompViewDelegate>
/** bgView */
@property (nonatomic, strong) UIView *bgView;
/** memberView */
@property (nonatomic, strong) TXTMemberView *memberView;

/** teleprompView */
@property (nonatomic, strong) TXTTeleprompView *teleprompView;

@end

@implementation TXTGroupMemberViewController

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (![UIWindow isLandscape]) {
        [self updateUI:YES];
        [self.memberView updateUI:YES];
        [self.teleprompView updateUI:YES];
    } else {
        [self updateUI:NO];
        [self.memberView updateUI:NO];
        [self.teleprompView updateUI:NO];
    }
}

#pragma mark - 🔒private

- (void)qs_initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)qs_initSubViews {
    TXTNavigationController *navigationController = (TXTNavigationController *)self.navigationController;
    navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskAll;
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.memberView];
    [self.memberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset([UIApplication sharedApplication].statusBarFrame.size.height);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.teleprompView];
    [self.teleprompView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(200);
//        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(122);
    }];
//    [self.view layoutIfNeeded];
    
//    if (![UIWindow isLandscape]) {
//        [self updateUI:YES];
//        [self.memberView updateUI:YES];
//    } else {
//        [self updateUI:NO];
//        [self.memberView updateUI:NO];
//    }
    QSTapGestureRecognizer *gesture = [[QSTapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.bgView addGestureRecognizer:gesture];
}

/// hide
- (void)hide {
    if (self.closeBlock) {
        self.closeBlock();
    }
}
/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    app.allowRotation = YES;
//    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
    if (![UIWindow isLandscape]) {
//        [self.memberView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_top).offset([UIApplication sharedApplication].statusBarFrame.size.height);
//            make.left.right.bottom.equalTo(self.view);
//        }];
        [self updateUI:YES];
        [self.memberView updateUI:YES];
    } else {
//        [self.memberView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_top);
//            make.right.bottom.equalTo(self.view);
//            make.width.mas_equalTo(330);
//        }];
        [self updateUI:NO];
        [self.memberView updateUI:NO];
    }
    [self teleprompViewDidClickSwitchView:self.teleprompView.switchView];
    [self.view layoutIfNeeded];
}

- (void)updateUI:(BOOL)isPortrait {
    if (isPortrait) {
        [self.memberView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset([UIApplication sharedApplication].statusBarFrame.size.height);
            make.left.right.bottom.equalTo(self.view);
        }];
    } else {
        [self.memberView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.right.bottom.equalTo(self.view);
            make.width.mas_equalTo(330 + [UIApplication sharedApplication].keyWindow.safeAreaInsets.right);
        }];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation {
    return NO;
}
    
- (void)setManageMembersArr:(NSMutableArray *)manageMembersArr {
    _manageMembersArr = [manageMembersArr copy];
    self.memberView.manageMembersArr = manageMembersArr;
}
#pragma mark - 🔄overwrite

#pragma mark - 🚪public

#pragma mark - 🍐delegate
- (void)memberViewDidClickCloseBtn:(UIButton *)closeBtn {
//    [self.memberView removeFromSuperview];
//    [self.navigationController popViewControllerAnimated:YES];
//    if (self.closeBlock) {
//        self.closeBlock();
//    }
    [self hide];
}

/// 点击了switch
- (void)teleprompViewDidClickSwitchView:(UISwitch *)switchView {
    if (switchView.isOn) {
        if (![UIWindow isLandscape]) {
            [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.top.mas_equalTo(200);
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
                make.height.mas_equalTo(150).priorityHigh();
            }];
        } else {
            [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
                make.height.mas_equalTo(225).priorityHigh();
                make.width.mas_equalTo(180);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
            }];
        }
        [self.teleprompView upDateUIWithSwithch:YES];
    } else {
        if (![UIWindow isLandscape]) {
            [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.top.mas_equalTo(200);
        //        make.right.equalTo(self.view.mas_right).offset(-10);
                make.height.mas_equalTo(36);
                make.width.mas_equalTo(122);
            }];
        } else {
            [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
                make.top.mas_equalTo(200);
                make.height.mas_equalTo(36);
                make.width.mas_equalTo(122);
            }];
        }
        [self.teleprompView upDateUIWithSwithch:NO];
    }
    [self.view layoutIfNeeded];
}
#pragma mark - ☎️notification

#pragma mark - 🎬event response
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - ☸getter and setter
- (TXTMemberView *)memberView {
    if (!_memberView) {
        TXTMemberView *memberView = [[TXTMemberView alloc] init];
        memberView.delegate = self;
        self.memberView = memberView;
    }
    return _memberView;
}

- (TXTTeleprompView *)teleprompView {
    if (!_teleprompView) {
        TXTTeleprompView *teleprompView = [[TXTTeleprompView alloc] init];
        teleprompView.delegate = self;
        self.teleprompView = teleprompView;
    }
    return _teleprompView;
}
- (UIView *)bgView {
    if (!_bgView) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
        self.bgView = bgView;
    }
    return _bgView;
}
@end
