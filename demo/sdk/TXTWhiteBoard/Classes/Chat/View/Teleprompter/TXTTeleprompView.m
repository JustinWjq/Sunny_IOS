//
//  TXTTeleprompView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/7.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTTeleprompView.h"
#import "TXTFontBgView.h"

@interface TXTTeleprompView () <TXTFontBgViewDelegate>
/** bgView */
@property (nonatomic, strong) UIView *bgView;

/** criticalBtn */
@property (nonatomic, strong) UIButton *criticalBtn;
/** contentView */
@property (nonatomic, strong) UIView *contentView;

/** nameLabel */
@property (nonatomic, strong) UILabel *nameLabel;
/** switchBtn */
@property (nonatomic, strong) UIButton *switchBtn;
///** switchView */
//@property (nonatomic, strong) UISwitch *switchView;
/** contentLabel */
@property (nonatomic, strong) UILabel *contentLabel;
/** fontBtn */
@property (nonatomic, strong) UIButton *fontBtn;

/** fontBgView */
@property (nonatomic, strong) TXTFontBgView *fontBgView;

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** containerView */
@property (nonatomic, strong) UIView *containerView;

///** fontBgView */
//@property (nonatomic, strong) UIView *fontBgView;
///** bigFontBtn */
//@property (nonatomic, strong) UIButton *bigFontBtn;
///** mindFontBtn */
//@property (nonatomic, strong) UIButton *midFontBtn;
///** smallFontBtn */
//@property (nonatomic, strong) UIButton *smallFontBtn;

///** isOpen */
//@property (nonatomic, assign) BOOL isOpen;

@end

@implementation TXTTeleprompView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// initUI
- (void)initUI {
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.bgView addSubview:self.criticalBtn];
    [self.criticalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    self.contentView.hidden = YES;
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(16);
    }];
    
//    [self.contentView addSubview:self.switchView];
//    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.right.equalTo(self.mas_right).offset(-13);
////        make.centerY.equalTo(self.nameLabel.mas_centerY);
//        make.right.equalTo(self.mas_right).offset(-13);
//        make.bottom.equalTo(self.mas_bottom).offset(-15);
//    }];
    [self.contentView addSubview:self.switchBtn];
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-14);
        make.bottom.equalTo(self.mas_bottom).offset(-11);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(22);
    }];
    
    [self.contentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.equalTo(self.mas_right).offset(-7);
        make.top.mas_equalTo(30);
        make.bottom.equalTo(self.mas_bottom).offset(-45);
    }];
    [self.scrollView addSubview:self.containerView];
    // 设置scrollView的容器视图的约束
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.containerView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(13);
//        make.right.equalTo(self.mas_right).offset(-7);
//        make.top.mas_equalTo(34);
//        make.bottom.equalTo(self.mas_bottom).offset(-55);
        make.left.right.top.bottom.equalTo(self.containerView);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 设置容器视图的底部与要显示的子控件的底部相同，不然scrollView不能滚动
        make.bottom.equalTo(self.contentLabel.mas_bottom).offset(0);
    }];
    
    [self.contentView addSubview:self.fontBtn];
    [self.fontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(22);
        make.bottom.equalTo(self.mas_bottom).offset(-11);
    }];
//    self.fontBtn.hidden = YES;
//
//    [self addSubview:self.fontBgView];
//    [self.fontBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.fontBtn).offset(2);
//        make.width.mas_equalTo(112);
//        make.height.mas_equalTo(120);
//        make.top.equalTo(self.fontBtn.mas_bottom).offset(10);
//    }];
//    self.fontBgView.hidden = YES;
//    [self.fontBgView addSubview:self.bigFontBtn];
//    [self.bigFontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self.fontBgView);
//        make.height.mas_equalTo(40);
//    }];
//    [self.fontBgView addSubview:self.midFontBtn];
//    [self.midFontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.height.right.equalTo(self.bigFontBtn);
//        make.top.equalTo(self.bigFontBtn.mas_bottom);
//    }];
//    [self.fontBgView addSubview:self.smallFontBtn];
//    [self.smallFontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.height.right.equalTo(self.bigFontBtn);
//        make.top.equalTo(self.midFontBtn.mas_bottom);
//    }];
    
//    if (![UIWindow isLandscape]) {
//        [self updateUI:YES];
//    } else {
//        [self updateUI:NO];
//    }
}

- (void)setTeleprompStr:(NSString *)teleprompStr {
    _teleprompStr = [teleprompStr copy];
    self.contentLabel.text = teleprompStr;
    self.criticalBtn.enabled = teleprompStr.length > 0 ? YES : NO;
    
    if (teleprompStr.length > 0) {
        if (self.isOpen) {
            [self criticalBtnClick];
        }
    } else {
        if (self.isOpen) {
            [self closeClick];
//            if ([self.delegate respondsToSelector:@selector(teleprompViewDidClickOpen)]) {
//                [self.delegate teleprompViewDidClickClose];
//            }
        }
    }
    
    
//    if (self.isOpen) {
//        if ([self.delegate respondsToSelector:@selector(teleprompViewDidClickOpen)]) {
//            [self.delegate teleprompViewDidClickOpen];
//        }
//    } else {
//        if ([self.delegate respondsToSelector:@selector(teleprompViewDidClickClose)]) {
//            [self.delegate teleprompViewDidClickClose];
//        }
//    }
}

/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
    [self.fontBgView dismiss];
//    if (![UIWindow isLandscape]) {
//        [self updateUI:YES];
//    } else {
//        [self updateUI:NO];
//    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
//    if ([UIWindow isLandscape]) {
//        UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.contentView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.contentView.layer.mask = maskLayer;
//    } else {
//        UIRectCorner corners = UIRectCornerAllCorners;
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.contentView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.contentView.layer.mask = maskLayer;
//    }
}

- (void)drawRect:(CGRect)rect {
    if ([UIWindow isLandscape]) {
        UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
    } else {
        UIRectCorner corners = UIRectCornerAllCorners;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
    }
}

- (void)updateUI:(BOOL)isPortrait {
    [self layoutIfNeeded];
//    if ([UIWindow isLandscape]) {
//        UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.contentView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.contentView.layer.mask = maskLayer;
//    } else {
//        UIRectCorner corners = UIRectCornerAllCorners;
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.contentView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.contentView.layer.mask = maskLayer;
//    }
    
    
//    if (isPortrait) {
//        [self.fontBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.fontBtn).offset(2);
//            make.width.mas_equalTo(112);
//            make.height.mas_equalTo(120);
//            make.top.equalTo(self.fontBtn.mas_bottom).offset(10);
//        }];
//    } else {
//        [self.fontBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.fontBtn).offset(2);
//            make.width.mas_equalTo(112);
//            make.height.mas_equalTo(120);
//            make.bottom.equalTo(self.fontBtn.mas_top).offset(-10);
//        }];
//    }
//    [self layoutIfNeeded];
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    BOOL inside = [super pointInside:point withEvent:event];
//    if (!inside) {
//        inside = [self.fontBgView pointInside:[self convertPoint:point toView:self.fontBgView] withEvent:event];
//    }
//    return inside;
//}
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    CGPoint stationPoint = [self convertPoint:point toView:self.fontBgView];
//    if (CGRectContainsPoint(self.fontBgView.bounds, stationPoint)) {
//        if (CGRectContainsPoint(self.bigFontBtn.frame, stationPoint)) {
//            return self.bigFontBtn;
//        }
//        if (CGRectContainsPoint(self.midFontBtn.frame, stationPoint)) {
//            return self.midFontBtn;
//        }
//        if (CGRectContainsPoint(self.smallFontBtn.frame, stationPoint)) {
//            return self.smallFontBtn;
//        }
//        return self.fontBgView;
//    }
//    return [super hitTest:point withEvent:event];
//}

// 更新界面
- (void)upDateUIWithSwithch:(BOOL)isOn {
//    self.fontBtn.hidden = !isOn;
//    self.contentLabel.hidden = !isOn;
//    self.fontBgView.hidden = YES;
//    if (isOn) {
//        [self.switchView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).offset(-13);
//            make.bottom.equalTo(self.mas_bottom).offset(-15);
//        }];
//    } else {
//        [self.switchView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).offset(-13);
//            make.centerY.equalTo(self.nameLabel);
//        }];
//    }
}

/// fontBtnClick
- (void)fontBtnClick {
//    self.fontBgView.hidden = !self.fontBgView.hidden;
    [self.fontBgView showFromView:self];
}

/// criticalBtnClick
- (void)criticalBtnClick {
    self.isOpen = YES;
    
    self.criticalBtn.hidden = YES;
    self.contentView.hidden = NO;
    
    if ([self.delegate respondsToSelector:@selector(teleprompViewDidClickOpen)]) {
        [self.delegate teleprompViewDidClickOpen];
    }
    
    [self layoutIfNeeded];
    if ([UIWindow isLandscape]) {
        UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
    } else {
        UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopRight;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
    }
}

/// 是否是用户点击导致关闭
- (void)closeClick {
    self.criticalBtn.hidden = NO;
    self.contentView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(teleprompViewDidClickClose)]) {
        [self.delegate teleprompViewDidClickClose];
    }
}

/// switchBtnClick
- (void)switchBtnClick {
    self.isOpen = NO;
//    self.criticalBtn.hidden = NO;
//    self.contentView.hidden = YES;
//    if ([self.delegate respondsToSelector:@selector(teleprompViewDidClickClose)]) {
//        [self.delegate teleprompViewDidClickClose];
//    }
    [self closeClick];
}

/// switchView
- (void)swtichValueChange:(UISwitch *)switchView {
//    if ([self.delegate respondsToSelector:@selector(teleprompViewDidClickSwitchView:)]) {
//        [self.delegate teleprompViewDidClickSwitchView:switchView];
//    }
//    self.isOpen = NO;
//    self.criticalBtn.hidden = NO;
//    self.contentView.hidden = YES;
//    if ([self.delegate respondsToSelector:@selector(teleprompViewDidClickClose)]) {
//        [self.delegate teleprompViewDidClickClose];
//    }
}

- (void)setCanSelected:(BOOL)canSelected {
    _canSelected = canSelected;
    
    if (self.isOpen) {
        
    } else {
        
    }
}

///// fontSizeBtnClick
//- (void)fontSizeBtnClick:(UIButton *)btn {
//    if (btn == self.bigFontBtn) {
//        self.contentLabel.font = [UIFont qs_regularFontWithSize:16];
//    } else if (btn == self.midFontBtn) {
//        self.contentLabel.font = [UIFont qs_regularFontWithSize:14];
//    } else if (btn == self.smallFontBtn) {
//        self.contentLabel.font = [UIFont qs_regularFontWithSize:12];
//    }
//    self.fontBgView.hidden = YES;
//}

- (void)fontBgViewDidClickFontSize:(CGFloat)fontSize {
    self.contentLabel.font = [UIFont qs_regularFontWithSize:fontSize];
}


/** bgView */
- (UIView *)bgView {
    if (!_bgView) {
        UIView *bgView = [[UIView alloc] init];
//        bgView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3];
//        bgView.cornerRadius = 8;
        self.bgView = bgView;
    }
    return _bgView;
}

- (UIButton *)criticalBtn {
    if (!_criticalBtn) {
        UIButton *criticalBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(criticalBtnClick)];
        [criticalBtn setBackgroundImage:[UIImage imageNamed:@"white_icon_keyWordNormal" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [criticalBtn setBackgroundImage:[UIImage imageNamed:@"white_icon_keyWordDisable" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateDisabled];
        self.criticalBtn = criticalBtn;
    }
    return _criticalBtn;
}
- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.7];
//        contentView.cornerRadius = 8;
        self.contentView = contentView;
    }
    return _contentView;
}

/** nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *nameLabel = [UILabel labelWithTitle:@"关键话术" color:[UIColor colorWithHexString:@"FF6666"] font:[UIFont qs_regularFontWithSize:12]];
        self.nameLabel = nameLabel;
    }
    return _nameLabel;
}

- (UIButton *)switchBtn {
    if (!_switchBtn) {
        UIButton *switchBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(switchBtnClick)];
        [switchBtn setBackgroundImage:[UIImage imageNamed:@"white_icon_switchBtn" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        self.switchBtn = switchBtn;
    }
    return _switchBtn;
}

///** switchView */
//- (UISwitch *)switchView {
//    if (!_switchView) {
//        //X,Y可以改变，但是高度和宽度无法修改
//        UISwitch *switchView = [[UISwitch alloc] init];
//        switchView.on = YES;
//        //设置UISwitch的颜色，非常的有意思，大家可以实际运行一下看看
//        [switchView setOnTintColor:[UIColor colorWithHexString:@"E6B980"]];
//        //添加事件
////        [switchView addTarget:self action:@selector(swtichValueChange:) forControlEvents:UIControlEventValueChanged];
////        [switchView addTarget:self action:@selector(swtichValueChange:) forControlEvents:UIControlEventTouchUpInside];
//        self.switchView = switchView;
//    }
//    return _switchView;
//}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
        self.scrollView = scrollView;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (!_containerView) {
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor clearColor];
        self.containerView = containerView;
    }
    return _containerView;
}

/** contentLabel */
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *contentLabel = [UILabel labelWithTitle:@"" color:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_regularFontWithSize:14]];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel = contentLabel;
    }
    return _contentLabel;
}
/** fontBtn */
- (UIButton *)fontBtn {
    if (!_fontBtn) {
        UIButton *fontBtn = [UIButton buttonWithTitle:@"字体" titleColor:[UIColor colorWithHexString:@"E6B980"] font:[UIFont qs_regularFontWithSize:13] target:self action:@selector(fontBtnClick)];
        fontBtn.cornerRadius = 5;
        fontBtn.borderWidth = 1;
        fontBtn.borderColor = [UIColor colorWithHexString:@"E6B980" alpha:0.8];
        self.fontBtn = fontBtn;
    }
    return _fontBtn;
}

/** fontBgView */
- (TXTFontBgView *)fontBgView {
    if (!_fontBgView) {
        TXTFontBgView *fontBgView = [[TXTFontBgView alloc] init];
        fontBgView.delegate = self;
        self.fontBgView = fontBgView;
    }
    return _fontBgView;
}

///** fontBgView */
//- (UIView *)fontBgView {
//    if (!_fontBgView) {
//        UIView *fontBgView = [[UIView alloc] init];
//        fontBgView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.74];
//        fontBgView.cornerRadius = 3;
//        self.fontBgView = fontBgView;
//    }
//    return _fontBgView;
//}
///** bigFontBtn */
//- (UIButton *)bigFontBtn {
//    if (!_bigFontBtn) {
//        UIButton *bigFontBtn = [UIButton buttonWithTitle:@"大字体" titleColor:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_semiFontWithSize:16] target:self action:@selector(fontSizeBtnClick:)];
//        self.bigFontBtn = bigFontBtn;
//    }
//    return _bigFontBtn;
//}
///** midFontBtn */
//- (UIButton *)midFontBtn {
//    if (!_midFontBtn) {
//        UIButton *midFontBtn = [UIButton buttonWithTitle:@"中字体" titleColor:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_semiFontWithSize:14] target:self action:@selector(fontSizeBtnClick:)];
//        self.midFontBtn = midFontBtn;
//    }
//    return _midFontBtn;
//}
///** smallFontBtn */
//- (UIButton *)smallFontBtn {
//    if (!_smallFontBtn) {
//        UIButton *smallFontBtn = [UIButton buttonWithTitle:@"小字体" titleColor:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_semiFontWithSize:12] target:self action:@selector(fontSizeBtnClick:)];
//        self.smallFontBtn = smallFontBtn;
//    }
//    return _smallFontBtn;
//}

@end
