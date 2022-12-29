//
//  TXTWhiteBoardView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/8.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTWhiteBoardView.h"
#import "TXTWhiteToolView.h"
#import "TXTBrushThinView.h"
#import "TXTTeleprompView.h"

@interface TXTWhiteBoardView () <TXTWhiteToolViewDelegate, TXTTeleprompViewDelegate>
/** endBtn */
@property (nonatomic, strong) UIButton *endBtn;
///** endIcon */
//@property (nonatomic, strong) UIImageView *endIcon;
///** endLabel */
//@property (nonatomic, strong) UILabel *endLabel;

/** toolView */
@property (nonatomic, strong) TXTWhiteToolView *toolView;
/** coverView */
@property (nonatomic, strong) UIView *coverView;
/** brushThinView */
@property (nonatomic, strong) TXTBrushThinView *brushThinView;

/** teleprompView */
@property (nonatomic, strong) TXTTeleprompView *teleprompView;
@end

@implementation TXTWhiteBoardView

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
    [self addSubview:self.endBtn];
    [self.endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-30);
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(30);
    }];
    self.endBtn.cornerRadius = 5;
    
    [self addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-15);
        make.width.height.mas_equalTo(40);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-76);
    }];
    
    [self addSubview:self.teleprompView];
    [self.teleprompView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(0);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(99);
    }];
    self.teleprompView.hidden = YES;
    
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.coverView addTarget:self action:@selector(hideCover)];
    self.coverView.hidden = YES;
    
    if (![UIWindow isLandscape]) {
        [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(54);
//            make.height.mas_equalTo(36);
//            make.width.mas_equalTo(122);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(0);
//            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(80);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(99);
        }];
    } else {
        [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(0);
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(80);
//            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-70);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(99);
        }];
    }
    
    if (![UIWindow isLandscape]) {
        [self updateUI:YES];
    } else {
        [self updateUI:NO];
    }
}

- (void)setIsTelepromp:(BOOL)isTelepromp {
    _isTelepromp = isTelepromp;
    self.teleprompView.hidden = !self.isTelepromp;
    
    [self updateUI:![UIWindow isLandscape]];
}

- (void)setTeleprompStr:(NSString *)teleprompStr {
    _teleprompStr = [teleprompStr copy];
    self.teleprompView.teleprompStr = teleprompStr;
}


/// hideCover
- (void)hideCover {
    [self.coverView removeAllSubViews];
    self.coverView.hidden = YES;
}

/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
    [self hideCover];
//    if (![UIWindow isLandscape]) {
//        [self updateUI:YES];
//    } else {
//        [self updateUI:NO];
//    }
//    [self teleprompViewDidClickSwitchView];
}

- (void)updateUI:(BOOL)isPortrait {
    self.coverView.hidden = YES;
    if (self.isTelepromp) {
        CGFloat bottomH = ![UIWindow isLandscape] ? (-76 - 90) : (-20 - 90);
        CGFloat rightMargin = ![UIWindow isLandscape] ? Adapt(-15) : Adapt(-65);
        if (self.teleprompView.isOpen) {
            if ([UIWindow isLandscape]) {
                rightMargin = rightMargin - 180;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kTeleprompStatus" object:nil userInfo:@{@"kTeleprompStatus" : @"close"}];
        }
        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(rightMargin);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(bottomH);
        }];
        
        if (self.teleprompView.isOpen && self.teleprompView.teleprompStr.length > 0) {
            [self teleprompViewDidClickOpen];
        } else {
            CGFloat teleprompViewTopH = ![UIWindow isLandscape] ? 54 : 80;
            [self.teleprompView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(teleprompViewTopH);
            }];
        }
        [self.teleprompView updateUI:![UIWindow isLandscape]];

//
//        // 横屏需要处理
//        CGFloat rightMargin = ![UIWindow isLandscape] ? -15 : -55;
//        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(rightMargin);
//            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(bottomH);
//        }];
//
//        CGFloat bottomH = isPortrait ? -76 : - 20;
//        CGFloat rightMargin = isPortrait ? -15 : -65;
//        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(rightMargin);
//            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(bottomH);
//        }];
//        CGFloat topH = isPortrait ? 0 : 20;
//        [self.endBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(topH);
//        }];
//
//        if (self.teleprompView.isOpen) {
//            [self teleprompViewDidClickOpen];
//        } else {
//            CGFloat teleprompViewTopH = isPortrait ? 54 : 80;
//            [self.teleprompView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(teleprompViewTopH);
//            }];
//        }
//        [self.teleprompView updateUI:isPortrait];
//    }
    } else {
        CGFloat bottomH = isPortrait ? -76 : - 20;
        CGFloat rightMargin = isPortrait ? Adapt(-15) : Adapt(-65);
        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(rightMargin);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(bottomH);
        }];
        CGFloat topH = isPortrait ? 0 : 20;
        [self.endBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(topH);
        }];
    }
//        CGFloat bottomH = isPortrait ? -76 : - 20;
//        CGFloat rightMargin = isPortrait ? -15 : -65;
//        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(rightMargin);
//            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(bottomH);
//        }];
//        CGFloat topH = isPortrait ? 0 : 20;
//        [self.endBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(topH);
//        }];

//        if (self.teleprompView.isOpen) {
//            [self teleprompViewDidClickOpen];
//        } else {
//            CGFloat teleprompViewTopH = isPortrait ? 54 : 80;
//            [self.teleprompView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(teleprompViewTopH);
//            }];
//        }
//        [self.teleprompView updateUI:isPortrait];
//    }
}

/// endBtnClick
- (void)endBtnClick {
    if ([self.delegate respondsToSelector:@selector(whiteBoardViewDidClickEndBtn:)]) {
        [self.delegate whiteBoardViewDidClickEndBtn:self.endBtn];
    }
}

- (void)whiteToolViewDidClickToolBtn:(UIButton *)toolBtn {
    CGFloat bottomH = [UIWindow isLandscape] ? - 20 : -76;
    CGFloat rightMargin = ![UIWindow isLandscape] ? Adapt(-15) : Adapt(-65);
    if (self.isTelepromp) {
        bottomH = bottomH - 90;
    }
    if (self.teleprompView.isOpen) {
        if ([UIWindow isLandscape]) {
            rightMargin = rightMargin - 180;
        }
    }
    if (toolBtn.selected) { // 展开
        [self.toolView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(rightMargin);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(232 - 44);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(bottomH);
        }];
    } else {
        [self.toolView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(rightMargin);
            make.width.height.mas_equalTo(40);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(bottomH);
        }];
    }
}

/// 点击箭头
- (void)whiteToolViewDidClickArrowBtn:(UIButton *)arrowBtn {
    [self.coverView addSubview:self.brushThinView];
    [self.brushThinView setType:TXTBrushThinViewTypeArrow];
    
    CGFloat bottomH = [UIWindow isLandscape] ? -61 : -124;
    if (self.isTelepromp) {
        bottomH = bottomH - 90;
    }
    CGRect newFrame = [self.toolView convertRect:self.toolView.bounds toView:self.coverView];
    CGFloat centerX = newFrame.size.width / 2 + newFrame.origin.x;
    [self.brushThinView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(97);
        make.centerX.equalTo(self.mas_left).offset(centerX);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(bottomH);
    }];
    [self.coverView layoutIfNeeded];
    self.coverView.hidden = NO;
}

/// 点击画笔
- (void)whiteToolViewDidClickPaintBtn:(UIButton *)paintBtn {
    [self.coverView addSubview:self.brushThinView];
    [self.brushThinView setType:TXTBrushThinViewTypePaint];
    
    CGFloat bottomH = [UIWindow isLandscape] ? -61 : -124;
    if (self.isTelepromp) {
        bottomH = bottomH - 90;
    }
    CGRect newFrame = [self.toolView convertRect:self.toolView.bounds toView:self.coverView];
    CGFloat centerX = newFrame.size.width / 2 + newFrame.origin.x;
    [self.brushThinView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(97);
        make.centerX.equalTo(self.mas_left).offset(centerX);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(bottomH);
    }];
//    [self.brushThinView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(165);
//        make.height.mas_equalTo(97);
//        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-48.5);
//        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(bottomH);
//    }];
    [self.coverView layoutIfNeeded];
    self.coverView.hidden = NO;
}

/// 关闭
- (void)teleprompViewDidClickClose {
    if (![UIWindow isLandscape]) {
        [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
//            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(54);
//    //        make.right.equalTo(self.view.mas_right).offset(-10);
//            make.height.mas_equalTo(36);
//            make.width.mas_equalTo(122);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(0);
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(54);
//            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(80);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(99);
        }];
    } else {
        [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(0);
//            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-70);
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(80);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(99);
        }];
        
        CGFloat rightMargin = ![UIWindow isLandscape] ? Adapt(-15) : Adapt(-65);
        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(rightMargin);
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kTeleprompStatus" object:nil userInfo:@{@"kTeleprompStatus" : @"close"}];
    }
}

/// 展开
- (void)teleprompViewDidClickOpen {
    if (![UIWindow isLandscape]) {
        [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(54);
//            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(80);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
            make.height.mas_equalTo(150).priorityHigh();
        }];
    } else {
        [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(0);
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(80);
            make.height.mas_equalTo(Adapt(185)).priorityHigh();
            make.width.mas_equalTo(180);
//            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-70);
        }];
        CGFloat rightMargin = ![UIWindow isLandscape] ? (Adapt(-15) - 180) : (Adapt(-65) - 180);
        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(rightMargin);
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kTeleprompStatus" object:nil userInfo:@{@"kTeleprompStatus" : @"open"}];
    }
}

///// 点击了switch
////- (void)teleprompViewDidClickSwitchView:(UISwitch *)switchView {
//- (void)teleprompViewDidClickSwitchView {
//    if (self.teleprompView.isOpen) {
//        if (![UIWindow isLandscape]) {
//            [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
//                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(54);
//                make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
//                make.height.mas_equalTo(150).priorityHigh();
//            }];
//        } else {
//            [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(0);
//                make.height.mas_equalTo(Adapt(185)).priorityHigh();
//                make.width.mas_equalTo(180);
////                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-70);
//                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(80);
//            }];
//        }
////        [self.teleprompView upDateUIWithSwithch:YES];
//    } else {
//        if (![UIWindow isLandscape]) {
//            [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(0);
//                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(54);
//        //        make.right.equalTo(self.view.mas_right).offset(-10);
////                make.height.mas_equalTo(36);
////                make.width.mas_equalTo(122);
//                make.height.mas_equalTo(40);
//                make.width.mas_equalTo(99);
//            }];
//        } else {
//            [self.teleprompView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(0);
////                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-70);
//                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(80);
//                make.height.mas_equalTo(40);
//                make.width.mas_equalTo(99);
//            }];
//        }
////        [self.teleprompView upDateUIWithSwithch:NO];
//    }
////    [self layoutIfNeeded];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
//    if (![UIWindow isLandscape]) {
//        [self updateUI:YES];
//    } else {
//        [self updateUI:NO];
//    }
//    [self teleprompViewDidClickSwitchView];
}


- (TXTWhiteToolView *)toolView {
    if (!_toolView) {
        TXTWhiteToolView *toolView = [[TXTWhiteToolView alloc] init];
        toolView.delegate = self;
        self.toolView = toolView;
    }
    return _toolView;
}

- (UIView *)coverView {
    if (!_coverView) {
        UIView *coverView = [[UIView alloc] init];
//        coverView.backgroundColor = [UIColor colorWithHexString:@"D70110"];
        self.coverView = coverView;
    }
    return _coverView;
}

- (TXTBrushThinView *)brushThinView {
    if (!_brushThinView) {
        TXTBrushThinView *brushThinView = [[TXTBrushThinView alloc] init];
        self.brushThinView = brushThinView;
    }
    return _brushThinView;
}

/** endBtn */
- (UIButton *)endBtn {
    if (!_endBtn) {
        UIButton *endBtn = [UIButton buttonWithTitle:@" 结束共享" titleColor:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_regularFontWithSize:14] target:self action:@selector(endBtnClick)];
        [endBtn setImage:[UIImage imageNamed:@"white_icon_endWhite" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        endBtn.backgroundColor = [UIColor colorWithHexString:@"FF6666"];
        self.endBtn = endBtn;
    }
    return _endBtn;
}
///** endIcon */
//- (UIImageView *)endIcon {
//    if (!_endIcon) {
//        UIImageView *endIcon = [[UIImageView alloc] init];
//        endIcon.image = [UIImage imageNamed:@"white_icon_endWhite" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil];
//        self.endIcon = endIcon;
//    }
//    return _endIcon;
//}
///** endLabel */
//- (UILabel *)endLabel {
//    if (!_endLabel) {
//        UILabel *endLabel = [UILabel labelWithTitle:@"结束共享" color:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_regularFontWithSize:14]];
//        self.endLabel = endLabel;
//    }
//    return _endLabel;
//}

- (TXTTeleprompView *)teleprompView {
    if (!_teleprompView) {
        TXTTeleprompView *teleprompView = [[TXTTeleprompView alloc] init];
        teleprompView.delegate = self;
        self.teleprompView = teleprompView;
    }
    return _teleprompView;
}
@end
