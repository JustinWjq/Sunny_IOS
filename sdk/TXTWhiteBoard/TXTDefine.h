//
//  TXTDefine.h
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2020/9/4.
//  Copyright © 2020 洪青文. All rights reserved.
//

#ifndef TXTDefine_h
#define TXTDefine_h
//! 输出日志NSLOGJdd 这个函数只有在debuge模式下输出。
//#ifdef DEBUG
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...)
//#endif

// 存储UserDefaults
#define TXUserDefaultsSetObjectforKey(object, key) { NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults]; [userDefaults setObject:(object) forKey:(key)]; [userDefaults synchronize];}

// 取UserDefaults
#define TXUserDefaultsGetObjectforKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:(key)]

// 按key删除UserDefaults
#define TXUserDefaultsRemoveObjectforKey(key) { NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults]; [userDefaults removeObjectForKey:(key)]; [userDefaults synchronize];}

// 清除缓存
#define TXUserDefaultsClear {NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults]; NSDictionary *dic = [userDefaults dictionaryRepresentation]; for (id  key in dic) { [userDefaults removeObjectForKey:key]; } [userDefaults synchronize]; }

//单例对象申明,实现
#define SHARED_INSTANCE_DEFINE(className)   + (className *)sharedInstance;
#define SHARED_INSTANCE_IMPLEMENTATION(className) \
+ (className *)sharedInstance { \
static className *_ ## className = nil; \
if (!_ ## className) { \
_ ## className = [[className alloc] init]; \
} \
return _ ## className; \
}

#define QFSharedAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define TXSDKBundle  [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"txtBundle" ofType:@"bundle"]]
#define imageName(imagename) [UIImage imageNamed:imagename inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"txtBundle" ofType:@"bundle"]] compatibleWithTraitCollection:nil]
#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]

#define SDKWindow [ZYSuspensionManager windowForKey:@"videowindow"]


//状态栏 标签栏
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarFixHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34.0:10)
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kTabBarHeight)

#define PageItemMenuHeight 44.0f

//设置圆角和边框
#define txViewBorderRadius(View, Radius, BoardWidth, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(BoardWidth)];\
[View.layer setBorderColor:[Color CGColor]]

//设置圆角
#define txViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\

//十六进制颜色
//#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]


#define Adapt(x) ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height ? (x) * [UIScreen mainScreen].bounds.size.height / 375.0 : (x) * [UIScreen mainScreen].bounds.size.width / 375.0)


//字体
#define FontLight(s) [UIFont systemFontOfSize:s/1.f weight:UIFontWeightLight]
#define FontRegular(s) [UIFont systemFontOfSize:s/1.f weight:UIFontWeightRegular]
#define FontMedium(s) [UIFont systemFontOfSize:s/1.f weight:UIFontWeightMedium]
#define FontBold(s) [UIFont systemFontOfSize:s/1.f weight:UIFontWeightBold]
#define FontHeavy(s) [UIFont systemFontOfSize:s/1.f weight:UIFontWeightHeavy]

//#define URL_ROOT @"https://developer.ikandy.cn:60312"
#define URL_ROOT @"https://video-sells-test.ikandy.cn"
#define IMAGE_URL @"https://www.yi-guanjia.com"

#define TXTSDKBundle [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"txtBundle" ofType:@"bundle"]]

// 生产配置
//#ifdef URLREAL
//
//
//
//#endif
//
//// UAT环境配置
//#ifdef URLUAT
//
//#define URL_ROOT @"https://apis.yi-guanjia.com"
//#define IMAGE_URL @"https://www.yi-guanjia.com"

//#endif

#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self
#define SS(strongSelf)  __strong __typeof(&*self)strongSelf = weakSelf

#define Agent @"agent"
#define AgentName @"agentName"//接口中的agent字段
#define ServiceId @"serviceId"
#define SdkAppId @"sdkAppId"
#define RoomId @"roomId"
#define AgentId @"agentId"
#define AgentSig @"agentSig"
#define GroupId @"groupId"
#define ShareLink @"userName"
#define Environment @"Environment"
#define AppGroup @"appGroup"
#define MiniEnvironment @"miniEnvironment"
#define VideoStatus @"videoStatus"
#define InviteNumber @"inviteNumber"
#define MaxRoomTime @"maxRoomTime"
#define MaxRoomUser @"maxRoomUser"
#define TXTVersion @"v1.3.1"


//代理人进入房间接口
#define ServiceRoom_StartAgent  @"/api/serviceRoom/startAgent"
//代理人代理人启动共享
#define ServiceRoom_StartShare  @"/api/serviceRoom/startShare"
//代理人屏幕共享状态设置
#define ServiceRoom_ScreenStatus  @"/api/serviceRoom/screenStatus"
//呼叫房间互传消息
#define ServiceRoom_PushMessage  @"/api/serviceRoom/pushMessage"
//开始录制
#define ServiceRoom_StartRecord  @"/api/serviceRoom/startRecord"
//结束录制并结束会话
#define ServiceRoom_EndRecord  @"/api/serviceRoom/endRecord"
//用户离开房间接口
#define ServiceRoom_EndUser  @"/api/serviceRoom/endUser"
//获取房间的详细数据
#define ServiceRoom_RoomInfo  @"/api/serviceRoom/roomInfo"
//延长房间时间
#define ServiceRoom_ExtendTime  @"/api/serviceRoom/extendTime"
//代理人文件分享状态设置
#define ServiceRoom_ShareStatus  @"/api/serviceRoom/shareStatus"
//代理人声音状态设置
#define ServiceRoom_SoundStatus  @"/api/serviceRoom/soundStatus"


//上传文件接口
#define Files_Files  @"/api/file"
//获取文件列表接口
#define Files_List  @"/api/files/list"

//主持人创建房间接口
#define ServiceRoom_Create  @"/api/serviceRoom/create"
//用户进入房间接口
#define ServiceRoom_StartUser  @"/api/serviceRoom/startUser"

//设置业务员会议状态
#define Agents_RoomStatus  @"/api/agents/roomStatus"
//获取会议和业务员的状态
#define GET_Agents_RoomStatus  @"/api/agents/roomStatus"

//获取H5分享地址列表接口
#define ShareWebs_List  @"/api/shareWebs/list"
//开始H5分享服务接口
#define ShareWebs_Start  @"/api/shareWeb/start"
//停止H5分享服务接口
#define ShareWebs_Stop  @"/api/shareWeb/stop"
//添加H5分享地址接口
#define ShareWebs_Add  @"/api/shareWeb"
//删除H5分享地址接口
#define ShareWebs_Delete  @"/api/shareWeb"
//推送H5分享服务接口
#define ShareWebs_Push  @"/api/shareWeb/push"


#endif /* TXTDefine_h */
