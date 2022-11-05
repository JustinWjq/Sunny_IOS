//
//  TXTSmallChatView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/3.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXTSmallChatViewDelegate <NSObject>

@optional

/// 点击发送按钮
- (void)smallChatViewDidClickEmoji:(UIButton *)btn;
@end

@interface TXTSmallChatView : UIButton

/** delegate */
@property (nonatomic, weak) id<TXTSmallChatViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
