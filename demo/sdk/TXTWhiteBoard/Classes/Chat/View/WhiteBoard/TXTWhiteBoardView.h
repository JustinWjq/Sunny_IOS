//
//  TXTWhiteBoardView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/8.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol TXTWhiteBoardViewDelegate <NSObject>

@optional

/// 点击关闭按钮
- (void)whiteBoardViewDidClickEndBtn:(UIButton *)endBtn;


@end

@interface TXTWhiteBoardView : UIView


/** delegate */
@property (nonatomic, weak) id<TXTWhiteBoardViewDelegate> delegate;

/// 是否横竖屏
- (void)updateUI:(BOOL)isPortrait;

/** isTelepromp */
@property (nonatomic, assign) BOOL isTelepromp;
/** teleprompStr */
@property (nonatomic, copy) NSString *teleprompStr;


/** isTelepromp */
@property (nonatomic, assign) BOOL isShowTXTWhiteBoardTool;

@end

NS_ASSUME_NONNULL_END
