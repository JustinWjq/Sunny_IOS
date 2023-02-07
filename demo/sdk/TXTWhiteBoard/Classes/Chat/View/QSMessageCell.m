//
//  QSMessageCell.m
//  62580
//
//  Created by QSZX001 on 2020/5/13.
//  Copyright © 2020 qscx. All rights reserved.
//

#import "QSMessageCell.h"
#import "TXTCommon.h"

@interface QSMessageCell ()


/** isRead之前读过 */
@property (nonatomic, assign) BOOL isRead;
@end

@implementation QSMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"QSMessageCell";
    QSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[QSMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ---- 生命周期

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}

- (void) addSubViews {
    _timeLable = [[UILabel alloc] init];
    _timeLable.textAlignment = NSTextAlignmentCenter;
    _timeLable.textColor = [UIColor colorWithHexString:@"999999"];
    _timeLable.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLable];
    
    _userIcon = [[UIImageView alloc] init];
    _userIcon.layer.cornerRadius = 37 / 2;
    _userIcon.layer.masksToBounds = YES;
    _userIcon.backgroundColor = [UIColor colorWithHexString:@"E6B980"];
    [self.contentView addSubview:_userIcon];
    
    self.iconLabel = [UILabel labelWithTitle:@"" color:[UIColor colorWithHexString:@"FFFFFF"] font:[UIFont qs_regularFontWithSize:12]];
    [_userIcon addSubview:self.iconLabel];
    
    _contentview = [[QSIMBubbleView alloc] init];
    _contentview.backgroundColor = [UIColor clearColor];
//    _contentview.layer.cornerRadius = 6;
//    _contentview.layer.masksToBounds = YES;
    UITapGestureRecognizer *contentviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContentView)];
    [_contentview addGestureRecognizer:contentviewTap];
    [self.contentView addSubview:_contentview];
//    _contentview.layer.shadowColor = [UIColor colorWithHexString:@"B9B9C0" alpha:0.16].CGColor;//shadowColor阴影颜色
//    _contentview.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移
//    _contentview.layer.shadowOpacity = 1; //阴影透明度，默认0
//    _contentview.layer.shadowRadius = 10; //阴影半径，默认3
    
    _textContent = [[UILabel alloc] init];
    _textContent.text = @"测试文案测试";
    _textContent.font = [UIFont systemFontOfSize:14];
    _textContent.textColor = [UIColor colorWithHexString:@"2C364E"];
    _textContent.numberOfLines = 0;

    self.userNameLabel = [UILabel labelWithTitle:@"" color:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_regularFontWithSize:15]];
    [self.contentView addSubview:self.userNameLabel];
   
}

/*
 开启语音动画
 */
- (void)turnOnVoiceAnimation{
    //开始动画
    [self.voiceIcon startAnimating];
}

/*
 关闭语音动画
 */
- (void)turnOffVoiceAnimation{
    //结束动画
    [self.voiceIcon stopAnimating];
}

#pragma mark ---- 普通方法
#pragma mark ---- 点击事件
/// clickContentView
- (void)clickContentView {
    
}


#pragma mark ---- set/get
- (void)setMessageType:(NSInteger)messageType {
    _messageType = messageType;
    [_textContent removeFromSuperview];

    switch (_messageType) {
        case 0: // 刷新文本内容布局
            [self sendContentHaveRead];
            _contentview.bgImageView.hidden = NO;
            [_contentview addSubview:_textContent];
            [self refreshTextLayout];
            [self.contentview setNeedsDisplay];
            break;
        case 1: // 刷新图片内容布局
            [self sendContentHaveRead];
            _contentview.bgImageView.hidden = YES;
            [self.contentview addSubview:_imageContent];
            [self.contentview addSubview:self.percentLabel];
            [self refreshImageLayout];
            [self.contentview setNeedsDisplay];
            break;
    }
}



- (void)setMessageData:(QSIMMessageModel *)messageData {
    _messageData = messageData;
//  _messageStatus.sendStatus = messageData.message.status;
    [self refreshIsRead];
   
    QSLog(@"%@- %@", messageData.message.nickName, messageData.message.faceURL);
//    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:messageData.message.faceURL] placeholderImage:[UIImage imageNamed:@"HeadPortrait_s" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil]];
//    QSIMMessageModel
////    JMSGTextContent *textContent = (JMSGTextContent *)messageData.message.content;
//    self.textContent.text = textContent.text;
    if (messageData.message.elemType == V2TIM_ELEM_TYPE_TEXT) {
        
        NSString *jsonStr = messageData.message.textElem.text;
        NSDictionary *dict = [[TXTCommon sharedInstance] dictionaryWithJsonString:jsonStr];
        self.textContent.text = dict[@"content"];
        NSString *userName = dict[@"userName"];
        if (userName.length > 2) {
//            self.iconLabel.text = [userName substringFromIndex:userName.length - 2];
            self.iconLabel.text = [NSString subStrWithStr:userName fromIndex:userName.length - 2];
        } else {
            self.iconLabel.text = userName;
        }
        
        
        self.userNameLabel.text = userName;
        if (self.userNameLabel.text.length > 10) {
//            userName = [NSString stringWithFormat:@"%@...", [self.userNameLabel.text substringToIndex:10]];
            userName = [NSString stringWithFormat:@"%@...", [NSString subStringWithEmoji:self.userNameLabel.text limitLength:10]];
        }
        self.userNameLabel.text = userName;
        self.contentview.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        self.messageType = 0;
    }
}


- (NSString *)getTimeStr:(NSInteger)duration {
    NSString *time;
    if (duration >= 60 * 60) {
        time = [NSString stringWithFormat:@"%ld:%02ld:%02ld", duration / 60 / 60, duration / 60 % 60, duration % 60];
    } else {
        time = [NSString stringWithFormat:@"%ld:%02ld", duration / 60, duration % 60];
    }
    return time;
}



#pragma mark ---- 代理
///*
// 消息发送失败的红色按钮点击回调
// */
//- (void)messageStatusViewClickError:(QSMessageStatusView *)statusView {
//    if ([self.delegate respondsToSelector:@selector(imMessageCellClickError:)]) {
//        [self.delegate imMessageCellClickError:self];
//    }
//}
//
///*!
// * @abstract 监听消息回执状态变更事件
// */
//- (void)onReceiveMessageReceiptStatusChangeEvent:(JMSGMessageReceiptStatusChangeEvent *)receiptEvent {
//    for (int i = 0; i < receiptEvent.messages.count; i ++) {
//        JMSGMessage *message = receiptEvent.messages[i];
//        if ([self.messageData.message isEqualToMessage:message]) {
//            self.messageData.message = message;
//            [self refreshIsRead];
//        }
//    }
//}

#pragma mark ---- 懒加载


#pragma mark ----- 空实现，子类来实现
/*
 更新文本布局
 */
- (void)refreshTextLayout{}
/*
 更新语音布局
 */
- (void)refreshVoiceLayout{}
/*
 更新图片布局
 */
- (void)refreshImageLayout{}
/*
 更新视频布局
 */
- (void)refreshVideoLayout{}
/*
 更新位置信息布局
 */
- (void)refreshLocationLayout{}
/*
 发送内容已读
 */
- (void)sendContentHaveRead{}
/*
 刷新内容已读未读
 */
- (void)refreshIsRead{}

@end

