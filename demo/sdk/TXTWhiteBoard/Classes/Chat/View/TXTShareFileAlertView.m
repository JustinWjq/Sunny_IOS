//
//  TXTShareFileAlertView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/14.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTShareFileAlertView.h"

@interface TXTShareFileAlertView ()
/** contenView */
@property (nonatomic, strong) UIView *contenView;
/** fileBtn */
@property (nonatomic, strong) UIButton *fileBtn;

/** whiteBtn */
@property (nonatomic, strong) UIButton *whiteBtn;
@end

@implementation TXTShareFileAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Setup UI
/**
 *  setupUI
 */
- (void)setupUI {
    [self addSubview:self.contenView];
    [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).multipliedBy(5.0/6.0);
        make.width.mas_equalTo(112);
        make.height.mas_equalTo(80);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-Adapt(60 + 15));
    }];
    self.contenView.cornerRadius = 3;
    [self.contenView addSubview:self.fileBtn];
    [self.fileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contenView);
        make.height.mas_equalTo(40);
    }];
    [self.contenView addSubview:self.whiteBtn];
    [self.whiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contenView);
        make.height.mas_equalTo(40);
    }];
}

/**
 *  显示
 */
- (void)show {
    // 1获得最上面的窗口
    UIWindow *window = [UIWindow getKeyWindow];
    // 2添加自己到窗口上去
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

/**
 *  销毁
 */
- (void)dismiss {
    [self removeFromSuperview];
}


/// fileBtnClick
- (void)fileBtnClick {
    if (self.fileBlock) {
        self.fileBlock();
    }
    [self dismiss];
}

/// whiteBtnClick
- (void)whiteBtnClick {
    if (self.whiteBoardBlock) {
        self.whiteBoardBlock();
    }
    [self dismiss];
}

- (UIView *)contenView {
    if (!_contenView) {
        UIView *contenView = [[UIView alloc] init];
        contenView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.74];
        self.contenView = contenView;
    }
    return _contenView;
}

- (UIButton *)fileBtn {
    if (!_fileBtn) {
        UIButton *fileBtn = [UIButton buttonWithTitle:@"文件" titleColor:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_semiFontWithSize:14] target:self action:@selector(fileBtnClick)];
        self.fileBtn = fileBtn;
    }
    return _fileBtn;
}

- (UIButton *)whiteBtn {
    if (!_whiteBtn) {
        UIButton *whiteBtn = [UIButton buttonWithTitle:@"电子白板" titleColor:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_semiFontWithSize:14] target:self action:@selector(whiteBtnClick)];
        self.whiteBtn = whiteBtn;
    }
    return _whiteBtn;
}

@end
