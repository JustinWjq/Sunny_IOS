//
//  TXTCustomConfig.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2021/1/25.
//  Copyright © 2021 洪青文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTCustomConfig : NSObject

@property(nonatomic,strong) NSString *appid;            //微信开放id
@property(nonatomic,strong) NSString *universalLink;     //微信社会化分享回调链接
@property(nonatomic,strong) NSString *userName;  //小程序userName
@property(nonatomic,strong) NSString *miniprogramType;  //小程序环境  string "0": 开发, "1":测试, "2":生产
@property(nonatomic,assign) BOOL isShowInviteButton;  //是否展示邀请按钮 (BOOL类型)
@property(nonatomic,strong) NSString *miniprogramTitle;  //小程序的导航栏标题
@property(nonatomic,strong) NSString *miniprogramCard;  //分享的小程序卡片文字
@property(nonatomic,strong) NSString *miniprogramCardURL;  //分享的小程序卡片路径
@property(nonatomic,assign) BOOL isShowTemporaryButton; //是否展示暂时离开按钮
@property(nonatomic,strong) NSString *miniProgramPath;  //小程序路径
@property(nonatomic,assign) BOOL enableVideo; //是否打开摄像头
@property(nonatomic,assign) BOOL isChat; //是否群聊模式

@property (nonatomic, strong) NSDictionary *cookieDict;

@property(nonatomic,assign) BOOL isDebug;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
