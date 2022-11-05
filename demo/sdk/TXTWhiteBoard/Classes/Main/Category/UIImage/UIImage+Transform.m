//
//  UIImage+Transform.m
//  HeFeiBus
//
//  Created by 高明亮 on 2019/10/29.
//  Copyright © 2019 gaomingliang. All rights reserved.
//

#import "UIImage+Transform.h"

@implementation UIImage (Transform)
+ (instancetype)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (instancetype)transformToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (instancetype)transformToMaxSize:(CGSize)maxSize {
    CGFloat scaleX = maxSize.width / self.size.width;
    CGFloat scaleY = maxSize.height / self.size.height;
    CGFloat scale = scaleX > scaleY ? scaleY : scaleX;
    return [self transformToSize:CGSizeMake(scale * self.size.width, scale * self.size.height)];
}

- (instancetype)getSubImage:(CGRect)rect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (instancetype)qrImageForData:(NSData *)data imageSize:(CGFloat)imagesize logoImageSize:(CGFloat)waterImagesize {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"L" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大（L:7%,M:15%,Q:25%,H:30%)
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [[self alloc] createNonInterpolatedUIImageFormCIImage:outPutImage withSize:imagesize waterImageSize:waterImagesize];
}

+ (instancetype)qrImageForString:(NSString *)string imageSize:(CGFloat)imagesize logoImageSize:(CGFloat)waterImagesize {
    return [self qrImageForData:[string dataUsingEncoding:NSUTF8StringEncoding] imageSize:imagesize logoImageSize:waterImagesize];
}

+ (instancetype)qrImageForHexString:(NSString *)hexString imageSize:(CGFloat)imagesize logoImageSize:(CGFloat)waterImagesize {
    return [self qrImageForData:[self dataFromHexString:hexString] imageSize:imagesize logoImageSize:waterImagesize];
}

+ (NSData *)dataFromHexString:(NSString *)input {
    const char *chars = [input UTF8String];
    int i = 0;
    NSUInteger len = input.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

- (instancetype)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    //    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    //    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //    //logo图
    //    UIImage *waterimage = [UIImage imageNamed:@"icon-60"];
    //    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    //    [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
    //    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    return outputImage;
}

- (instancetype)initHorizontalGradientWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    return [self initLinearGradientWithSize:size colors:@[startColor, endColor] locations:@[@0.0, @1.0] startPoint:CGPointMake(0, size.height * 0.5) endPoint:CGPointMake(size.width, size.height * 0.5)];
}

- (instancetype)initVerticalGradientWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    return [self initLinearGradientWithSize:size colors:@[startColor, endColor] locations:@[@0.0, @1.0] startPoint:CGPointMake(size.width * 0.5, 0) endPoint:CGPointMake(size.width * 0.5, size.height)];
}

- (instancetype)initSlashGradientWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor{
    return [self initLinearGradientWithSize:size colors:@[startColor, endColor] locations:@[@0.0, @1.0] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(size.width , size.height)];
}

- (instancetype)initLinearGradientWithSize:(CGSize)size colors:(NSArray *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    if (!colors || colors.count == 0 || !locations || locations.count == 0 || colors.count != locations.count) {
        return nil;
    }
    //创建CGContextRef
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, CGRectMake(0, 0, size.width, size.height));
    //创建CGGradientRef
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    CFArrayRef colorArray = (__bridge CFArrayRef)cgColors;
    CGFloat *locationArray = (CGFloat *)malloc(sizeof(CGFloat) * locations.count);
    for (int i = 0; i < locations.count; i++) {
        locationArray[i] = locations[i].doubleValue;
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorArray, locationArray);
    CGColorSpaceRelease(colorSpace);
    //绘制渐变
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    free(locationArray);
    //从context中获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
