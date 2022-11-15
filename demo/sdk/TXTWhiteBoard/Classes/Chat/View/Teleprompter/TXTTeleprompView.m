//
//  TXTTeleprompView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/7.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTTeleprompView.h"

@interface TXTTeleprompView ()
/** bgView */
@property (nonatomic, strong) UIView *bgView;
/** nameLabel */
@property (nonatomic, strong) UILabel *nameLabel;
///** switchView */
//@property (nonatomic, strong) UISwitch *switchView;
/** contentLabel */
@property (nonatomic, strong) UILabel *contentLabel;
/** fontBtn */
@property (nonatomic, strong) UIButton *fontBtn;
/** fontBgView */
@property (nonatomic, strong) UIView *fontBgView;
/** bigFontBtn */
@property (nonatomic, strong) UIButton *bigFontBtn;
/** mindFontBtn */
@property (nonatomic, strong) UIButton *midFontBtn;
/** smallFontBtn */
@property (nonatomic, strong) UIButton *smallFontBtn;

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
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(16);
    }];
    
    [self addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-13);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.equalTo(self.mas_right).offset(-7);
        make.top.mas_equalTo(34);
        make.bottom.equalTo(self.mas_bottom).offset(-55);
    }];
    
    [self addSubview:self.fontBtn];
    [self.fontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(22);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];
    self.fontBtn.hidden = YES;
  
    [self addSubview:self.fontBgView];
    [self.fontBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fontBtn).offset(2);
        make.width.mas_equalTo(112);
        make.height.mas_equalTo(120);
        make.top.equalTo(self.fontBtn.mas_bottom).offset(10);
    }];
    self.fontBgView.hidden = YES;
    [self.fontBgView addSubview:self.bigFontBtn];
    [self.bigFontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.fontBgView);
        make.height.mas_equalTo(40);
    }];
    [self.fontBgView addSubview:self.midFontBtn];
    [self.midFontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.equalTo(self.bigFontBtn);
        make.top.equalTo(self.bigFontBtn.mas_bottom);
    }];
    [self.fontBgView addSubview:self.smallFontBtn];
    [self.smallFontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.equalTo(self.bigFontBtn);
        make.top.equalTo(self.midFontBtn.mas_bottom);
    }];
    
//    if (![UIWindow isLandscape]) {
//        [self updateUI:YES];
//    } else {
//        [self updateUI:NO];
//    }
}

/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
    if (![UIWindow isLandscape]) {
        [self updateUI:YES];
    } else {
        [self updateUI:NO];
    }
}

- (void)updateUI:(BOOL)isPortrait {
    if (isPortrait) {
        [self.fontBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fontBtn).offset(2);
            make.width.mas_equalTo(112);
            make.height.mas_equalTo(120);
            make.top.equalTo(self.fontBtn.mas_bottom).offset(10);
        }];
    } else {
        [self.fontBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fontBtn).offset(2);
            make.width.mas_equalTo(112);
            make.height.mas_equalTo(120);
            make.bottom.equalTo(self.fontBtn.mas_top).offset(-10);
        }];
    }
//    [self layoutIfNeeded];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside) {
        inside = [self.fontBgView pointInside:[self convertPoint:point toView:self.fontBgView] withEvent:event];
    }
    return inside;
}
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
    self.fontBtn.hidden = !isOn;
    self.contentLabel.hidden = !isOn;
    self.fontBgView.hidden = YES;
    if (isOn) {
        [self.switchView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-13);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
        }];
    } else {
        [self.switchView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-13);
            make.centerY.equalTo(self.nameLabel);
        }];
    }
}

/// fontBtnClick
- (void)fontBtnClick {
    self.fontBgView.hidden = !self.fontBgView.hidden;
}

/// switchView
- (void)swtichValueChange:(UISwitch *)switchView {
    if ([self.delegate respondsToSelector:@selector(teleprompViewDidClickSwitchView:)]) {
        [self.delegate teleprompViewDidClickSwitchView:switchView];
    }
}

/// fontSizeBtnClick
- (void)fontSizeBtnClick:(UIButton *)btn {
    if (btn == self.bigFontBtn) {
        self.contentLabel.font = [UIFont qs_regularFontWithSize:16];
    } else if (btn == self.midFontBtn) {
        self.contentLabel.font = [UIFont qs_regularFontWithSize:14];
    } else if (btn == self.smallFontBtn) {
        self.contentLabel.font = [UIFont qs_regularFontWithSize:12];
    }
    self.fontBgView.hidden = YES;
}


/** bgView */
- (UIView *)bgView {
    if (!_bgView) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3];
        bgView.cornerRadius = 8;
        self.bgView = bgView;
    }
    return _bgView;
}

/** nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *nameLabel = [UILabel labelWithTitle:@"提词器" color:[UIColor colorWithHexString:@"DADADA"] font:[UIFont qs_regularFontWithSize:12]];
        self.nameLabel = nameLabel;
    }
    return _nameLabel;
}

/** switchView */
- (UISwitch *)switchView {
    if (!_switchView) {
        //X,Y可以改变，但是高度和宽度无法修改
        UISwitch *switchView = [[UISwitch alloc] init];
        switchView.on = NO;
        //设置UISwitch的颜色，非常的有意思，大家可以实际运行一下看看
        [switchView setOnTintColor:[UIColor colorWithHexString:@"E6B980"]];
        //添加事件
        [switchView addTarget:self action:@selector(swtichValueChange:) forControlEvents:UIControlEventValueChanged];
        self.switchView = switchView;
    }
    return _switchView;
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
- (UIView *)fontBgView {
    if (!_fontBgView) {
        UIView *fontBgView = [[UIView alloc] init];
        fontBgView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.74];
        fontBgView.cornerRadius = 3;
        self.fontBgView = fontBgView;
    }
    return _fontBgView;
}
/** bigFontBtn */
- (UIButton *)bigFontBtn {
    if (!_bigFontBtn) {
        UIButton *bigFontBtn = [UIButton buttonWithTitle:@"大字体" titleColor:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_semiFontWithSize:16] target:self action:@selector(fontSizeBtnClick:)];
        self.bigFontBtn = bigFontBtn;
    }
    return _bigFontBtn;
}
/** midFontBtn */
- (UIButton *)midFontBtn {
    if (!_midFontBtn) {
        UIButton *midFontBtn = [UIButton buttonWithTitle:@"中字体" titleColor:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_semiFontWithSize:14] target:self action:@selector(fontSizeBtnClick:)];
        self.midFontBtn = midFontBtn;
    }
    return _midFontBtn;
}
/** smallFontBtn */
- (UIButton *)smallFontBtn {
    if (!_smallFontBtn) {
        UIButton *smallFontBtn = [UIButton buttonWithTitle:@"小字体" titleColor:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_semiFontWithSize:12] target:self action:@selector(fontSizeBtnClick:)];
        self.smallFontBtn = smallFontBtn;
    }
    return _smallFontBtn;
}

@end
