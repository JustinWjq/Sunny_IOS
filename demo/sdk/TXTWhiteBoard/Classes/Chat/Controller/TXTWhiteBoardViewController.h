//
//  TXTWhiteBoardViewController.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/8.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTWhiteBoardViewController : UIViewController

/** isShowWhiteBoard */
@property (nonatomic, assign) BOOL isShowWhiteBoard;

@property (nonatomic, copy) dispatch_block_t closeBlock;

/** isTelepromp */
@property (nonatomic, assign) BOOL isTelepromp;
/// 展示ppt选图片
- (void)showImages:(NSArray *)imagesArray contentArray:(NSArray *)contentArray;

- (void)showVideo:(NSString *)videoUrl;

/// 是否横竖屏
- (void)updateUI:(BOOL)isPortrait;

@end

NS_ASSUME_NONNULL_END
