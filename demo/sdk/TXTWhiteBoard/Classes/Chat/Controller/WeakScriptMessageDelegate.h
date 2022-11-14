//
//  WeakScriptMessageDelegate.h
//  KDFDApp
//
//  Created by jiangyongjian on 2022/5/2.
//  Copyright © 2022 cailiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;


@end

NS_ASSUME_NONNULL_END
