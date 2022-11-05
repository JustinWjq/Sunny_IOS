//
//  TXTChatInputToolBar.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/3.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTChatInputToolBar.h"
#import "UITextView+Placeholder.h"

@interface  TXTChatInputToolBar () <UITextViewDelegate>
///** bgView */
//@property (nonatomic, strong) UIView *bgView;
///** divider */
//@property (nonatomic, strong) UIView *divider;
///** sendBtn */
//@property (nonatomic, strong) UIButton *sendBtn;
@end

@implementation TXTChatInputToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Setup UI
/**
 *  setupUI
 */
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.75];
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
//    [self insertSubview:self.bgView belowSubview:self.textView];
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(15);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.top.bottom.equalTo(self.textView);
//    }];
//
//    [self addSubview:self.divider];
//    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.bgView.mas_right).offset(62);
//        make.height.mas_equalTo(15);
//        make.width.mas_equalTo(1);
//        make.centerY.equalTo(self.bgView);
//    }];
//
//    [self addSubview:self.sendBtn];
//    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.divider.mas_right);
//        make.right.equalTo(self.bgView.mas_right);
//        make.top.bottom.equalTo(self.textView);
//    }];
}

#pragma mark - Public Method


#pragma mark - Event Responce
/// sendBtnClick
- (void)sendBtnClick {
    
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

#pragma mark - LazyLoad
- (UITextView *)textView {
    if (!_textView) {
        UITextView *textView = [[UITextView alloc] init];
        textView.delegate = self;
        textView.font = [UIFont qs_regularFontWithSize:15];
        textView.tintColor = [UIColor colorWithHexString:@"FFFFFF"];
        textView.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        textView.returnKeyType = UIReturnKeySend;
        textView.cornerRadius = 5;
//        textView.placeholder = @"快来说一说";
//        textView.placeholderColor = [UIColor colorWithHexString:@"999999"];
        [textView setContentInset:UIEdgeInsetsMake(-4.5, 0, -4.5, 0)];
        textView.backgroundColor = [UIColor colorWithHexString:@"6F6F6F" alpha:0.3];
        
        self.textView = textView;
    }
    return _textView;
}

//- (UIView *)divider {
//    if (!_divider) {
//        UIView *divider = [[UIView alloc] init];
//        divider.backgroundColor = [[UIColor colorWithHexString:@"E5E5E5"] colorWithAlphaComponent:1.0];
//        self.divider = divider;
//    }
//    return _divider;
//}
//
//- (UIButton *)sendBtn {
//    if (!_sendBtn) {
//        UIButton *sendBtn = [UIButton buttonWithTitle:@"发送" titleColor:[UIColor colorWithHexString:@"666666"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(sendBtnClick)];
//        [sendBtn setTitleColor:[UIColor colorWithHexString:@"E6B980"] forState:UIControlStateSelected];
//        self.sendBtn = sendBtn;
//    }
//    return _sendBtn;
//}
@end

