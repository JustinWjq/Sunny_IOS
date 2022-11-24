//
//  TXTFileModel.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/22.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTFileModel : NSObject

/** pics 图片数组 */
@property (nonatomic, strong) NSArray *pics;
/** contents 图片对应的提词器 */
@property (nonatomic, strong) NSArray *contents;

/** videoUrl */
@property (nonatomic, copy) NSString *videoUrl;

/** h5Url */
@property (nonatomic, copy) NSString *h5Url;
/** name */
@property (nonatomic, copy) NSString *name;
/** cookieDict缓存字典只有h5类型才能用 */
@property (nonatomic, strong) NSDictionary *cookieDict;

@end

NS_ASSUME_NONNULL_END
