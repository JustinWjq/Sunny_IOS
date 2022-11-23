//
//  QSIMBubbleView.h
//  62580
//
//  Created by QSZX001 on 2020/5/13.
//  Copyright © 2020 qscx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSIMBubbleView : UIView

@property (nonatomic,strong) UIImageView *bgImageView; // 气泡图片

/** isLeft */
@property (nonatomic, assign) BOOL isLeft;

@end

NS_ASSUME_NONNULL_END
