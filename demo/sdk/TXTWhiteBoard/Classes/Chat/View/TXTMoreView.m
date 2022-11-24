//
//  TXTMoreView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/15.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTMoreView.h"

@interface TXTMoreView ()
/** contenView */
@property (nonatomic, strong) UIView *contenView;
/** chatBtn */
@property (nonatomic, strong) UIButton *chatBtn;
/** chatIcon */
@property (nonatomic, strong) UIImageView *chatIcon;
/** chatLabel */
@property (nonatomic, strong) UILabel *chatLabel;

@end

@implementation TXTMoreView

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
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-70);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(- Adapt(60 + 15));
    }];
    self.contenView.cornerRadius = 10;
    [self.contenView addSubview:self.chatBtn];
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contenView);
        make.height.width.mas_equalTo(44);
    }];
    self.chatBtn.cornerRadius = 6;
    [self.chatBtn addSubview:self.chatIcon];
    [self.chatIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(20);
        make.centerX.equalTo(self.chatBtn);
        make.top.mas_equalTo(6);
    }];
    [self.chatBtn addSubview:self.chatLabel];
    [self.chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.centerX.equalTo(self.chatBtn);
        make.bottom.equalTo(self.chatBtn.mas_bottom).offset(-3);
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


/// chatBtnClick
- (void)chatBtnClick {
    [self dismiss];
    if (self.chatBlock) {
        self.chatBlock();
    }
}


- (UIView *)contenView {
    if (!_contenView) {
        UIView *contenView = [[UIView alloc] init];
        contenView.backgroundColor = [UIColor colorWithHexString:@"080808" alpha:1.0];
        self.contenView = contenView;
    }
    return _contenView;
}

- (UIButton *)chatBtn {
    if (!_chatBtn) {
        UIButton *chatBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_semiFontWithSize:14] target:self action:@selector(chatBtnClick)];
        chatBtn.backgroundColor = [UIColor colorWithHexString:@"212226"];
        self.chatBtn = chatBtn;
    }
    return _chatBtn;
}

- (UIImageView *)chatIcon {
    if (!_chatIcon) {
        UIImageView *chatIcon = [[UIImageView alloc] init];
        chatIcon.image = [UIImage imageNamed:@"chat_icon_chat" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil];
        self.chatIcon = chatIcon;
    }
    return _chatIcon;
}
- (UILabel *)chatLabel {
    if (!_chatLabel) {
        UILabel *chatLabel = [UILabel labelWithTitle:@"聊天" color:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_regularFontWithSize:10]];
        self.chatLabel = chatLabel;
    }
    return _chatLabel;
}

@end
