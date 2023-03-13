//
//  TXTManage.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2020/9/8.
//  Copyright © 2020 洪青文. All rights reserved.
//  data:1213
//  version：1.0.4

#import <Foundation/Foundation.h>
#import "TXTCustomConfig.h"
@class TXTFileModel;

typedef NS_ENUM(NSInteger, FileType) {
    FileTypePics, // 图片
    FileTypeVideo, // 视频
    FileTypeH5, // h5
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^TXTCallback)(int code, NSString *desc);

@protocol  TXTManageDelegate <NSObject>

- (void)onFriendBtListener:(NSString *)roomId AndserviceId:(NSString *)serviceId inviteAccount:(NSString *)userId;

/// 点击了共享文件
- (void)addOnFileClickListenerRoomId:(NSInteger)roomId;
///离开房间
- (void)onEndRoom;

@end

@interface TXTManage : NSObject
@property (strong, nonatomic) TXTCallback callback;
@property (assign, nonatomic) id<TXTManageDelegate>manageDelegate;

//初始化
+ (instancetype)sharedInstance;
/**
 WeChatDict: 微信相关数据 { appId, universalLink, shareLink(分享小程序提供的userName)}
 environment: 当前环境  （“0”：开发环境  “1”：测试环境 “2”：生产环境）
 appGroup: 主 App 与 Broadcast 共享的 Application Group Identifier，可以指定为 nil，但按照文档设置会使功能更加可靠。
 */
- (void)setEnvironment:(NSString *)environment wechat:(TXTCustomConfig *)txtCustomConfig appGroup:(NSString *)appGroup;

//直接会议
/**
 roomId:会议号
 agentName: 对应阳光系统userCode
 userName: 对应阳光系统userName
 orgName: 机构
 signOrgName：加密后的机构名
 */
- (void)startVideo:(NSString *)roomId andAgent:(NSString *)agent UserName:(NSString *)userName OrgName:(NSString *)orgName SignOrgName:(NSString *)signOrgName CallBack:(TXTCallback)callback;

//反初始化
- (void)unInit;

/**
 *  fileType 文件类型
 *  fileModel 文件数据
 */
- (void)addFileToSdk:(FileType)fileType fileModel:(TXTFileModel *)fileModel;

/// 点击了共享文件
- (void)onClickFile;

- (void)endFileScreenShare;

-(NSString *)releaseVersion;

@end

NS_ASSUME_NONNULL_END
 
