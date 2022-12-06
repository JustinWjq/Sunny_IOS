//
//  QSChatInputToolBar.h
//  62580
//
//  Created by QSZX001 on 2020/5/8.
//  Copyright © 2020 qscx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTTextView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QSChatInputToolBarDelegate <NSObject>

@optional

/// 点击发送按钮
- (void)chatInputToolBarDidClickSendBtn:(UIButton *)btn;
@end

@interface QSChatInputToolBar : UIView

/** delegate */
@property (nonatomic, weak) id<QSChatInputToolBarDelegate> delegate;
/** textView */
@property (nonatomic, strong) TXTTextView *textView;

/** sendBtn */
@property (nonatomic, strong) UIButton *sendBtn;
@end

NS_ASSUME_NONNULL_END
