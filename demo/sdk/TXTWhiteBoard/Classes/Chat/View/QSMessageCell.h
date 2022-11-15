//
//  QSMessageCell.h
//  62580
//
//  Created by QSZX001 on 2020/5/13.
//  Copyright © 2020 qscx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSIMMessageModel.h"
#import "QSIMBubbleView.h"




NS_ASSUME_NONNULL_BEGIN

@class QSMessageCell;
@protocol QSMessageCellDeleagte <NSObject>
@optional

/*
 发送失败后点击的按钮回调
 */
- (void)imMessageCellClickError:(QSMessageCell *)cell;

@end


@interface QSMessageCell : UITableViewCell

@property (nonatomic,weak) id<QSMessageCellDeleagte> delegate;

@property (nonatomic,strong) QSIMMessageModel *messageData; // 信息数据

@property (nonatomic,strong) UILabel *timeLable; // 时间

@property (nonatomic,strong) UIImageView *userIcon; // 用户图片
@property (nonatomic,strong) UILabel *userNameLabel; // 用户昵称
/** iconLabel */
@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic,strong) QSIMBubbleView *contentview; // 内容视图

@property (nonatomic,strong) UILabel *textContent; // 内容文本

@property (nonatomic,strong) UILabel *voiceTimeLabel; // 语音时间

@property (nonatomic,strong) UIImageView *voiceIcon; // 语音播放小图标

@property (nonatomic,strong) UIImageView *imageContent; // 图片内容
@property (nonatomic,strong) UILabel *percentLabel; // 图片内容

@property (nonatomic,strong) UIImageView *videoContent; // 视频图片内容
@property (nonatomic,strong) UIButton *videoBtn; // 视频按钮
@property (nonatomic,strong) UILabel *videoLengthLabel; // 视频大小
@property (nonatomic,strong) UILabel *videoTimeLabel; // 视频时长

//@property (nonatomic,strong) CYLocationContentView *locationContent; // 位置内容

//@property (nonatomic,strong) QSMessageStatusView *messageStatus; // 阅读状态

@property (nonatomic,assign) CGSize imageSize; // 图片的大小 如果要设置图片的大小必须要在 messageType 之前设置不然无效

@property (nonatomic,assign) NSInteger voiceDuration; // 语音的持续时间需要提前设置，不然不能根据时间设置长度

@property (nonatomic,assign) NSInteger messageType; // 消息类型 0 文本消息  1 图片消息 2 语音消息 3 位置消息 4视频



+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)playVoice;


//voice
@property(assign, nonatomic)BOOL continuePlayer;
/*
 开启语音动画
 */
- (void)turnOnVoiceAnimation;
/*
 关闭语音动画
 */
- (void)turnOffVoiceAnimation;
/*
 更新文本布局
 */
- (void)refreshTextLayout;
/*
 更新语音布局
 */
- (void)refreshVoiceLayout;
/*
 更新图片布局
 */
- (void)refreshImageLayout;
/*
 更新视频布局
 */
- (void)refreshVideoLayout;
/*
 更新位置信息布局
 */
- (void)refreshLocationLayout;
/*
 发送内容已读
 */
- (void)sendContentHaveRead;

/*
 刷新内容已读未读
 */
- (void)refreshIsRead;

@end

NS_ASSUME_NONNULL_END
