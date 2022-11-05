//
//  JCHATShowTimeCell.h
//  JPush IM
//
//  Created by Apple on 15/1/13.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSIMMessageModel.h"

@interface QSShowTimeCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong, nonatomic) QSIMMessageModel *model;


@property (strong, nonatomic) UILabel *messageTimeLabel;
@end
