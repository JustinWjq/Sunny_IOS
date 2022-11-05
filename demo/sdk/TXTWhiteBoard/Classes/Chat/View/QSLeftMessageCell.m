//
//  QSLeftMessageCell.m
//  62580
//
//  Created by QSZX001 on 2020/5/13.
//  Copyright © 2020 qscx. All rights reserved.
//

#import "QSLeftMessageCell.h"

@implementation QSLeftMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"QSLeftMessageCell";
    QSLeftMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[QSLeftMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"F8F9FB"];
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
    [self setLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ---- 普通方法
- (void)setLayout {

//    _timeLable
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
    }];
    
//    _userIcon
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(self.timeLable.mas_bottom).offset(11);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(37);
//        make.bottom.lessThanOrEqualTo(@(-11));
    }];
    
//    _contentview
    [self.contentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_left).offset(0);
        make.top.equalTo(self.userIcon.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(@(375 - 120 - 15));
        make.bottom.lessThanOrEqualTo(@(-10));
    }];
    

}

- (void)refreshTextLayout {
//    _textContent
    [self.textContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-7);
    }];
}



/*
 刷新内容已读未读
 */
- (void)refreshIsRead {
//    if (self.messageData.message.contentType == kJMSGContentTypeVoice) {
//        self.messageStatus.isReadVoice =  self.messageData.message.isHaveRead;
//    } else {
//        self.messageStatus.isReadVoice = YES;
//    }
}

/*
 发送内容已读
 */
- (void)sendContentHaveRead {
//    MJWeakSelf
//    // 设置读取信息
//    [self.messageData.message setMessageHaveRead:^(id resultObject, NSError *error) {
//        if (!error) {
//            [weakSelf refreshIsRead];
//        }
//    }];
}


#pragma mark ---- 点击事件

#pragma mark ---- set/get
#pragma mark ---- 代理
#pragma mark ---- 懒加载

@end
