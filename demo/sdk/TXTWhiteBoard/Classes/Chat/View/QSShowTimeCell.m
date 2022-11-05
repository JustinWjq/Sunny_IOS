//
//  QSShowTimeCell.m
//  JPush IM
//
//  Created by Apple on 15/1/13.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "QSShowTimeCell.h"


@interface QSShowTimeCell ()


@end

@implementation QSShowTimeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"QSShowTimeCell";
    QSShowTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[QSShowTimeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor colorWithHexString:@"F8F9FB"];
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // 初始化操作
    [self setupSubviews];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化操作
        [self setupSubviews];
        
    }
    return self;
}

- (void)setupSubviews {

  [self.contentView addSubview:self.messageTimeLabel];
  self.messageTimeLabel.lineBreakMode = NSLineBreakByCharWrapping;
  self.messageTimeLabel.numberOfLines = 0;
  
  [self.messageTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView.mas_left).offset(15);
    make.right.equalTo(self.contentView.mas_right).offset(-15);
    make.top.equalTo(self.contentView.mas_top).offset(10);
    make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
  }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setModel:(QSIMMessageModel *)model {
    _model = model;
//  self.messageTimeLabel.text= [NSString stringWithFormat:@"%@",self.model.messageTime];
    self.messageTimeLabel.text= model.timeStr;
//    [self.messageTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(15);
//        make.right.equalTo(self.contentView.mas_right).offset(-15);
//        make.top.equalTo(self.contentView.mas_top).offset(10);
//        make.height.mas_equalTo(30);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
//    }];
}

- (UILabel *)messageTimeLabel {
  if (!_messageTimeLabel) {
    /** label */
    UILabel *messageTimeLabel = [UILabel labelWithTitle:@"" color:[UIColor colorWithHexString:@"999999"] font:[UIFont qs_regularFontWithSize:14]];
    messageTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.messageTimeLabel = messageTimeLabel;
  }
  return _messageTimeLabel;
}


@end
