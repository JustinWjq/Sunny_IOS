//
//  TXTSmallMessage.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/4.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTSmallMessage : NSObject

/** serviceId */
@property (nonatomic, copy) NSString *serviceId;
/** type */
@property (nonatomic, copy) NSString *type;
/** userId */
@property (nonatomic, copy) NSString *userId;
/** userName */
@property (nonatomic, copy) NSString *userName;
/** content */
@property (nonatomic, copy) NSString *content;

/** cellH */
@property (nonatomic, assign) CGFloat cellH;

@end

NS_ASSUME_NONNULL_END
