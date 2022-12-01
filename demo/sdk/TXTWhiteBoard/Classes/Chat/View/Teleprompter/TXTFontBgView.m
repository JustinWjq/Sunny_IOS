//
//  TXTFontBgView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/16.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTFontBgView.h"

@interface TXTFontBgView ()
/** fontBgView */
@property (nonatomic, strong) UIView *fontBgView;
/** bigFontBtn */
@property (nonatomic, strong) UIButton *bigFontBtn;
/** mindFontBtn */
@property (nonatomic, strong) UIButton *midFontBtn;
/** smallFontBtn */
@property (nonatomic, strong) UIButton *smallFontBtn;

@end

@implementation TXTFontBgView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}
- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// initUI
- (void)initUI {
    [self addSubview:self.fontBgView];
    [self.fontBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.width.mas_equalTo(112);
        make.height.mas_equalTo(120);
        make.top.mas_equalTo(200);
    }];
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
}

/// fontSizeBtnClick
- (void)fontSizeBtnClick:(UIButton *)btn {
    CGFloat fontSize = 16;
    if (btn == self.bigFontBtn) {
        fontSize = 16;
    } else if (btn == self.midFontBtn) {
        fontSize = 14;
    } else if (btn == self.smallFontBtn) {
        fontSize = 12;
    }
    if ([self.delegate respondsToSelector:@selector(fontBgViewDidClickFontSize:)]) {
        [self.delegate fontBgViewDidClickFontSize:fontSize];
    }
    [self dismiss];
}

/**
 *  显示
 */
- (void)showFromView:(UIView *)fromView {
//    self.fromView = fromView;
    // 1获得最上面的窗口
    UIWindow *window = [UIWindow getKeyWindow];
    // 2添加自己到窗口上去
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    self.backgroundColor = [UIColor clearColor];
    QSLog(@"%@", NSStringFromCGRect(fromView.frame));
    // 转换坐标系
    CGRect newFrame = [fromView convertRect:fromView.bounds toView:window];
//    CGRect newFrame = [fromView.superview convertRect:fromView.frame toView:window];
    QSLog(@"%@", NSStringFromCGRect(newFrame));
    if ([UIWindow isLandscape]) {
        [self.fontBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(CGRectGetMinX(newFrame) - 10 - window.width);
            make.width.mas_equalTo(112);
            make.height.mas_equalTo(120);
            make.bottom.equalTo(self.mas_bottom).offset(CGRectGetMaxY(newFrame) - 40 - window.height);
        }];
    } else {
        [self.fontBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(26);
            make.width.mas_equalTo(112);
            make.height.mas_equalTo(120);
            make.top.mas_equalTo(CGRectGetMaxY(newFrame) - 5);
        }];
    }
}

/**
 *  销毁
 */
- (void)dismiss {
    [self removeFromSuperview];
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
