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

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message leftBtnStr:(nullable NSString *)leftStr rightBtnStr:(nullable NSString *)rightStr leftColor:(nullable UIColor *)leftColor rightColor:(nullable UIColor *)rightColor;

+ (instancetype)alertWithTitle:(NSString *)title titleColor:(nullable UIColor *)titleColor titleFont:(UIFont *)titleFont leftBtnStr:(nullable NSString *)leftStr rightBtnStr:(nullable NSString *)rightStr leftColor:(nullable UIColor *)leftColor rightColor:(nullable UIColor *)rightColor;


+ (void)hide;

+ (instancetype)getAlertView;


@property (nonatomic, copy) dispatch_block_t cancleBlock;
@property (nonatomic, copy) dispatch_block_t sureBlock;

/** callBackBlock */
@property (nonatomic, copy) btnCallBack callBackBlock;
@end

NS_ASSUME_NONNULL_END
