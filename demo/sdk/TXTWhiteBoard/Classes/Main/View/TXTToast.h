//
//  TXTToast.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/10.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TXTToastType) {
    TXTToastTypeCheck,
    TXTToastTypeWarn
};

@interface TXTToast : UIView

/// 普通toast
+ (instancetype)toastWithTitle:(NSString *)title;

/// 普通toast
+ (instancetype)toastWithTitle:(NSString *)title type:(TXTToastType)type;


+ (void)hide;

+ (instancetype)getAlertView;

@end

NS_ASSUME_NONNULL_END
