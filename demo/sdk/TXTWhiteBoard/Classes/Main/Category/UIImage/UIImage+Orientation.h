//
//  UIImage+Orientation.h
//  wuhanBus
//
//  Created by chefeng on 2018/9/4.
//  Copyright © 2018年 Yosing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)

- (UIImage *)fixOrientation;

+(UIImage *)imageWithLineWithImageView:(UIImageView *)imageView size:(CGSize)size;

@end
