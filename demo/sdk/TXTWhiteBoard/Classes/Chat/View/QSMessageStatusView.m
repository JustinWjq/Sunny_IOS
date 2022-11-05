//
//  QSMessageStatusView.m
//  62580
//
//  Created by QSZX001 on 2020/5/13.
//  Copyright © 2020 qscx. All rights reserved.
//

#import "QSMessageStatusView.h"

@interface QSMessageStatusView ()

@property (nonatomic,strong) UILabel *readStatus;

@property (nonatomic,strong) UIActivityIndicatorView * activityIndicator;; // 发送状态

@property (nonatomic,strong) UIButton *sendError; // 发送失败

@property (nonatomic,strong) UIView *voiceReadStataus; // 接收的语音读取状态

@end

@implementation QSMessageStatusView

#pragma mark ---- 生命周期
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubViews];
        [self setLauout];
    }
    return self;
}

#pragma mark ---- 普通方法

- (void) addSubViews
{
    _readStatus = [[UILabel alloc] init];
    _readStatus.text = @"未读";
    _readStatus.font = [UIFont systemFontOfSize:12];
    _readStatus.textColor = [UIColor colorWithHexString:@"9BA4B4"];
    _readStatus.textAlignment = NSTextAlignmentCenter;
    _readStatus.hidden = YES;
    [self addSubview:_readStatus];
    
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    _activityIndicator.color =  [UIColor colorWithHexString:@"999999"];
    _activityIndicator.backgroundColor = [UIColor clearColor];
    [_activityIndicator stopAnimating];
    [self addSubview:_activityIndicator];
    
    _sendError = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_sendError setBackgroundImage:[UIImage imageNamed:@"icon_message_cell_error"] forState:(UIControlStateNormal)];
    [_sendError addTarget:self action:@selector(clickErrroBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    _sendError.hidden = YES;
    [self addSubview:_sendError];
    
    _voiceReadStataus = [[UIView alloc] init];
    _voiceReadStataus.hidden = YES;
    _voiceReadStataus.backgroundColor = [UIColor colorWithHexString:@"E55953"];
    _voiceReadStataus.layer.cornerRadius = 4;
    _voiceReadStataus.layer.masksToBounds = YES;
    [self addSubview:_voiceReadStataus];


}

- (void)setLauout {
//    _readStatus
    [_readStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
//    _activityIndicator
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
//    _sendError
    [_sendError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(5);
    }];
    
//    _voiceReadStataus
    [_voiceReadStataus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(11);
    }];
}


- (void)setIsLeft:(BOOL)isLeft {
    _isLeft = isLeft;
    if (isLeft) {
        _readStatus.textAlignment = NSTextAlignmentLeft;
        [_activityIndicator mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
        }];
        [_sendError mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
        }];
        [_voiceReadStataus mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(11);
        }];
        
    } else {
        _readStatus.textAlignment = NSTextAlignmentRight;
        [_activityIndicator mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
        }];
        [_sendError mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5 + 15);
        }];
        [_voiceReadStataus mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(11 + 15);
        }];
    }
}




- (void)refreshUI {
    switch (self.sendStatus) {
        case kJMSGMessageStatusSendDraft:  /// 发送息创建时的初始状态
            self.readStatus.hidden = YES;
            [self.activityIndicator startAnimating];
            self.sendError.hidden  = YES;
            break;
        case kJMSGMessageStatusSending: /// 消息正在发送过程中. UI 一般显示进度条
            self.readStatus.hidden = YES;
            [self.activityIndicator startAnimating];
            self.sendError.hidden  = YES;
            break;
        case kJMSGMessageStatusSendUploadFailed: /// 媒体类消息文件上传失败
            self.readStatus.hidden = YES;
            [self.activityIndicator stopAnimating];
            self.sendError.hidden  = NO;
            break;
        case kJMSGMessageStatusSendUploadSucceed:  /// 媒体类消息文件上传成功
            self.readStatus.hidden = YES;
            [self.activityIndicator stopAnimating];
            self.sendError.hidden  = YES;
            break;
        case kJMSGMessageStatusSendFailed: /// 消息发送失败
            self.readStatus.hidden = YES;
            [self.activityIndicator stopAnimating];
            self.sendError.hidden  = NO;
            break;
        case kJMSGMessageStatusSendSucceed: /// 消息发送成功
            self.readStatus.hidden = NO;
            [self.activityIndicator stopAnimating];
            self.sendError.hidden  = YES;
            break;
        case kJMSGMessageStatusReceiving: /// 接收中的消息(还在处理)
            break;
        case kJMSGMessageStatusReceiveDownloadFailed:  /// 接收消息时自动下载媒体失败
            break;
        case kJMSGMessageStatusReceiveSucceed: /// 接收消息成功
            self.readStatus.hidden = NO;
            [self.activityIndicator stopAnimating];
            self.sendError.hidden  = YES;
            break;
    }
}

#pragma mark ---- 点击事件
- (void)clickErrroBtn:(UIButton *) sender {
    if ([self.delegate respondsToSelector:@selector(messageStatusViewClickError:)]) {
        [self.delegate messageStatusViewClickError:self];
    }
}

#pragma mark ---- set/get
- (void)setSendStatus:(JMSGMessageStatus)sendStatus {
    _sendStatus = sendStatus;
    [self refreshUI];
}

- (void)setIsReadText:(BOOL)isReadText {
    _isReadText = isReadText;
    if (_sendStatus == kJMSGMessageStatusSendSucceed ||
        _sendStatus == kJMSGMessageStatusReceiveSucceed) {
        _readStatus.text = _isReadText ? @"已读" : @"未读";
        _readStatus.textColor = _isReadText ? [UIColor colorWithHexString:@"9BA4B4"] : [UIColor colorWithHexString:@"4F6DB8"];
    }
}

- (void)setIsReadVoice:(BOOL)isReadVoice {
    _isReadVoice = isReadVoice;
    if (!_isReadVoice) { // 如果是未读显示语音未读消息
        self.hidden = NO;
        _readStatus.hidden = YES;
        _sendError.hidden = YES;
        _activityIndicator.hidden = YES;
        _voiceReadStataus.hidden = NO;
    } else {
        self.hidden = YES;
    }
}


#pragma mark ---- 代理
#pragma mark ---- 懒加载

@end
