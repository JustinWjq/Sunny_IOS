//
//  TXTGroupMemberViewController.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/5.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTGroupMemberViewController : UIViewController

// 成员管理
@property (strong, nonatomic) NSMutableArray *manageMembersArr;

@property (nonatomic, copy) dispatch_block_t closeBlock;
@end

NS_ASSUME_NONNULL_END
