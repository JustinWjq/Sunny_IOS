//
//  TXTBrushThinView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/8.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TXTBrushThinViewType) {
    TXTBrushThinViewTypeArrow,
    TXTBrushThinViewTypePaint
};

NS_ASSUME_NONNULL_BEGIN

@interface TXTBrushThinView : UIView

/** type */
@property (nonatomic, assign) TXTBrushThinViewType type;


///**
// *  显示
// */
//- (void)showFromView:(UIView *)fromView;
//
//
///**
// *  销毁
// */
//- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
