//
//  UIWindow+UIWindow_Extesion.h
//  62580
//
//  Created by JYJ on 2020/4/15.
//  Copyright © 2020 qscx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (Extesion)
+ (UIWindow *)getKeyWindow;

/// 横向
+ (BOOL)isLandscape;
@end

NS_ASSUME_NONNULL_END
