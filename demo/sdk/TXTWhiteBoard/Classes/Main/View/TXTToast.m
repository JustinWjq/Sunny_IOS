//
//  TXTToast.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/10.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTToast.h"
#import "QSCover.h"

@interface TXTToast ()
/** count */
@property (nonatomic, assign) NSInteger count;

@end

@implementation TXTToast

static TXTToast *_alertView = nil; //第一步：静态实例，并初始化。

+ (instancetype)alertView {
    // 创建活动菜单
    if (!_alertView) {
        _alertView = [[TXTToast alloc] init];
    }
    return _alertView;
}

+ (instancetype)getAlertView {
    return _alertView;
}

/// 普通toast
+ (instancetype)toastWithTitle:(NSString *)title {
    return [TXTToast toastWithTitle:title type:TXTToastTypeCheck];
}

/// 普通toast
+ (instancetype)toastWithTitle:(NSString *)title type:(TXTToastType)type {
    [TXTToast hide];
    QSCover *cover = [QSCover show];
    cover.alpha = 0.5;
    cover.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [TXTToast alertView];
    _alertView.frame = cover.frame;

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.6];
    [_alertView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_alertView);
    }];
    bgView.cornerRadius = 10;

    /** label */
    UILabel *tipLabel = [UILabel labelWithTitle:title color:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_regularFontWithSize:14]];
    tipLabel.numberOfLines = 0;
    [bgView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.right.equalTo(bgView.mas_right).offset(-15);
        make.left.equalTo(bgView.mas_left).offset(40);
        make.width.mas_lessThanOrEqualTo(265);
        make.bottom.equalTo(bgView.mas_bottom).offset(-11);
    }];

    UIImageView *iconView = [[UIImageView alloc] init];
    
    NSString *imageName = type == TXTToastTypeCheck ? @"toast_icon_check" : @"toast_icon_warn";
    iconView.image = [UIImage imageNamed:imageName inBundle:TXTSDKBundle compatibleWithTraitCollection:nil];
    [bgView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.height.mas_equalTo(16);
    }];

    _alertView.count = 3;
    
    [_alertView animationWithView:bgView duration:0.5];
    
    [_alertView performSelector:@selector(countDown) withObject:nil afterDelay:1.5];
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


- (void)endPolling {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    });
}

- (void)countDown {
    _alertView.count -= 1;
    if (_alertView.count <= 0) {
        [TXTToast hide];
    } else {
        [_alertView performSelector:@selector(countDown) withObject:nil afterDelay:1.0];
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
    [_alertView endPolling];
    [QSCover hide];
    [_alertView hideAlertView];
}
@end
