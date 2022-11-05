//
//  UIImageView+Indicator.m
//  HeFeiBus
//
//  Created by 高明亮 on 2019/10/29.
//  Copyright © 2019 gaomingliang. All rights reserved.
//

#import "UIImageView+Indicator.h"

@implementation UIImageView (Indicator)

- (void)addIndicatorWithNumber:(NSInteger)number {
    [self addIndicatorWithNumber:number andEdgeInsets:UIEdgeInsetsZero];
}

- (void)addIndicatorWithNumber:(NSInteger)number andEdgeInsets:(UIEdgeInsets)edgeInsets {
    [self removeIndicator];
    UILabel *label = [[UILabel alloc]init];
    CGRect frame = CGRectZero;
    frame.origin = CGPointMake(self.bounds.size.width * 0.5 - 5 + edgeInsets.left - edgeInsets.right, -5 + edgeInsets.top - edgeInsets.bottom);
    frame.size = CGSizeMake(10, 10);
    label.frame = frame;
    
    label.backgroundColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%ld",(long)number];
    label.font = [UIFont boldSystemFontOfSize:8];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByClipping;
    label.textColor = [UIColor whiteColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = label.frame.size.height / 2;
    label.tag = 2015;
    [self addSubview:label];
}

- (void)removeIndicator {
    [[self viewWithTag:2015] removeFromSuperview];
}

@end
