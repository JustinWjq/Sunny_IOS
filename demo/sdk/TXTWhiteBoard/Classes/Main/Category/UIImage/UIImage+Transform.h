
//  UIImage+Transform.h
//  HeFeiBus
//
//  Created by 高明亮 on 2019/10/29.
//  Copyright © 2019 gaomingliang. All rights reserved.

#import <UIKit/UIKit.h>


@interface UIImage (Transform)
//颜色转图片
+ (instancetype)imageWithColor:(UIColor *)color;
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size;

//转换为指定大小图片
- (instancetype)transformToSize:(CGSize)size;
//以最大比例缩放图片到指定大小内
- (instancetype)transformToMaxSize:(CGSize)maxSize;

//截取部分图像
- (instancetype)getSubImage:(CGRect)rect;

//二维码
+ (instancetype)qrImageForData:(NSData *)data imageSize:(CGFloat)imagesize logoImageSize:(CGFloat)waterImagesize;
+ (instancetype)qrImageForString:(NSString *)string imageSize:(CGFloat)imagesize logoImageSize:(CGFloat)waterImagesize;
+ (instancetype)qrImageForHexString:(NSString *)hexString imageSize:(CGFloat)imagesize logoImageSize:(CGFloat)waterImagesize;

//渐变色
- (instancetype)initHorizontalGradientWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor;
- (instancetype)initVerticalGradientWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor;
- (instancetype)initSlashGradientWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor;
- (instancetype)initLinearGradientWithSize:(CGSize)size colors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
@end

