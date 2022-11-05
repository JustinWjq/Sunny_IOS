//
//  UITextField+placeholderColor.h
//  TheGreatWall
//
//  Created by hztuen on 17/1/12.
//  Copyright © 2017年 hztuen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (placeholderColor)

- (void)setPlaceholder:(NSString *)placeholder color:(UIColor *)placeholderColor;  //设置提示文字颜色 placeholder.length>0 不然无效

- (UIColor *)placeholderColor;

@end
