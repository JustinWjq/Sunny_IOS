//
//  TXTSmallMessageCell.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/4.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTSmallMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** text */
@property (nonatomic, copy) NSString *text;
@end

NS_ASSUME_NONNULL_END
