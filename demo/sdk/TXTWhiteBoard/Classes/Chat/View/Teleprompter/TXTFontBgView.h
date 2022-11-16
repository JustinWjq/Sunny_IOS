//
//  TXTFontBgView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/16.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol TXTFontBgViewDelegate <NSObject>

@optional

/// 点击尺寸
- (void)fontBgViewDidClickFontSize:(CGFloat)fontSize;

@end

@interface TXTFontBgView : UIButton


/** delegate */
@property (nonatomic, weak) id<TXTFontBgViewDelegate> delegate;


/**
 *  显示
 */
- (void)showFromView:(UIView *)fromView;

/**
 *  销毁
 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
