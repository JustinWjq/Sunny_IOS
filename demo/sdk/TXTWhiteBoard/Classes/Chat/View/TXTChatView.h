//
//  TXTChatView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/1.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXTChatViewDelegate <NSObject>

@optional

/// 点击关闭
- (void)chatViewDidClickCloseBtn:(UIButton *)closeBtn;

@end

@interface TXTChatView : UIView

/** delegate */
@property (nonatomic, weak) id<TXTChatViewDelegate> delegate;


- (void)updateUI:(BOOL)isPortrait;
@end

NS_ASSUME_NONNULL_END
