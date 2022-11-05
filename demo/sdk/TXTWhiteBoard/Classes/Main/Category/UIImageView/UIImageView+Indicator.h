//
//  UIImageView+Indicator.h
//  HeFeiBus
//
//  Created by 高明亮 on 2019/10/29.
//  Copyright © 2019 gaomingliang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Indicator)
- (void)addIndicatorWithNumber:(NSInteger)number;
- (void)addIndicatorWithNumber:(NSInteger)number andEdgeInsets:(UIEdgeInsets)edgeInsets;
- (void)removeIndicator;
@end

NS_ASSUME_NONNULL_END
