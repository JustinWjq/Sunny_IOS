//
//  TXTAlertShareView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/7.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTAlertShareView : UIView

+ (instancetype)alert;

+ (void)hide;

+ (instancetype)getAlertView;


@property (nonatomic, copy) dispatch_block_t cancleBlock;
@property (nonatomic, copy) dispatch_block_t sureBlock;

@end

NS_ASSUME_NONNULL_END
