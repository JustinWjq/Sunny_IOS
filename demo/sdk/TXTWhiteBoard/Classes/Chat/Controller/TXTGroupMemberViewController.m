//
//  TXTGroupMemberViewController.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/5.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTGroupMemberViewController.h"
#import "TXTMemberView.h"

@interface TXTGroupMemberViewController () <TXTMemberViewDelegate>
/** memberView */
@property (nonatomic, strong) TXTMemberView *memberView;

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
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

#pragma mark - 🔒private

- (void)qs_initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)qs_initSubViews {
    self.view.backgroundColor = [UIColor colorWithHexString:@"000000"];
    [self.view addSubview:self.memberView];
    [self.memberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset([UIApplication sharedApplication].statusBarFrame.size.height);
        make.left.right.bottom.equalTo(self.view);
    }];
}

/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.allowRotation = YES;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
        [self.memberView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset([UIApplication sharedApplication].statusBarFrame.size.height);
            make.left.right.bottom.equalTo(self.view);
        }];
        [self.memberView updateUI:YES];
    } else {
        [self.memberView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.right.bottom.equalTo(self.view);
            make.width.mas_equalTo(330);
        }];
        [self.memberView updateUI:NO];
    }
    [self.view layoutIfNeeded];
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
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ☎️notification

#pragma mark - 🎬event response

#pragma mark - ☸getter and setter
- (TXTMemberView *)memberView {
    if (!_memberView) {
        TXTMemberView *memberView = [[TXTMemberView alloc] init];
        memberView.delegate = self;
        self.memberView = memberView;
    }
    return _memberView;
}

@end
