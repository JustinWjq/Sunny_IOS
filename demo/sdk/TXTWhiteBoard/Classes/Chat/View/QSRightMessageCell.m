//
//  QSRightMessageCell.m
//  62580
//
//  Created by QSZX001 on 2020/5/13.
//  Copyright © 2020 qscx. All rights reserved.
//

#import "QSRightMessageCell.h"


@implementation QSRightMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"QSRightMessageCell";
    QSRightMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[QSRightMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageStateChange:) name:@"kMessageStateChange" object:nil];
    [self setLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark ---- 普通方法
- (void)setLayout {
    
    //  _userIcon
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(11);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(37);
//        make.bottom.lessThanOrEqualTo(@(-11));
    }];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.userIcon);
    }];
    
    //  _contentview
    [self.contentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userIcon.mas_right).offset(0);
        make.top.equalTo(self.userIcon.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(@(375 - 120 - 15));
        make.bottom.lessThanOrEqualTo(@(-10)).priorityHigh();
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userIcon.mas_left).offset(-10);
        make.centerY.equalTo(self.userIcon.mas_centerY);
    }];
}

- (void)refreshTextLayout {
    self.contentview.backgroundColor = [UIColor colorWithHexString:@"E6B980"];
    self.textContent.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    //  _textContent
    [self.textContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-7);
    }];
}

///*
// 发送内容已读
// */
//- (void)sendContentHaveRead {
//    MJWeakSelf
//    // 设置读取信息
//    [weakSelf.messageData.message setMessageHaveRead:^(id resultObject, NSError *error) {
//        if (!error) {
//            [weakSelf refreshIsRead];
//        }
//    }];
//}
//
///*
// 刷新内容已读未读
// */
//- (void)refreshIsRead {
//    self.messageStatus.isReadText = self.messageData.message.isReceived ? NO : self.messageData.message.getMessageUnreadCount == 0 ? YES : NO;
//}

#pragma mark ---- 点击事件

#pragma mark ---- set/get
#pragma mark ---- 代理/通知
///*
// 消息状态变更通知
// */
//- (void)messageStateChange:(NSNotification *)notification {
//    BOOL isCurrentMessage = [self.messageData.message isEqualToMessage:notification.object];
//    if (isCurrentMessage) {
////        self.messageData.message = notification.object;
//        JMSGMessage *message = notification.object;
//        QSIMMessageModel *model  = [[QSIMMessageModel alloc] init];
//        model.message = message;
//        model.messageTime = message.timestamp;
//        self.messageData = model;
//    }
//}
#pragma mark ---- 懒加载

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

- (void)drawRect:(CGRect)rect {
  // Drawing code
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentview.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentview.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentview.layer.mask = maskLayer;

}

@end

