//
//  TXTChatInputToolBar.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/3.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXTChatInputToolBarDelegate <NSObject>

@optional

/// 点击发送按钮
- (void)chatInputToolBarDidClickSendBtn:(UIButton *)btn;
@end


@interface TXTChatInputToolBar : UIView

/** textView */
@property (nonatomic, strong) UITextView *textView;


/** delegate */
@property (nonatomic, weak) id<TXTChatInputToolBarDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
