//
//  TXTCommonAlertView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/7.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTCommonAlertView.h"
#import "QSCover.h"


@interface TXTCommonAlertView ()

/** count */
@property (nonatomic, assign) NSInteger count;
/** messageLabel */
@property (nonatomic, strong) UILabel *messageLabel;
/** messageStr */
@property (nonatomic, copy) NSString *messageStr;
/** sureBtn */
@property (nonatomic, strong) UIButton *sureBtn;
/** sureStr */
@property (nonatomic, copy) NSString *sureStr;

@end

@implementation TXTCommonAlertView

static TXTCommonAlertView *_alertView = nil; //第一步：静态实例，并初始化。

+ (instancetype)alertView {
    // 创建活动菜单
    if (!_alertView) {
        _alertView = [[TXTCommonAlertView alloc] init];
    }
    return _alertView;
}

+ (instancetype)getAlertView {
    return _alertView;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message leftBtnStr:(nullable NSString *)leftStr rightBtnStr:(nullable NSString *)rightStr leftColor:(nullable UIColor *)leftColor rightColor:(nullable UIColor *)rightColor {
    QSCover *cover = [QSCover show];
    cover.alpha = 0.3;
    cover.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [TXTCommonAlertView alertView];
    _alertView.frame = cover.frame;

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:bgView];
    CGFloat width = 295;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.center.equalTo(_alertView);
    }];
    bgView.cornerRadius = 10;

    /** label */
    UILabel *tipLabel = [UILabel labelWithTitle:title color:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_regularFontWithSize:15]];
    tipLabel.numberOfLines = 0;
    [bgView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.width.mas_lessThanOrEqualTo(265);
        make.centerX.equalTo(bgView.mas_centerX);
    }];

    UIButton *checkBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@" %@", message] titleColor:[UIColor colorWithHexString:@"666666"] font:[UIFont qs_regularFontWithSize:10] target:_alertView action:@selector(checkBtnClick:)];
    [checkBtn setImage:[UIImage imageNamed:@"member_icon_unCheck" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"member_icon_checked" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [bgView addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.top.equalTo(tipLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(16);
        make.bottom.equalTo(bgView.mas_bottom).offset(-62);
    }];

    /** divider */
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [[UIColor colorWithHexString:@"D8D8D8"] colorWithAlphaComponent:0.8];
    [bgView addSubview:divider];
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(bgView.mas_bottom).offset(-44);
    }];
            
    
    CGFloat btnWidth = leftStr.length > 0 ? width / 2 : width;

    if (!rightColor) {
        rightColor = [UIColor colorWithHexString:@"E6B980"];
    }
    UIButton *sureBtn = [UIButton buttonWithTitle:rightStr titleColor:rightColor font:[UIFont qs_regularFontWithSize:16] target:_alertView action:@selector(sureBtnClick)];
    [bgView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(btnWidth);
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    
    if (leftStr) {
        [sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX).offset(btnWidth / 2);
        }];
        
        if (!leftColor) {
            leftColor = [UIColor colorWithHexString:@"666666"];
        }
        UIButton *cancelBtn = [UIButton buttonWithTitle:leftStr titleColor:leftColor font:[UIFont qs_regularFontWithSize:16] target:_alertView action:@selector(cancelButtonClick)];
        [bgView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.bottom.equalTo(sureBtn);
            make.left.mas_equalTo(0);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [[UIColor colorWithHexString:@"D8D8D8"] colorWithAlphaComponent:0.8];
        [cancelBtn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(cancelBtn);
            make.width.mas_equalTo(1);
        }];
    }

    [_alertView animationWithView:bgView duration:0.5];

    [[UIWindow getKeyWindow] addSubview:_alertView];
    return _alertView;
}


+ (instancetype)alertWithTitle:(NSString *)title titleColor:(nullable UIColor *)titleColor titleFont:(UIFont *)titleFont leftBtnStr:(nullable NSString *)leftStr rightBtnStr:(nullable NSString *)rightStr leftColor:(nullable UIColor *)leftColor rightColor:(nullable UIColor *)rightColor {
    QSCover *cover = [QSCover show];
    cover.alpha = 0.3;
    cover.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [TXTCommonAlertView alertView];
    _alertView.frame = cover.frame;

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:bgView];
    CGFloat width = 295;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.center.equalTo(_alertView);
    }];
    bgView.cornerRadius = 10;

    /** label */
    
    if (!titleColor) {
        titleColor = [UIColor colorWithHexString:@"333333"];
    }
    if (!titleFont) {
        titleFont = [UIFont qs_regularFontWithSize:15];
    }
    UILabel *tipLabel = [UILabel labelWithTitle:title color:titleColor font:titleFont];
    tipLabel.numberOfLines = 0;
    [bgView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.width.mas_lessThanOrEqualTo(265);
        make.centerX.equalTo(bgView.mas_centerX);
        make.bottom.equalTo(bgView.mas_bottom).offset(-62);
    }];

    /** divider */
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [[UIColor colorWithHexString:@"D8D8D8"] colorWithAlphaComponent:0.8];
    [bgView addSubview:divider];
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(bgView.mas_bottom).offset(-44);
    }];
            
    CGFloat btnWidth = leftStr.length > 0 ? width / 2 : width;
    if (!rightColor) {
        rightColor = [UIColor colorWithHexString:@"E6B980"];
    }
    UIButton *sureBtn = [UIButton buttonWithTitle:rightStr titleColor:rightColor font:[UIFont qs_regularFontWithSize:16] target:_alertView action:@selector(sureBtnClick)];
    [bgView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(btnWidth);
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    
    if (leftStr) {
        [sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX).offset(btnWidth / 2);
        }];
        
        if (!leftColor) {
            leftColor = [UIColor colorWithHexString:@"666666"];
        }
        UIButton *cancelBtn = [UIButton buttonWithTitle:leftStr titleColor:leftColor font:[UIFont qs_regularFontWithSize:16] target:_alertView action:@selector(cancelButtonClick)];
        [bgView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.bottom.equalTo(sureBtn);
            make.left.mas_equalTo(0);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [[UIColor colorWithHexString:@"D8D8D8"] colorWithAlphaComponent:0.8];
        [cancelBtn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(cancelBtn);
            make.width.mas_equalTo(1);
        }];
    }
    [_alertView animationWithView:bgView duration:0.5];

    [[UIWindow getKeyWindow] addSubview:_alertView];
    return _alertView;
}


+ (instancetype)countDownAlertWithTitle:(NSString *)title message:(NSString *)message rightBtnStr:(nullable NSString *)rightStr rightColor:(nullable UIColor *)rightColor time:(NSInteger)time; {
    QSCover *cover = [QSCover show];
    cover.alpha = 0.3;
    cover.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [TXTCommonAlertView alertView];
    _alertView.frame = cover.frame;

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:bgView];
    CGFloat width = 295;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.center.equalTo(_alertView);
    }];
    bgView.cornerRadius = 10;

    /** label */
    UILabel *tipLabel = [UILabel labelWithTitle:title color:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_regularFontWithSize:15]];
    tipLabel.numberOfLines = 0;
    [bgView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.width.mas_lessThanOrEqualTo(265);
        make.centerX.equalTo(bgView.mas_centerX);
    }];

    UILabel *messageLabel = [UILabel labelWithTitle:[NSString stringWithFormat:@"%zds%@", time, message] color:[UIColor colorWithHexString:@"999999"] font:[UIFont qs_regularFontWithSize:12]];
    [bgView addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.top.equalTo(tipLabel.mas_bottom).offset(12);
//        make.height.mas_equalTo(16);
        make.bottom.equalTo(bgView.mas_bottom).offset(-62);
    }];
    _alertView.messageStr = message;
    _alertView.messageLabel = messageLabel;


    /** divider */
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [[UIColor colorWithHexString:@"D8D8D8"] colorWithAlphaComponent:0.8];
    [bgView addSubview:divider];
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(bgView.mas_bottom).offset(-44);
    }];
        
    if (!rightColor) {
        rightColor = [UIColor colorWithHexString:@"E6B980"];
    }
    UIButton *sureBtn = [UIButton buttonWithTitle:[NSString stringWithFormat:@"%@（%zd）", rightStr, time] titleColor:rightColor font:[UIFont qs_regularFontWithSize:16] target:_alertView action:@selector(countDownSureBtnClick)];
    [bgView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(width);
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    _alertView.sureStr = rightStr;
    _alertView.sureBtn = sureBtn;
    
    [_alertView animationWithView:bgView duration:0.5];
    
    _alertView.count = time;
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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.frame = CGRectMake(0, 0, QSScreenW, QSScreenH);
    }
    return self;
}

#pragma mark - Method
/// checkBtnClick
- (void)checkBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
}


- (void)endPolling {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    });
}

- (void)countDown {
    _alertView.count -= 1;
    if (_alertView.count <= 0) {
        [_alertView endPolling];
        [TXTCommonAlertView hide];
    } else {
        [_alertView performSelector:@selector(countDown) withObject:nil afterDelay:1.0];
        _alertView.messageLabel.text = [NSString stringWithFormat:@"%zds%@", _alertView.count, _alertView.messageStr];
        [_alertView.sureBtn setTitle:[NSString stringWithFormat:@"%@（%zd）", _alertView.sureStr, _alertView.count] forState:UIControlStateNormal];
    }
}

#pragma mark - TYCyclePagerViewDataSource

/**
 *  sureBtnClick
 */
- (void)sureBtnClick {
    if (self.sureBlock) {
        self.sureBlock();
    }
}

/// countDownSureBtnClick
- (void)countDownSureBtnClick {
    [_alertView endPolling];
    [TXTCommonAlertView hide];
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
    [TXTCommonAlertView hide];
}

- (void)dealloc {
    QSLog(@"%@ --- dealloc", self);
}

#pragma mark - Config UI


#pragma mark - LazyLoad

@end

