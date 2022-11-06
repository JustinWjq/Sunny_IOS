//
//  TXTSearchMemberCell.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/5.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTUserModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TXTSearchMemberCell;
@protocol TXTSearchMemberCellDelegate <NSObject>

@optional

/// 点击声音
- (void)searchMemberCell:(TXTSearchMemberCell *)searchMemberCell didClickVoiceBtn:(UIButton *)voiceBtn;

/// 点击视频
- (void)searchMemberCell:(TXTSearchMemberCell *)searchMemberCell didClickVideoBtn:(UIButton *)videoBtn;
@end

@interface TXTSearchMemberCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** model */
@property (nonatomic, strong) TXTUserModel *model;

/** keyWord */
@property (nonatomic, copy) NSString *keyWord;

/** delegate */
@property (nonatomic, weak) id<TXTSearchMemberCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
