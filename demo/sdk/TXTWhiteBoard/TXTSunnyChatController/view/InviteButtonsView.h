//
//  InviteButtonsView.h
//  TICDemo
//
//  Created by 洪青文 on 2020/9/14.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol InviteButtonsViewDelegate <NSObject>

- (void)chooseWeChat;
- (void)chooseCloudUser;
- (void)chooseMessage;
- (void)cancle;

@end

@interface InviteButtonsView : UIView
@property (assign, nonatomic) id<InviteButtonsViewDelegate>delegate;
@property (strong, nonatomic) NSString *inviteNumber;
@property (strong, nonatomic) UILabel *inviteLabel1;
@end

NS_ASSUME_NONNULL_END
