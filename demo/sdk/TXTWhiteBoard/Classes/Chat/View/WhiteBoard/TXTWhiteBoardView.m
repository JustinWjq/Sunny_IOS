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

@interface TXTWhiteBoardView () <TXTWhiteToolViewDelegate>
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
    
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.coverView addTarget:self action:@selector(hideCover)];
    self.coverView.hidden = YES;
}

/// hideCover
- (void)hideCover {
    [self.coverView removeAllSubViews];
    self.coverView.hidden = YES;
}

/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
        [self updateUI:YES];
    } else {
        [self updateUI:NO];
    }
}

- (void)updateUI:(BOOL)isPortrait {
    if (isPortrait) {
        
    } else {
        
    }
}

/// endBtnClick
- (void)endBtnClick {
    if ([self.delegate respondsToSelector:@selector(whiteBoardViewDidClickEndBtn:)]) {
        [self.delegate whiteBoardViewDidClickEndBtn:self.endBtn];
    }
}

- (void)whiteToolViewDidClickToolBtn:(UIButton *)toolBtn {
    if (toolBtn.selected) { // 展开
        [self.toolView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-15);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(232);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-76);
        }];
    } else {
        [self.toolView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-15);
            make.width.height.mas_equalTo(40);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-76);
        }];
    }
}

/// 点击箭头
- (void)whiteToolViewDidClickArrowBtn:(UIButton *)arrowBtn {
    self.coverView.hidden = NO;
    [self.coverView addSubview:self.brushThinView];
    [self.brushThinView setType:TXTBrushThinViewTypeArrow];
    [self.brushThinView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(97);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-48.5);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-124);
    }];
}

/// 点击画笔
- (void)whiteToolViewDidClickPaintBtn:(UIButton *)paintBtn {
    self.coverView.hidden = NO;
    [self.coverView addSubview:self.brushThinView];
    [self.brushThinView setType:TXTBrushThinViewTypePaint];
    [self.brushThinView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(165);
        make.height.mas_equalTo(97);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-48.5);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-124);
    }];
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
@end
