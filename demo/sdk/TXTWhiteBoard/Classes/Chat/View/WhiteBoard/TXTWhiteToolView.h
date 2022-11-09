//
//  TXTWhiteToolView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/8.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXTWhiteToolViewDelegate <NSObject>

@optional

/// 点击工具箱
- (void)whiteToolViewDidClickToolBtn:(UIButton *)toolBtn;
/// 点击橡皮擦
- (void)whiteToolViewDidClickEraserBtn:(UIButton *)eraser;
/// 点击箭头
- (void)whiteToolViewDidClickArrowBtn:(UIButton *)arrowBtn;
/// 点击画笔
- (void)whiteToolViewDidClickPaintBtn:(UIButton *)paintBtn;

@end


@interface TXTWhiteToolView : UIView

/** delegate */
@property (nonatomic, weak) id<TXTWhiteToolViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
