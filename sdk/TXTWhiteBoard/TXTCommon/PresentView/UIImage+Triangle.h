//
//  UIImage+Triangle.h
//  QFun
//
//  Created by 王敏青 on 2020/7/13.
//  Copyright © 2020 ndm. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage (Triangle)

+ (UIImage *)triangleImageWithSize:(CGSize)size tintColor:(UIColor *)tintColor;
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end

