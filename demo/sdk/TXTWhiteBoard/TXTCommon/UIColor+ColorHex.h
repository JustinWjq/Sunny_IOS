//
//  UIColor+ColorHex.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2021/3/11.
//  Copyright © 2021 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ColorHex)
+ (UIColor *)colorWithHexString:(NSString *)color;
 
//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
