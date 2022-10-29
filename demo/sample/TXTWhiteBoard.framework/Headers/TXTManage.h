//
//  TXTManage.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2020/9/8.
//  Copyright © 2020 洪青文. All rights reserved.
//  data:0301
//  version：1.3.0

#import <Foundation/Foundation.h>
#import "TXTCustomConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^TXTCallback)(int code, NSString *desc);

@protocol  TXTManageDelegate <NSObject>

- (void)onFriendBtListener:(NSString *)roomId AndserviceId:(NSString *)serviceId inviteAccount:(NSString *)userId;

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
//创建会议
- (void)createRoom:(NSString *)agentName OrgName:(NSString *)orgName SignOrgName:(NSString *)signOrgName EnableVideo:(BOOL)enableVideo BusinessData:(NSDictionary *)businessData RoomInfo:(NSDictionary *)roomInfo CallBack:(TXTCallback)callback;
//参加会议
/**
 agentName: 用户名
 signOrgName：加密后的机构名
 businessData: 地理位置相关参数
 enableVideo: 是否打开摄像头
 userHead: 用户头像URL
 */
- (void)joinRoom:(NSString *)inviteNumber UserId:(NSString *)userid UserName:(NSString *)userName OrgName:(NSString *)orgName SignOrgName:(NSString *)signOrgName EnableVideo:(BOOL)enableVideo UserHead:(NSString *)userHead BusinessData:(NSDictionary *)businessData CallBack:(TXTCallback)callback;
//直接会议
/**
 agentName: 用户名
 signOrgName：加密后的机构名
 businessData: 地理位置相关参数
 enableVideo: 是否打开摄像头
 userHead: 用户头像URL
 */
- (void)startVideo:(NSString *)agentName OrgName:(NSString *)orgName SignOrgName:(NSString *)signOrgName EnableVideo:(BOOL)enableVideo UserHead:(NSString *)userHead BusinessData:(NSDictionary *)businessData CallBack:(TXTCallback)callback;

//获取参会人和房间信息
/**
 *  agentId 业务员账号
 *  serviceId
 *  OrgName 机构 测试：gscyf_test 必填
 *  SignOrgName 加密签名
 */
- (void)getAgentAndRoomStatus:(NSString *)agentId AndServiceId:(NSString *)serviceId OrgName:(NSString *)orgName SignOrgName:(NSString *)signOrgName CallBack:(TXTCallback)callback;
//设置参会人信息
/**
 *  agentId 业务员账号
 *  userName 被邀请的业务员姓名
 *  serviceId 会议id
 *  inviteAccount  发送该邀请的业务员账号（指的是谁发出邀请的人，在 onFriendBtListener回调中的inviteAccount ）
 *  action 业务员操作, invited: 收到会议邀请, refused: 拒绝会议邀请
 *  OrgName 机构 测试：gscyf_test 必填
 *  SignOrgName 加密签名
 */
- (void)setAgentInRoomStatus:(NSString *)agentId UserName:(NSString *)userName AndServiceId:(NSString *)serviceId InviteAccount:(NSString *)inviteAccount AndAction:(NSString *)action OrgName:(NSString *)orgName SignOrgName:(NSString *)signOrgName CallBack:(TXTCallback)callback;


//反初始化
- (void)unInit;

@end

NS_ASSUME_NONNULL_END
 
