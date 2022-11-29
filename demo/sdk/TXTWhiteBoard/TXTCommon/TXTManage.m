//
//  TXTManage.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2020/9/8.
//  Copyright © 2020 洪青文. All rights reserved.


#import "TXTManage.h"
#import "WXApi.h"
#import "AFNHTTPSessionManager.h"
#import "TICConfig.h"
#import "TXTCommon.h"
#import "txAuthorizationStatus.h"

#import "SunnyChatViewController.h"
#import "ZYSuspensionManager.h"
//#import "TXTNavigationViewController.h"
#import "TXTNavigationController.h"
#import "TXTStatusBar.h"


@interface TXTManage ()
@property (strong, nonatomic) UIWindow *nnwindow;

@end

@implementation TXTManage

+ (instancetype)sharedInstance
{
    static TXTManage *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TXTManage alloc] init];;
    });
    return instance;
}

- (void)setEnvironment:(NSString *)environment wechat:(TXTCustomConfig *)txtCustomConfig appGroup:(NSString *)appGroup{
    NSString *isfirstEnter = TXUserDefaultsGetObjectforKey(VideoStatus);
    if ([isfirstEnter isEqualToString:@"hide"]) {
        if (self.nnwindow == nil) {
            TXUserDefaultsSetObjectforKey(@"leave", VideoStatus);
        }else{
            self.nnwindow.hidden = NO;
            NSLog(@"environment用户没有离开房间");
            return;
        }
    }
    
    [TXTCustomConfig sharedInstance].userName = txtCustomConfig.userName;
    [TXTCustomConfig sharedInstance].appid = txtCustomConfig.appid;
    [TXTCustomConfig sharedInstance].universalLink = txtCustomConfig.universalLink;
    [TXTCustomConfig sharedInstance].miniprogramType = txtCustomConfig.miniprogramType;
    [TXTCustomConfig sharedInstance].isShowInviteButton = txtCustomConfig.isShowInviteButton;
    [TXTCustomConfig sharedInstance].miniprogramTitle = txtCustomConfig.miniprogramTitle;
    [TXTCustomConfig sharedInstance].miniprogramCard = txtCustomConfig.miniprogramCard;
    [TXTCustomConfig sharedInstance].isShowTemporaryButton = txtCustomConfig.isShowTemporaryButton;
    [TXTCustomConfig sharedInstance].isChat = txtCustomConfig.isChat;
    
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    //向微信注册
    //wx8e6096173bff1149
    //https://video-sells-test.ikandy.cn/txWhiteBoard/
    TXUserDefaultsSetObjectforKey(txtCustomConfig.userName, ShareLink);
    TXUserDefaultsSetObjectforKey(environment, Environment);
    TXUserDefaultsSetObjectforKey(appGroup, AppGroup);
    TXUserDefaultsSetObjectforKey(txtCustomConfig.miniprogramType, MiniEnvironment);
    [WXApi registerApp:txtCustomConfig.appid universalLink:txtCustomConfig.universalLink];
}

- (void)setMiniprogramConfig:(TXTCustomConfig *)config{
    if (config.userName != nil) {
        
    }
    [TXTCustomConfig sharedInstance].userName = config.userName;
    [TXTCustomConfig sharedInstance].appid = config.appid;
    [TXTCustomConfig sharedInstance].universalLink = config.universalLink;
    [TXTCustomConfig sharedInstance].miniprogramType = config.miniprogramType;
    [TXTCustomConfig sharedInstance].isShowInviteButton = config.isShowInviteButton;
    [TXTCustomConfig sharedInstance].miniprogramTitle = config.miniprogramTitle;
    [TXTCustomConfig sharedInstance].miniprogramCard = config.miniprogramCard;
    [TXTCustomConfig sharedInstance].isShowTemporaryButton = config.isShowTemporaryButton;
    [TXTCustomConfig sharedInstance].isChat = config.isChat;
}

- (void)createRoom:(NSString *)agentName OrgName:(NSString *)orgName SignOrgName:(NSString *)signOrgName EnableVideo:(BOOL)enableVideo BusinessData:(NSDictionary *)businessData RoomInfo:(NSDictionary *)roomInfo CallBack:(TXTCallback)callback{
    if ([agentName isEqualToString:@""] || agentName == nil) {
        [[JMToast sharedToast] showDialogWithMsg:@"请输入坐席名"];
        return;
    }else{
        TXUserDefaultsSetObjectforKey(agentName, Agent);
    }
    [JMLoadingHUD show];
    
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionary];
    if (businessData != nil) {
        [bodyDic setValue:businessData forKey:@"extraData"];
    }
    if (roomInfo != nil) {
        [bodyDic setValue:roomInfo forKey:@"roomInfo"];
    }
    [bodyDic setValue:agentName forKey:@"account"];
    [bodyDic setValue:orgName forKey:@"orgAccount"];
    [bodyDic setValue:signOrgName forKey:@"sign"];
    NSLog(@"bodyDic == %@", [bodyDic description]);
    [[AFNHTTPSessionManager shareInstance] requestURL:ServiceRoom_Create RequestWay:@"POST" Header:nil Body:bodyDic params:nil isFormData:NO success:^(NSError *error, id response) {
        [JMLoadingHUD hide];
        NSString *errCode = [response valueForKey:@"errCode"];
        if ([errCode intValue] == 0) {
            NSDictionary *resultdic = [response valueForKey:@"result"];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultdic options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
         
//            NSString *inviteNumber = [resultdic valueForKey:@"inviteNumber"];
            TICBLOCK_SAFE_RUN(callback,[errCode intValue],jsonString);
        }else{
            TICBLOCK_SAFE_RUN(callback,[errCode intValue],[[response valueForKey:@"errInfo"] description]);
        }
    } failure:^(NSError *error, id response) {
        [JMLoadingHUD hide];
        [[JMToast sharedToast] showDialogWithMsg:@"网络请求超时"];
    }];
}


- (void)joinRoom:(NSString *)inviteNumber UserId:(NSString *)userid UserName:(NSString *)userName OrgName:(NSString *)orgName SignOrgName:(NSString *)signOrgName EnableVideo:(BOOL)enableVideo UserHead:(NSString *)userHead BusinessData:(NSDictionary *)businessData CallBack:(TXTCallback)callback{
    NSString *isfirstEnter = TXUserDefaultsGetObjectforKey(VideoStatus);
    if ([isfirstEnter isEqualToString:@"hide"]) {
        if (self.nnwindow == nil) {
            TXUserDefaultsSetObjectforKey(@"leave", VideoStatus);
        }else{
            self.nnwindow.hidden = NO;
            TICBLOCK_SAFE_RUN(callback,200001,@"用户没有离开房间");
            return;
        }
    }
    
    if ([inviteNumber isEqualToString:@""] || inviteNumber == nil) {
        [[JMToast sharedToast] showDialogWithMsg:@"没有房间号"];
        return;
    }else{
        TXUserDefaultsSetObjectforKey(inviteNumber, InviteNumber);
        TXUserDefaultsSetObjectforKey(userName, Agent);
    }
    [JMLoadingHUD show];
    NSMutableDictionary *bodyDic;
    if (businessData == nil) {
        bodyDic = [NSMutableDictionary dictionary];
    }else{
        bodyDic = [NSMutableDictionary dictionary];
//        bodyDic = [NSMutableDictionary dictionaryWithDictionary:businessData];
    }
    [bodyDic setValue:inviteNumber forKey:@"inviteNumber"];
    [bodyDic setValue:userid forKey:@"userId"];
    [bodyDic setValue:userName forKey:@"userName"];
    [bodyDic setValue:orgName forKey:@"orgAccount"];
    [bodyDic setValue:signOrgName forKey:@"sign"];
    [bodyDic setValue:userHead forKey:@"userHead"];
    [bodyDic setValue:businessData forKey:@"extraData"];
    NSLog(@"bodyDic == %@", [bodyDic description]);
       [[AFNHTTPSessionManager shareInstance] requestURL:ServiceRoom_StartUser RequestWay:@"POST" Header:nil Body:bodyDic params:nil isFormData:NO success:^(NSError *error, id response) {
          
           NSString *errCode = [response valueForKey:@"errCode"];
           if ([errCode intValue] == 0) {
               NSDictionary *result = [response valueForKey:@"result"];
               TXUserDefaultsSetObjectforKey([result valueForKey:@"serviceId"],ServiceId);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"sdkAppId"],SdkAppId);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"roomId"],RoomId);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"userId"],AgentId);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"userSig"],AgentSig);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"groupId"],GroupId);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"agentName"],AgentName);
//               TXUserDefaultsSetObjectforKey([result valueForKey:@"inviteNumber"],InviteNumber);
//               TXUserDefaultsSetObjectforKey([result valueForKey:@"maxRoomUser"],MaxRoomUser);
               float maxRoomTime = [[result valueForKey:@"maxRoomTime"] floatValue];
               NSInteger hourTime = maxRoomTime / 60 ;
               NSString *hourTimeStr = [NSString stringWithFormat:@"%ld",(long)hourTime];
               TXUserDefaultsSetObjectforKey(hourTimeStr,MaxRoomTime);
               NSInteger maxRoomUser = [[result valueForKey:@"maxRoomUser"] intValue];
               maxRoomUser = maxRoomUser - 1;
               NSString *maxRoomUserstr = [NSString stringWithFormat:@"%ld",(long)maxRoomUser];
               TXUserDefaultsSetObjectforKey(maxRoomUserstr,MaxRoomUser);
               
               [TICConfig shareInstance].sdkAppId = [result valueForKey:@"sdkAppId"];
               [TICConfig shareInstance].userId = [result valueForKey:@"userId"];
               [TICConfig shareInstance].userSig = [result valueForKey:@"userSig"];
               [TICConfig shareInstance].role = [result valueForKey:@"userRole"];
               
               [TICConfig shareInstance].enableVideo = enableVideo;
               
               
               int sdkAppid = [[TICConfig shareInstance].sdkAppId intValue];
               [[TICManager sharedInstance] init:sdkAppid callback:^(TICModule module, int code, NSString *desc) {
                   if(code == 0){
                       if ([TXTCustomConfig sharedInstance].isChat) {
                           [self loginSDK:@"1" CallBack:callback];
                       }else{
                           [self loginSDK:@"0" CallBack:callback];
                       }
                   }else{
                       TICBLOCK_SAFE_RUN(callback,code,desc);
                   }
               }];
              
           }else{
                [JMLoadingHUD hide];
//               [[JMToast sharedToast] showDialogWithMsg:[response valueForKey:@"errInfo"]];
               TICBLOCK_SAFE_RUN(callback,[errCode intValue],[response valueForKey:@"errInfo"]);
           }

       } failure:^(NSError *error, id response) {
            [JMLoadingHUD hide];
           [[JMToast sharedToast] showDialogWithMsg:@"网络请求超时"];
       }];
   
}



- (void)startVideo:(NSString *)agentName OrgName:(NSString *)orgName SignOrgName:(NSString *)signOrgName UserHead:(NSString *)userHead BusinessData:(NSDictionary *)businessData CallBack:(TXTCallback)callback{
    NSString *isfirstEnter = TXUserDefaultsGetObjectforKey(VideoStatus);
    //判读房间是否存在
    if ([isfirstEnter isEqualToString:@"hide"]) {
        if (self.nnwindow == nil) {
            TXUserDefaultsSetObjectforKey(@"leave", VideoStatus);
        }else{
            self.nnwindow.hidden = NO;
            TICBLOCK_SAFE_RUN(callback,111111111,@"用户没有离开房间");
            return;
        }
    }
    
    NSLog(@"startVideo");
//    self.nnwindow =[[UIWindow alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
//    self.nnwindow.windowLevel=UIWindowLevelAlert;
//    SunnyChatViewController *classRoom = [[SunnyChatViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:classRoom];
//    [nav.navigationBar setShadowImage:[[UIImage alloc] init]];
//    self.nnwindow.rootViewController = nav;
//    [ZYSuspensionManager saveWindow:self.nnwindow forKey:@"videowindow"];
//    [self.nnwindow makeKeyAndVisible];
    
    
    if ([agentName isEqualToString:@""] || agentName == nil) {
        [[JMToast sharedToast] showDialogWithMsg:@"请输入坐席名"];
        return;
    }else{
        TXUserDefaultsSetObjectforKey(agentName, Agent);
    }
    [JMLoadingHUD show];
    NSMutableDictionary *bodyDic;
    if (businessData == nil) {
        bodyDic = [NSMutableDictionary dictionary];
    }else{
        bodyDic = [NSMutableDictionary dictionaryWithDictionary:businessData];
    }
    [bodyDic setValue:agentName forKey:@"agent"];
    [bodyDic setValue:orgName forKey:@"orgAccount"];
    [bodyDic setValue:signOrgName forKey:@"sign"];
    [bodyDic setValue:userHead forKey:@"userHead"];
    NSLog(@"bodyDic == %@", [bodyDic description]);
//    NSDictionary *bodyDic = @{@"agent":agentName,@"orgAccount":orgName,@"sign":signOrgName};
       [[AFNHTTPSessionManager shareInstance] requestURL:ServiceRoom_StartAgent RequestWay:@"POST" Header:nil Body:bodyDic params:nil isFormData:NO success:^(NSError *error, id response) {
           NSLog(@"StartAgent = %@",[response description]);
           NSString *errCode = [response valueForKey:@"errCode"];
           if ([errCode intValue] == 0) {
               NSDictionary *result = [response valueForKey:@"result"];
               TXUserDefaultsSetObjectforKey([result valueForKey:@"serviceId"],ServiceId);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"sdkAppId"],SdkAppId);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"roomId"],RoomId);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"agentId"],AgentId);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"agentSig"],AgentSig);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"groupId"],GroupId);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"agentName"],AgentName);
               TXUserDefaultsSetObjectforKey([result valueForKey:@"inviteNumber"],InviteNumber);
//               TXUserDefaultsSetObjectforKey([result valueForKey:@"maxRoomUser"],MaxRoomUser);
               float maxRoomTime = [[result valueForKey:@"maxRoomTime"] floatValue];
               NSInteger hourTime = maxRoomTime / 60 ;
               NSString *hourTimeStr = [NSString stringWithFormat:@"%d",hourTime];
               TXUserDefaultsSetObjectforKey(hourTimeStr,MaxRoomTime);
               NSInteger maxRoomUser = [[result valueForKey:@"maxRoomUser"] intValue];
               maxRoomUser = maxRoomUser - 1;
               NSString *maxRoomUserstr = [NSString stringWithFormat:@"%d",maxRoomUser];
               TXUserDefaultsSetObjectforKey(maxRoomUserstr,MaxRoomUser);

               [TICConfig shareInstance].sdkAppId = [result valueForKey:@"sdkAppId"];
               [TICConfig shareInstance].userId = [result valueForKey:@"agentId"];
               [TICConfig shareInstance].userSig = [result valueForKey:@"agentSig"];
               [TICConfig shareInstance].role = @"owner";

               //入会默认关闭摄像头
               [TICConfig shareInstance].enableVideo = NO;

               int sdkAppid = [[TICConfig shareInstance].sdkAppId intValue];
               [[TICManager sharedInstance] init:sdkAppid callback:^(TICModule module, int code, NSString *desc) {
                   if(code == 0){
                       if ([TXTCustomConfig sharedInstance].isChat) {
                           [self loginSDK:@"1" CallBack:callback];
                       }else{
                           [self loginSDK:@"0" CallBack:callback];
                       }

                   }else{
                       TICBLOCK_SAFE_RUN(callback,code,desc);
                   }
               }];

           }else{
                [JMLoadingHUD hide];
//               [[JMToast sharedToast] showDialogWithMsg:[response valueForKey:@"errInfo"]];
               TICBLOCK_SAFE_RUN(callback,[errCode intValue],[response valueForKey:@"errInfo"]);
           }

       } failure:^(NSError *error, id response) {
            [JMLoadingHUD hide];
           [[JMToast sharedToast] showDialogWithMsg:@"网络请求超时"];
       }];
   
}

//channel: 0 之前的模式 1 群聊模式
- (void)loginSDK:(NSString *)channel CallBack:(TXTCallback)callback{
    NSString *userId = [TICConfig shareInstance].userId;
    NSString *userSig = [TICConfig shareInstance].userSig;
    __weak typeof(self) ws = self;
    [[TICManager sharedInstance] login:userId userSig:userSig callback:^(TICModule module, int code, NSString *desc) {
        if(code == 0){
            [JMLoadingHUD hide];
//            [[JMToast sharedToast] showDialogWithMsg:@"初始化成功"];
            
            NSLog(@"TRTC: %@\nIMSDK: %@\nTEduBoard: %@",[TRTCCloud getSDKVersion],[[V2TIMManager sharedInstance] getVersion],[TEduBoardController getVersion]);
            NSString *classId = [NSString stringWithFormat:@"%@",TXUserDefaultsGetObjectforKey(RoomId)];
            NSString *userId = [NSString stringWithFormat:@"%@",TXUserDefaultsGetObjectforKey(AgentId)];
            if (classId.length <= 0) {
                return;
            }
            
            [JMLoadingHUD show];
            TICClassroomOption *option = [[TICClassroomOption alloc] init];
            option.classId = [classId intValue];
//            TXUserDefaultsSetObjectforKey(@"32258903",GroupId);
//            TXUserDefaultsSetObjectforKey(@"32258903",RoomId);
//            option.classId = 32258903;

            
            __weak typeof(self) ws = self;
            
            [[TICManager sharedInstance] joinClassroom:option callback:^(TICModule module, int code, NSString *desc) {
                NSLog(@"joinClassroom == %d",code);
                if(code == 0){
                    [JMLoadingHUD hide];
                    //添加旋转通知
//                    [[NSNotificationCenter defaultCenter] addObserver:self
//                                                             selector:@selector(onDeviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification
//                                                               object:nil];
//                    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
                    NSString *joinDesc = [NSString stringWithFormat:@"joinClassroom=%@",desc];
                    ws.nnwindow =[[UIWindow alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
                    ws.nnwindow.windowLevel=UIWindowLevelAlert;
                    SunnyChatViewController *classRoom = [[SunnyChatViewController alloc] init];
                    TXTNavigationController *nav = [[TXTNavigationController alloc] initWithRootViewController:classRoom];
                    [nav.navigationBar setShadowImage:[[UIImage alloc] init]];
                    ws.nnwindow.rootViewController = nav;
                    [ZYSuspensionManager saveWindow:ws.nnwindow forKey:@"videowindow"];
                    [ws.nnwindow makeKeyAndVisible];
                    
                    TICBLOCK_SAFE_RUN(callback,code,joinDesc);
                }
                else{
                    [JMLoadingHUD hide];
                    NSString *joinDesc = [NSString stringWithFormat:@"joinClassroom=%@",desc];
                    TICBLOCK_SAFE_RUN(callback,code,joinDesc);
                }
            }];
        }
        else{
            [JMLoadingHUD hide];
            TICBLOCK_SAFE_RUN(callback,code,[NSString stringWithFormat:@"%@=====登录失败",desc]);
        }
    }];
}

- (BOOL)onDeviceOrientationDidChange{
    //获取当前设备Device
    UIDevice *device = [UIDevice currentDevice] ;
    //识别当前设备的旋转方向
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
        case UIDeviceOrientationUnknown:
            //系统当前无法识别设备朝向，可能是倾斜
            NSLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"屏幕向左橫置");
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右橫置");
            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;
            
        default:
            NSLog(@"無法识别");
            break;
    }
    return YES;
}

- (void)setAgentInRoomStatus:(NSString *)agentId UserName:(NSString *)userName AndServiceId:(NSString *)serviceId InviteAccount:(NSString *)inviteAccount AndAction:(NSString *)action OrgName:(NSString *)orgName SignOrgName:(NSString *)signOrgName CallBack:(TXTCallback)callback{
    NSDictionary *dic = @{@"account":agentId,@"userName":userName,@"serviceId":serviceId,@"inviteAccount":inviteAccount,@"action":action,@"orgAccount":orgName,@"sign":signOrgName};
    NSLog(@"setAgentInRoomStatus=%@",dic);
    [[AFNHTTPSessionManager shareInstance] requestURL:Agents_RoomStatus RequestWay:@"POST" Header:nil Body:dic params:nil isFormData:NO success:^(NSError *error, id response) {
        NSString *errCode = [response valueForKey:@"errCode"];
        NSLog(@"%@",[response description]);
        if ([errCode intValue] == 0) {
            NSLog(@"setAgentInRoomStatus开始");
            TICBLOCK_SAFE_RUN(callback,[errCode intValue],@"");
        }else{
            NSLog(@"setAgentInRoomStatus错误：%@",[response valueForKey:@"errInfo"]);
            TICBLOCK_SAFE_RUN(callback,[errCode intValue],[response valueForKey:@"errInfo"]);
        }
    } failure:^(NSError *error, id response) {
        NSLog(@"网络请求超时");
    }];
}

- (void)getAgentAndRoomStatus:(NSString *)agentId AndServiceId:(NSString *)serviceId OrgName:(NSString *)orgName SignOrgName:(NSString *)signOrgName CallBack:(TXTCallback)callback{
    [[AFNHTTPSessionManager shareInstance] requestURL:[NSString stringWithFormat:@"%@?account=%@&serviceId=%@&orgAccount=%@&sign=%@",GET_Agents_RoomStatus,agentId,serviceId,orgName,signOrgName] RequestWay:@"GET" Header:nil Body:nil params:nil isFormData:NO success:^(NSError *error, id response) {
        NSString *errCode = [response valueForKey:@"errCode"];
        if ([errCode intValue] == 0) {
            NSDictionary *result = [response valueForKey:@"result"];
            NSString *resultStr = [[TXTCommon sharedInstance] convertToJsonData:result];
            TICBLOCK_SAFE_RUN(callback,[errCode intValue],resultStr);
        }else{
            NSLog(@"录制错误：%@",[response valueForKey:@"errInfo"]);
            TICBLOCK_SAFE_RUN(callback,[errCode intValue],[response valueForKey:@"errInfo"]);
        }
    } failure:^(NSError *error, id response) {
        NSLog(@"网络请求超时");
    }];
}


- (void)addFriendBtListener:(NSString *)roomId AndserviceId:(NSString *)serviceId inviteAccount:(NSString *)userId CurrentWindow:(UIView *)window{
    NSLog(@"addFriendBtListener");
    NSLog(@"%@",self);
    if ([TXTManage sharedInstance].manageDelegate && [[TXTManage sharedInstance].manageDelegate respondsToSelector:@selector(onFriendBtListener:AndserviceId:inviteAccount:)]) {
        NSLog(@"manageDelegate.addFriendBtListener");
        [[TXTManage sharedInstance].manageDelegate onFriendBtListener:roomId AndserviceId:serviceId inviteAccount:userId];
    }
}

- (void)addChatFriendBtListener:(NSString *)roomId AndserviceId:(NSString *)serviceId inviteAccount:(NSString *)userId CurrentWindow:(UIView *)window{
    NSLog(@"addChatFriendBtListener");
    NSLog(@"%@",self);
    if ([TXTManage sharedInstance].manageDelegate && [[TXTManage sharedInstance].manageDelegate respondsToSelector:@selector(onFriendBtListener:AndserviceId:inviteAccount:)]) {
        NSLog(@"manageDelegate.addChatFriendBtListener");
        [[TXTManage sharedInstance].manageDelegate onFriendBtListener:roomId AndserviceId:serviceId inviteAccount:userId];
    }
}

- (void)unInit{
    [[TICManager sharedInstance] unInit];
}


/**
 *  fileType 文件类型
 *  fileModel 文件数据
 */
- (void)addFileToSdk:(FileType)fileType fileModel:(TXTFileModel *)fileModel {
    UIWindow *window = [ZYSuspensionManager valueForKey:@"videowindow"];
    TXTNavigationController *nav = (TXTNavigationController *)window.rootViewController;
    SunnyChatViewController *classRoom = (SunnyChatViewController *)nav.viewControllers[0];
    [classRoom addFile:fileType fileModel:fileModel];
}

/// 点击了共享文件
- (void)onClickFile {
    if ([self.manageDelegate respondsToSelector:@selector(addOnFileClickListener)]) {
        [self.manageDelegate addOnFileClickListener];
    }
}

//#param mark -- 权限获取
- (void)otherAuthorization{
    [[txAuthorizationStatus shareInstance] getPhotoAuthorization:^(BOOL result) {
        if (result) {
            [[txAuthorizationStatus shareInstance] getAudio:^(BOOL audio) {
                if (audio) {
                    [[txAuthorizationStatus shareInstance] getVideo:^(BOOL video) {
                        if (video) {
//                            [self networking];
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIAlertUtil showAlertWithPersentViewController:self alertCallBack:^(NSInteger index) {
                                    if (index == 1) {
                                        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                if (@available(iOS 10.0, *)) {
                                                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                                                    }];
                                                }
                                            }
                                    }
                                } title:@"" message:@"您没有给予相机权限，所以不支持视频操作" cancelButtonTitle:@"取消" otherButtonTitles:@"去设置"];
                            });
                            
                        }
                    }];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIAlertUtil showAlertWithPersentViewController:self alertCallBack:^(NSInteger index) {
                            if (index == 1) {
                                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                        if (@available(iOS 10.0, *)) {
                                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                                            }];
                                        }
                                    }
                            }
                        } title:@"" message:@"您没有给予麦克风权限，所以不支持视频操作" cancelButtonTitle:@"取消" otherButtonTitles:@"去设置"];
                    });
                    
                }
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertUtil showAlertWithPersentViewController:self alertCallBack:^(NSInteger index) {
                    if (index == 1) {
                        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                if (@available(iOS 10.0, *)) {
                                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                                    }];
                                }
                            }
                    }
                } title:@"" message:@"您没有给予相册权限，所以不支持录屏操作" cancelButtonTitle:@"取消" otherButtonTitles:@"去设置"];
            });
            
        }
    }];
}


@end
