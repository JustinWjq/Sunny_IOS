//
//  UIButton+Extension.h
//  Innersect
//
//  Created by ndm on 2019/7/22.
//  Copyright © 2019 innersect. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ButtonPosition) {
    ButtonPositionWithLeftImageRightTitle = 0,//default
    ButtonPositionWithLeftTitleRightImage = 1,
    ButtonPositionWithTopImageBottomTitle = 2,
    ButtonPositionWithTopTitleBottomImage = 3,
};

@interface UIButton (Extension)

typedef void(^ButtonBlock)(UIButton* btn);

- (void)addAction:(ButtonBlock)block forControlEvents:(UIControlEvents)controlEvents;

- (void)edgePosition:(ButtonPosition)edgePosition gap:(CGFloat)gap;

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
- (void)setEnlargeEdge:(CGFloat) size;

@property (nonatomic, strong) NSString *bindValue;

//-(void)drawRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
