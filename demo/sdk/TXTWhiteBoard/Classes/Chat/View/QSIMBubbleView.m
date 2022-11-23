//
//  QSIMBubbleView.m
//  62580
//
//  Created by QSZX001 on 2020/5/13.
//  Copyright © 2020 qscx. All rights reserved.
//

#import "QSIMBubbleView.h"

@implementation QSIMBubbleView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    _bgImageView = [[UIImageView alloc] init];
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)drawRect:(CGRect)rect {
  // Drawing code
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    if (self.isLeft) {
       corners = UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
