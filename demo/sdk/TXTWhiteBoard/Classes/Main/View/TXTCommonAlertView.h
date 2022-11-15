//
//  TXTCommonAlertView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/7.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^btnCallBack)(NSString * _Nullable str);

@interface TXTCommonAlertView : UIView

/// 有打沟框的普通弹窗
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message leftBtnStr:(nullable NSString *)leftStr rightBtnStr:(nullable NSString *)rightStr leftColor:(nullable UIColor *)leftColor rightColor:(nullable UIColor *)rightColor;

/// 没有打沟框的普通弹窗
+ (instancetype)alertWithTitle:(NSString *)title titleColor:(nullable UIColor *)titleColor titleFont:(nullable UIFont *)titleFont leftBtnStr:(nullable NSString *)leftStr rightBtnStr:(nullable NSString *)rightStr leftColor:(nullable UIColor *)leftColor rightColor:(nullable UIColor *)rightColor;

/// 倒计时弹窗
+ (instancetype)countDownAlertWithTitle:(NSString *)title message:(NSString *)message rightBtnStr:(nullable NSString *)rightStr rightColor:(nullable UIColor *)rightColor time:(NSInteger)time;

+ (void)hide;

+ (instancetype)getAlertView;


@property (nonatomic, copy) dispatch_block_t cancleBlock;
@property (nonatomic, copy) dispatch_block_t sureBlock;

/** callBackBlock */
@property (nonatomic, copy) btnCallBack callBackBlock;
@end

NS_ASSUME_NONNULL_END
