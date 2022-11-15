//
//  TXTChatViewController.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/1.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTChatViewController : UIViewController

@property (nonatomic, copy) dispatch_block_t closeBlock;

@end

NS_ASSUME_NONNULL_END
