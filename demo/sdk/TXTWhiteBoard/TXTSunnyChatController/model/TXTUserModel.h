//
//  TXTUserModel.h
//  TICDemo
//
//  Created by 洪青文 on 2020/9/16.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TICRenderView.h"
#import "TICManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXTUserModel : NSObject
@property (strong, nonatomic) TICRenderView *render;
@property (assign, nonatomic) BOOL showVideo;
@property (strong, nonatomic) TRTCVolumeInfo *info;
@property (assign, nonatomic) BOOL showAudio;
@property (strong, nonatomic) NSString *userName;
@property (assign, nonatomic) BOOL useShare;
@property (strong, nonatomic) NSString *userRole;
@property (strong, nonatomic) NSString *userIcon;//图标地址
@property (strong, nonatomic) NSString *userHead;//头像

-(BOOL)compareUserIdWithoutExtra:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
