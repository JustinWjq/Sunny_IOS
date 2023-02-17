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
@class ShareScreenWebViewController;
@protocol  ShareScreenViewControllerDelegate <NSObject>

- (void)muteAction:(ShareScreenWebViewController *)showWebViewController;
- (void)hideShareScreenWebView;

@end

@interface ShareScreenWebViewController : UIViewController
@property (assign, nonatomic) id<ShareScreenViewControllerDelegate>delegate;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *webId;
@property (strong, nonatomic) TXTUserModel *userModel;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *actionType;
@property (nonatomic , copy) NSDictionary *cookieDict;
@end

NS_ASSUME_NONNULL_END
