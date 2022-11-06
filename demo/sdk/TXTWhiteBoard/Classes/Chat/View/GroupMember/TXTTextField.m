//
//  TXTTextField.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/5.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTTextField.h"

@implementation TXTTextField

- (void)layoutSubviews {
    [super layoutSubviews];
    UIButton *clearBtn = [self clearButtonInView:self];
    [clearBtn setImage:[UIImage imageNamed:@"member_icon_searchClear" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    // 在此处进行 clearBtn 样式的设置
//    NSLog(@"%@", clearBtn);
}

/// 递归遍历子控件，获取 clearButton
/// @param view  clearButton 对应的父 UITextField
- (UIButton *)clearButtonInView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[NSClassFromString(@"_UITextFieldClearButton") class]]) {
        return (UIButton *)view;
    }
    for (UIView *subView in view.subviews) {
        UIView *button = [self clearButtonInView:subView];
        if (button) {
            return (UIButton *)button;
        }
    }
    return nil;
}

@end
