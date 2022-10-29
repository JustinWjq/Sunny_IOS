//
//  TXTCommon.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2021/1/20.
//  Copyright © 2021 洪青文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTCommon : NSObject
+ (instancetype)sharedInstance;
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
- (NSString *)convertToJsonData:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
