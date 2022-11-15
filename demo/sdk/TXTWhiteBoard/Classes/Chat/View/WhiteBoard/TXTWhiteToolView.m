//
//  TXTWhiteToolView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/8.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTWhiteToolView.h"
#import "TXTBrushThinView.h"

@interface TXTWhiteToolView ()

/** toolBtn */
@property (nonatomic, strong) UIButton *toolBtn;

/** btnsView */
@property (nonatomic, strong) UIView *btnsView;
/** divider */
@property (nonatomic, strong) UIView *divider;
/** eraserBtn */
@property (nonatomic, strong) UIButton *eraserBtn;
/** arrowBtn */
@property (nonatomic, strong) UIButton *arrowBtn;
/** paintBtn */
@property (nonatomic, strong) UIButton *paintBtn;
/** shotBtn */
@property (nonatomic, strong) UIButton *shotBtn;

/** brushThinView */
@property (nonatomic, strong) TXTBrushThinView *brushThinView;

/** coverView */
@property (nonatomic, strong) UIView *coverView;

@end

@implementation TXTWhiteToolView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 7;
        self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1500].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 5;
        
        [self initUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

/// initUI
- (void)initUI {
//    [self addSubview:self.toolView];
//    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(15);
//        make.width.height.mas_equalTo(40);
//        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-76);
//    }];
    
    [self addSubview:self.toolBtn];
    [self.toolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(28.5);
        make.height.mas_equalTo(28);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
    
    [self addSubview:self.btnsView];
    [self.btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self.toolBtn.mas_left).offset(-5);
    }];
    self.btnsView.hidden = YES;
    
    [self.btnsView addSubview:self.divider];
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnsView.mas_right).offset(-3);
        make.width.mas_equalTo(1);
        make.centerY.equalTo(self.btnsView.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    [self.btnsView addSubview:self.eraserBtn];
    [self.eraserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.divider.mas_left).offset(-14);
        make.width.height.equalTo(self.toolBtn);
        make.centerY.equalTo(self.btnsView.mas_centerY);
    }];
    [self.btnsView addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.eraserBtn.mas_left).offset(-15.5);
        make.width.height.centerY.equalTo(self.eraserBtn);
    }];
    [self.btnsView addSubview:self.paintBtn];
    [self.paintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowBtn.mas_left).offset(-15.5);
        make.width.height.centerY.equalTo(self.eraserBtn);
    }];
    [self.btnsView addSubview:self.shotBtn];
    [self.shotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.paintBtn.mas_left).offset(-15.5);
        make.width.height.centerY.equalTo(self.eraserBtn);
    }];
    
    
   
}

/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
    if (![UIWindow isLandscape]) {
       
    } else {
        
    }
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside) {
//        inside = [self.fontBgView pointInside:[self convertPoint:point toView:self.fontBgView] withEvent:event];
    }
    return inside;
}

/// toolBtnClick
- (void)toolBtnClick {
    self.toolBtn.selected = !self.toolBtn.selected;
    if ([self.delegate respondsToSelector:@selector(whiteToolViewDidClickToolBtn:)]) {
        [self.delegate whiteToolViewDidClickToolBtn:self.toolBtn];
    }
    self.btnsView.hidden = !self.toolBtn.selected;
}

/// setBtnStatus
- (void)setBtnStatus {
    for (UIView *subView  in self.btnsView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subView;
            btn.selected = NO;
        }
    }
}

/// eraserBtnClick
- (void)eraserBtnClick {
    [self setBtnStatus];
    self.eraserBtn.selected = !self.eraserBtn.selected;

    [[[TICManager sharedInstance] getBoardController] setToolType:TEDU_BOARD_TOOL_TYPE_ERASER];

    if ([self.delegate respondsToSelector:@selector(whiteToolViewDidClickEraserBtn:)]) {
        [self.delegate whiteToolViewDidClickEraserBtn:self.eraserBtn];
    }
}

///arrowBtnClick
- (void)arrowBtnClick {
    [self setBtnStatus];
    [[[TICManager sharedInstance] getBoardController] setToolType:TEDU_BOARD_TOOL_TYPE_OVAL];
    self.arrowBtn.selected = !self.arrowBtn.selected;
    if ([self.delegate respondsToSelector:@selector(whiteToolViewDidClickArrowBtn:)]) {
        [self.delegate whiteToolViewDidClickArrowBtn:self.arrowBtn];
    }
}

/// paintBtnClick
- (void)paintBtnClick {
    [self setBtnStatus];
    [[[TICManager sharedInstance] getBoardController] setToolType:TEDU_BOARD_TOOL_TYPE_PEN];
    self.paintBtn.selected = !self.paintBtn.selected;
    if ([self.delegate respondsToSelector:@selector(whiteToolViewDidClickPaintBtn:)]) {
        [self.delegate whiteToolViewDidClickPaintBtn
         :self.paintBtn];
    }
}

/// shotBtnClick
- (void)shotBtnClick {
    
}

- (UIButton *)toolBtn {
    if (!_toolBtn) {
        UIButton *toolBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(toolBtnClick)];
        [toolBtn setImage:[UIImage imageNamed:@"white_icon_tool" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [toolBtn setImage:[UIImage imageNamed:@"white_icon_tool" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        self.toolBtn = toolBtn;
    }
    return _toolBtn;
}

- (UIView *)btnsView {
    if (!_btnsView) {
        UIView *btnsView = [[UIView alloc] init];
        self.btnsView = btnsView;
    }
    return _btnsView;
}

- (UIView *)divider {
    if (!_divider) {
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"  alpha:0.8];
        self.divider = divider;
    }
    return _divider;
}

- (UIButton *)eraserBtn {
    if (!_eraserBtn) {
        UIButton *eraserBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(eraserBtnClick)];
        [eraserBtn setImage:[UIImage imageNamed:@"white_icon_eraserNormal" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [eraserBtn setImage:[UIImage imageNamed:@"white_icon_eraserSelected" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        self.eraserBtn = eraserBtn;
    }
    return _eraserBtn;
}

- (UIButton *)arrowBtn {
    if (!_arrowBtn) {
        UIButton *arrowBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(arrowBtnClick)];
        [arrowBtn setImage:[UIImage imageNamed:@"white_icon_ellipseNormal" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [arrowBtn setImage:[UIImage imageNamed:@"white_icon_ellipseSelected" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        self.arrowBtn = arrowBtn;
    }
    return _arrowBtn;
}

- (UIButton *)paintBtn {
    if (!_paintBtn) {
        UIButton *paintBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(paintBtnClick)];
        [paintBtn setImage:[UIImage imageNamed:@"white_icon_paintNormal" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [paintBtn setImage:[UIImage imageNamed:@"white_icon_paintSelected" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        self.paintBtn = paintBtn;
    }
    return _paintBtn;
}

- (UIButton *)shotBtn {
    if (!_shotBtn) {
        UIButton *shotBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(shotBtnClick)];
        [shotBtn setImage:[UIImage imageNamed:@"white_icon_shotNormal" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [shotBtn setImage:[UIImage imageNamed:@"white_icon_shotNormal" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        self.shotBtn = shotBtn;
    }
    return _shotBtn;
}


@end
