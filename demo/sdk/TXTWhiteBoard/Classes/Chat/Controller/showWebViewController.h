//
//  showWebViewController.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2021/4/12.
//  Copyright © 2021 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTUserModel.h"

NS_ASSUME_NONNULL_BEGIN
@class showWebViewController;
@protocol  showWebViewControllerDelegate <NSObject>

- (void)muteAction:(showWebViewController *)showWebViewController;
- (void)hideshowview;

@end

@interface showWebViewController : UIViewController
@property (assign, nonatomic) id<showWebViewControllerDelegate>delegate;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *webId;
@property (strong, nonatomic) TXTUserModel *userModel;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *actionType;
@end

NS_ASSUME_NONNULL_END
