//
//  TXTTopButtons.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/11/21.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TXTTopButtonsDelegate <NSObject>

- (void)txSpeakBtnClick;
- (void)txSwitchBtnClick;
- (void)txQuitBtnClick;

@end

@interface TXTTopButtons : UIView
@property (nonatomic, weak) id<TXTTopButtonsDelegate>delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *speakBtn;
@property (nonatomic, strong) UIButton *switchBtn;
@property (nonatomic, strong) UIButton *quitBtn;

- (void)changeSpeakBtnStatus:(BOOL)status;
@end

NS_ASSUME_NONNULL_END
