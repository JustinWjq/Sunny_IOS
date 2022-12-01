//
//  txAuthorizationStatus.h
//  HuiJinSDK
//
//  Created by 洪青文 on 2021/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface txAuthorizationStatus : NSObject

+(txAuthorizationStatus *)shareInstance;
- (void)getPhotoAuthorization:(void(^)(BOOL))result;
- (void)getAudio:(void(^)(BOOL))result;
- (void)getVideo:(void(^)(BOOL))result;
- (void)getAddressAuthorization:(void(^)(BOOL))result;

@end

NS_ASSUME_NONNULL_END
