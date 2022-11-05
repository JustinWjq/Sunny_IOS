//
//  QSMessageStatusView.h
//  62580
//
//  Created by QSZX001 on 2020/5/13.
//  Copyright © 2020 qscx. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QSMessageStatusView;



NS_ASSUME_NONNULL_BEGIN

@protocol QSMessageStatusViewDelegate <NSObject>

/*
 消息发送失败的红色按钮点击回调
 */
@optional

- (void)messageStatusViewClickError:(QSMessageStatusView *) statusView;

@end

@interface QSMessageStatusView : UIView

@property (nonatomic,weak) id<QSMessageStatusViewDelegate> delegate;

@property (nonatomic,assign) JMSGMessageStatus sendStatus;

@property (nonatomic,assign) BOOL isReadText;

@property (nonatomic,assign) BOOL isReadVoice; // 接收到的语音是否已读取

/** isLeft */
@property (nonatomic, assign) BOOL isLeft;

@end

NS_ASSUME_NONNULL_END
