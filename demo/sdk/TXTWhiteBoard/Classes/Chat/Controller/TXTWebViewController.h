//
//  TXTWebViewController.h
//  62580
//
//  Created by JYJ on 2020/4/15.
//  Copyright © 2020 qscx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface TXTWebViewController : UIViewController

/**
 h5链接
 */
@property (nonatomic , copy) NSString *urlStr;

/**
 参数arr
 */
@property (nonatomic , copy) NSString *paramsArr;//范 参数数组字符串


/**
 H5错误回调,客户端返回前一页面
 */
@property (nonatomic , copy) void (^errCallBack)(void);

/**
 返回上一页面回调
 */
@property (nonatomic , copy) void (^onBackBlock)(void);

@end

NS_ASSUME_NONNULL_END
