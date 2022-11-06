//
//  TXTMemberInfoView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/6.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTMemberInfoView.h"
#import "QSCover.h"

static NSInteger const kBtnTag = 10000;

@interface TXTMemberInfoView ()

/** model */
@property (nonatomic, strong) TXTUserModel *model;

@end

@implementation TXTMemberInfoView

static TXTMemberInfoView *_alertView = nil; //第一步：静态实例，并初始化。

+ (instancetype)alertView {
    // 创建活动菜单
    if (!_alertView) {
        _alertView = [[TXTMemberInfoView alloc] init];
    }
    return _alertView;
}

+ (instancetype)getAlertView {
    return _alertView;
}

+ (instancetype)alertWithUserModel:(TXTUserModel *)model {
    QSCover *cover = [QSCover show];
    cover.alpha = 0.3;
    cover.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [TXTMemberInfoView alertView];
    _alertView.frame = cover.frame;
    _alertView.model = model;
    
    [[NSNotificationCenter defaultCenter] addObserver:_alertView selector:@selector(handleScreenOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leave:) name:@"ManageMembersViewControllerLeave" object:nil];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
    [_alertView addSubview:bgView];
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(270);
            make.centerX.equalTo(_alertView);
            make.centerY.equalTo(_alertView);
        }];
    } else {
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(270);
            make.right.equalTo(_alertView.mas_right).offset(-28);
            make.centerY.equalTo(_alertView);
        }];
    }
    bgView.cornerRadius = 15;
    
    UIView *topBgView = [[UIView alloc] init];
    topBgView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    [bgView addSubview:topBgView];
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgView);
        make.height.mas_equalTo(53);
    }];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [icon sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:[UIImage imageNamed:@"HeadPortrait_s" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] completed:nil];
    [topBgView addSubview:icon];
    icon.layer.cornerRadius = 30 / 2;
    icon.clipsToBounds = YES;
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(topBgView.mas_centerY);
    }];
    /** label */
    UILabel *nameLabel = [UILabel labelWithTitle:model.userName color:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_mediumFontWithSize:15]];
    [topBgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55);
        make.centerY.equalTo(icon.mas_centerY);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:_alertView action:@selector(cancelButtonClick)];
    [closeBtn setImage:[UIImage imageNamed:@"member_icon_close" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [topBgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(56);
        make.centerY.equalTo(icon);
        make.right.equalTo(topBgView);
        make.height.mas_equalTo(40);
    }];
    
    UIView *centerBgView = [[UIView alloc] init];
    centerBgView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    [bgView addSubview:centerBgView];
    [centerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(topBgView.mas_bottom).offset(15);
        make.right.mas_equalTo(-15);
    }];
    centerBgView.cornerRadius = 10;
    
    UIView *lastView = nil;
    NSString *voiceStr = model.showAudio ? @"静音" : @"解除静音";
    NSString *videoStr = model.showVideo ? @"关闭摄像头" : @"打开摄像头";
    NSArray *btnsTitleArray = @[voiceStr, videoStr, @"移交主持人", @"移除会议室"];
    for (int i=0; i<btnsTitleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithTitle:btnsTitleArray[i] titleColor:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_regularFontWithSize:15] target:_alertView action:@selector(btnClick:)];
        btn.tag = i + kBtnTag;
        [centerBgView addSubview:btn];
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.right.equalTo(centerBgView);
                make.height.mas_equalTo(50);
            }];
        } else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom);
                make.left.right.equalTo(centerBgView);
                make.height.mas_equalTo(50);
            }];
        }
        lastView = btn;
        
        if (i < btnsTitleArray.count - 1) {
            UIView *divider = [[UIView alloc] init];
            divider.backgroundColor = [[UIColor colorWithHexString:@"F1F1F1"] colorWithAlphaComponent:0.8];
            [centerBgView addSubview:divider];
            [divider mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.right.mas_equalTo(-10);
                make.height.mas_equalTo(1);
                make.bottom.equalTo(lastView.mas_bottom);
            }];
        }
    }
    [centerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom);
        make.bottom.equalTo(bgView.mas_bottom).offset(-75);
    }];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(centerBgView.mas_bottom).offset(75);
//    }];
    
    UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_regularFontWithSize:15] target:_alertView action:@selector(cancelButtonClick)];
    cancelBtn.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    cancelBtn.cornerRadius = 10;
    [bgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(centerBgView);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(bgView).offset(-15);
    }];

    [_alertView animationWithView:bgView duration:0.5];

    [[UIWindow getKeyWindow] addSubview:_alertView];
    return _alertView;
}

/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
    [TXTMemberInfoView hide];
}

- (void)leave:(NSNotification *)noti {
    NSString *info = [noti object];
    if ([info isEqualToString:self.model.render.userId]) {
        [TXTMemberInfoView hide];
    }
}


/// btnClick
- (void)btnClick:(UIButton *)btn {
    [TXTMemberInfoView hide];
    NSInteger tag = btn.tag - kBtnTag;
    if (tag == 0) {
        NSDictionary *dict = @{@"userId":self.model.render.userId,@"muteAudio":@(!self.model.showAudio)};
        NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":@"muteAudio",@"agentId":TXUserDefaultsGetObjectforKey(AgentId),@"users":@[dict]};
        NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
        [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
            if(code == 0){
                [[JMToast sharedToast] showDialogWithMsg:@"操作成功"];
            }
        }];
    } else if (tag == 1) {
        NSDictionary *dict = @{@"userId":self.model.render.userId,@"muteVideo":@(!self.model.showVideo)};
        NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":@"muteVideo",@"agentId":TXUserDefaultsGetObjectforKey(AgentId),@"users":@[dict]};
        NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
        [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
            if(code == 0){
                [[JMToast sharedToast] showDialogWithMsg:@"操作成功"];
            }
        }];
    }
}


- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [view.layer addAnimation:animation forKey:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    return self;
}

#pragma mark - Method


#pragma mark - TYCyclePagerViewDataSource

/**
 *  sureBtnClick
 */
- (void)sureBtnClick {
    if (self.sureBlock) {
        self.sureBlock();
    }
}

/**
 * 删除view
 */
- (void)hideAlertView {
    [_alertView removeFromSuperview];
    _alertView = nil;
}

+ (void)hide {
    [QSCover hide];
    [_alertView hideAlertView];
}

/**
 *  cancelButtonClick
 */
- (void)cancelButtonClick {
    if (self.cancleBlock) {
        self.cancleBlock();
    }
    [TXTMemberInfoView hide];
}

- (void)dealloc {
    QSLog(@"%@ --- dealloc", self);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ManageMembersViewControllerLeave" object:nil];
}

#pragma mark - Config UI


#pragma mark - LazyLoad

@end

