//
//  TXTEmojiView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/4.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXTEmojiViewDelegate <NSObject>

@optional

/// 点击发送按钮
- (void)emojiViewDidClickEmoji:(NSString *)emoji;
@end


@interface TXTEmojiView : UIButton

/** delegate */
@property (nonatomic, weak) id<TXTEmojiViewDelegate> delegate;


/**
 *  显示
 */
- (void)showFromView:(UIView *)fromView;

- (void)updateUI;

/**
 *  销毁
 */
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
