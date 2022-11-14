//
//  TXTShareFileAlertView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/14.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTShareFileAlertView : UIButton


@property (nonatomic, copy) dispatch_block_t fileBlock;
@property (nonatomic, copy) dispatch_block_t whiteBoardBlock;

/**
 *  显示
 */
- (void)show;

/**
 *  销毁
 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
