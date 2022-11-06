//
//  QSCover.m
//  FBInsurenceBroker
//
//  Created by JYJ on 16/5/5.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "QSCover.h"

@implementation QSCover
+ (instancetype)show {
    // 创建蒙版对象
    QSCover *cover = [[QSCover alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    cover.backgroundColor = [UIColor blackColor];
    
    cover.alpha = 0.5;
    
    // 把蒙版对象添加主窗口
    [[UIWindow getKeyWindow] addSubview:cover];
    return cover;
}

+ (void)hide {
    for (UIView *childView in [UIWindow getKeyWindow].subviews) {
        if ([childView isKindOfClass:self]) {
            [childView removeFromSuperview];
        }
    }
}

@end
