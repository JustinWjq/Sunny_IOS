//
//  TXTAlertShareView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/7.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTAlertShareView.h"
#import "QSCover.h"

@interface TXTAlertShareView ()

@end

@implementation TXTAlertShareView

static TXTAlertShareView *_alertView = nil; //第一步：静态实例，并初始化。

+ (instancetype)alertView {
    // 创建活动菜单
    if (!_alertView) {
        _alertView = [[TXTAlertShareView alloc] init];
    }
    return _alertView;
}

+ (instancetype)getAlertView {
    return _alertView;
}

+ (instancetype)alert {
    QSCover *cover = [QSCover show];
    cover.alpha = 0.3;
    cover.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if ([UIWindow isLandscape]) {
        if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) {
            cover.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        }
    }
    
    [TXTAlertShareView alertView];
    _alertView.frame = cover.frame;
        
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    [_alertView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(185);
        make.centerX.equalTo(_alertView);
        make.centerY.equalTo(_alertView);
    }];
    bgView.cornerRadius = 15;
    
    /** label */
    UILabel *nameLabel = [UILabel labelWithTitle:@"选择邀请方式" color:[UIColor colorWithHexString:@"999999"] font:[UIFont qs_mediumFontWithSize:15]];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.equalTo(bgView.mas_centerX);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:_alertView action:@selector(cancelButtonClick)];
    [closeBtn setImage:[UIImage imageNamed:@"member_icon_shareClose" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(46);
        make.top.mas_equalTo(0);
        make.right.equalTo(bgView);
    }];
    
    UIImageView *weChatIcon = [[UIImageView alloc] init];
    weChatIcon.image = [UIImage imageNamed:@"member_icon_shareWeChat" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil];
    [bgView addSubview:weChatIcon];
    [weChatIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(36);
        make.centerX.equalTo(bgView);
        make.top.mas_equalTo(80);
    }];
    UILabel *weChatLabel = [UILabel labelWithTitle:@"微信" color:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_regularFontWithSize:14]];
    [bgView addSubview:weChatLabel];
    [weChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weChatIcon);
        make.top.equalTo(weChatIcon.mas_bottom).offset(4);
        make.height.mas_equalTo(20);
    }];
    UIButton *weChatBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:_alertView action:@selector(sureBtnClick)];
    [bgView addSubview:weChatBtn];
    [weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weChatIcon);
        make.bottom.equalTo(weChatLabel.mas_bottom);
    }];
    
    [_alertView animationWithView:bgView duration:0.5];

    [[UIWindow getKeyWindow] addSubview:_alertView];
    return _alertView;
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
    [TXTAlertShareView hide];
}

- (void)dealloc {
    QSLog(@"%@ --- dealloc", self);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ManageMembersViewControllerLeave" object:nil];
}

#pragma mark - Config UI


#pragma mark - LazyLoad

@end
