//
//  TXTSmallChatView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/3.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTSmallChatView.h"

@interface TXTSmallChatView ()
/** emojiBtn */
@property (nonatomic, strong) UIButton *emojiBtn;
/** emojiIcon */
@property (nonatomic, strong) UIImageView *emojiIcon;
/** divider */
@property (nonatomic, strong) UIView *divider;
/** msgLabel */
@property (nonatomic, strong) UILabel *msgLabel;

@end

@implementation TXTSmallChatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
//        [self addTarget:self action:@selector(tapClick)];
    }
    return self;
}
///// tapClick
//- (void)tapClick {
//    if (self.showKeyBoardBlock) {
//        self.showKeyBoardBlock();
//    }
//}
/// initUI
- (void)initUI {
    self.backgroundColor = [UIColor colorWithHexString:@"282A2C"];
    [self addSubview:self.emojiIcon];
    [self.emojiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.left.mas_equalTo(9);
        make.centerY.equalTo(self.mas_centerY);
    }];

    [self addSubview:self.divider];
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(34);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self addSubview:self.emojiBtn];
    [self.emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self.divider.mas_left);
    }];

    [self addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(44);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

/// emojiBtnClick
- (void)emojiBtnClick {
    if ([self.delegate respondsToSelector:@selector(smallChatViewDidClickEmoji:)]) {
        [self.delegate smallChatViewDidClickEmoji:self.emojiBtn];
    }
}

- (UIButton *)emojiBtn {
    if (!_emojiBtn) {
        UIButton *emojiBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(emojiBtnClick)];
        self.emojiBtn = emojiBtn;
    }
    return _emojiBtn;
}

- (UIImageView *)emojiIcon {
    if (!_emojiIcon) {
        UIImageView *emojiIcon = [[UIImageView alloc] init];
        emojiIcon.image = [UIImage imageNamed:@"chat_icon_samllFace" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil];
        self.emojiIcon = emojiIcon;
    }
    return _emojiIcon;
}

- (UIView *)divider {
    if (!_divider) {
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = [[UIColor colorWithHexString:@"4B4C4E"] colorWithAlphaComponent:0.8];
        self.divider = divider;
    }
    return _divider;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        UILabel *msgLabel = [UILabel labelWithTitle:@"快来说一说…" color:[UIColor colorWithHexString:@"DADADA"] font:[UIFont qs_regularFontWithSize:14]];
        self.msgLabel = msgLabel;
    }
    return _msgLabel;
}

@end
