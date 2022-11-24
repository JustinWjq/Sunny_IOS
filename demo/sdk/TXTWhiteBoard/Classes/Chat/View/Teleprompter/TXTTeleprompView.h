//
//  TXTTeleprompView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/7.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXTTeleprompViewDelegate <NSObject>

@optional

/// 点击字体
- (void)teleprompViewDidClickSwitchView:(UISwitch *)switchView;
@end

@interface TXTTeleprompView : UIView
/** switchView */
@property (nonatomic, strong) UISwitch *switchView;
/** delegate */
@property (nonatomic, weak) id<TXTTeleprompViewDelegate> delegate;

/// 更新界面按钮是否打开
- (void)upDateUIWithSwithch:(BOOL)isOn;
/// 是否横竖屏
- (void)updateUI:(BOOL)isPortrait;

/** teleprompStr */
@property (nonatomic, copy) NSString *teleprompStr;
@end

NS_ASSUME_NONNULL_END
