//
//  TXTMemberInfoView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/6.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXTMemberInfoView : UIView

+ (instancetype)alertWithUserModel:(TXTUserModel *)model;

+ (void)hide;

+ (instancetype)getAlertView;


@property (nonatomic, copy) dispatch_block_t cancleBlock;
@property (nonatomic, copy) dispatch_block_t sureBlock;
@end

NS_ASSUME_NONNULL_END
