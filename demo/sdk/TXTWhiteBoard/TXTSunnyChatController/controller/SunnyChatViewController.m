//
//  SunnyChatViewController.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/10/21.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "SunnyChatViewController.h"
#import "bottomButtons.h"
#import "UIBarButtonItem+SXCreate.h"
#import "UINavigationSXFixSpace.h"
#import "TXTCommon.h"
#import "ZYSuspensionManager.h"

#import "TXTUserModel.h"
#import "TICRenderView.h"
#import "renderVideoView.h"

#import "TXTGroupMemberViewController.h"
#import "TXTChatViewController.h"

@interface SunnyChatViewController ()<bottomButtonsDelegate, TICEventListener, TICMessageListener, TICStatusListener>
@property (nonatomic, strong) bottomButtons *bottomToos;//底部视图
@property (nonatomic, strong) NSString *userId;//主持人id
@property (strong, nonatomic) NSMutableArray *userIdArr;//房间存在人员id数组
@property (nonatomic, strong) NSMutableArray *renderViews;//房间人员数组
@property (strong, nonatomic) NSString *webType;//同屏还是被同屏
@property (strong, nonatomic) NSString *productName;//同屏产品名
@property (strong, nonatomic) NSString *webId;//同屏de id
@property (strong, nonatomic) renderVideoView *renderVideoView;//视频视图

@property (assign, nonatomic) BOOL state;//打开摄像头
@property (assign, nonatomic) BOOL muteState;//麦克风开关
@property (assign, nonatomic) BOOL switchCamera;//反转镜头开关
@property (assign, nonatomic) BOOL shareState;//共享开关
@property (assign, nonatomic) BOOL shareScene;//投屏开关

// 成员管理
/** groupMemberViewController */
@property (nonatomic, strong) TXTGroupMemberViewController *groupMemberViewController;
@end

@implementation SunnyChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"远程会议";

//    //扬声器
    UIImage *speakerImg = [UIImage imageNamed:@"openMicrophone" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];

//    //切换摄像头
    UIImage *cameraImg = [UIImage imageNamed:@"startRecord" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];

    
//    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
////    [but setFrame:CGRectMake(0, 0, 44, 44)];
//        [but addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
//        [but setImage:[speakerImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        [but sizeToFit];
//        UIBarButtonItem *Item = [[UIBarButtonItem alloc] initWithCustomView:but];
//    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
////    [but1 setFrame:CGRectMake(54, 0, 44, 44)];
//        [but1 addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
//        [but1 setImage:[cameraImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        [but1 sizeToFit];
//    UIBarButtonItem *Item1 = [[UIBarButtonItem alloc] initWithCustomView:but1];
//    Item1.width = 5;
//    self.navigationItem.leftBarButtonItems  =@[[Item fixedSpaceWithWidth:-20],Item1];
    
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem itemWithTarget:self
                                                                         action:@selector(pushAction)
                                                                          image:speakerImg],
                                                [UIBarButtonItem itemWithTarget:self
                                                                         action:@selector(pushAction)
                                                                          image:cameraImg]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self
                                                                      action:@selector(onQuitClassRoom)
                                                                       image:cameraImg];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#222222"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#424548"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
   
    [self setBottomToolsUI];
    [self addNotification];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self joinRoom];
}

- (void)initParams{
    
}

- (void)joinRoom{
    //更新视频视图
    //    self.userId = TXUserDefaultsGetObjectforKey(Agent);
    self.userId = [TICConfig shareInstance].userId;
    self.userIdArr = [NSMutableArray array];
    [self.userIdArr addObject:self.userId];
    
    TXTUserModel *userModel = [[TXTUserModel alloc] init];
    TICRenderView *render = [[TICRenderView alloc] init];
    render.userId = [TICConfig shareInstance].userId;
    render.streamType = TICStreamType_Main;
    [[[TICManager sharedInstance] getTRTCCloud] startRemoteView:[TICConfig shareInstance].userId view:render];
    userModel.render = render;
    userModel.userName = TXUserDefaultsGetObjectforKey(Agent);
    userModel.showVideo = [TICConfig shareInstance].enableVideo;
    userModel.showAudio = YES;
    userModel.userRole = [TICConfig shareInstance].role;
    
    [[[TICManager sharedInstance] getTRTCCloud] startRemoteView:[TICConfig shareInstance].userId view:render];
    [[[TICManager sharedInstance] getTRTCCloud] startLocalPreview:YES view:render];
    [[[TICManager sharedInstance] getTRTCCloud] startLocalAudio];
    
    [self.renderViews addObject:userModel];
    [self roomInfo:userModel];
}

- (void)roomInfo:(TXTUserModel *)userModel{
    NSString *serviceId = TXUserDefaultsGetObjectforKey(ServiceId);
    [[AFNHTTPSessionManager shareInstance] requestURL:[NSString stringWithFormat:@"%@/%@",ServiceRoom_RoomInfo,serviceId] RequestWay:@"GET" Header:nil Body:nil params:nil isFormData:NO success:^(NSError *error, id response) {
        NSString *errCode = [response valueForKey:@"errCode"];
        if ([errCode intValue] == 0) {
            NSLog(@"roomInfo = %@",[response description]);
            NSDictionary *result = [response valueForKey:@"result"];
            
            NSArray *userInfo = [result valueForKey:@"userInfo"];
            NSMutableArray *renderNewArr = self.renderViews;
            for (int i = 0; i<userInfo.count; i++) {
                
                NSDictionary *userdic = userInfo[i];
                NSArray *keysArr = [userdic allKeys];
                //判断本人是同屏的发送方还是接收方
//                if ([userModel.render.userId isEqualToString:[TICConfig shareInstance].userId]) {
//                    if ([[userdic valueForKey:@"userId"] isEqualToString:[TICConfig shareInstance].userId]) {
//                        if ([keysArr containsObject:@"shareWebRole"]) {
//                            NSString *shareWebRole = [userdic valueForKey:@"shareWebRole"] ? [userdic valueForKey:@"shareWebRole"] : @"";
//                            //发送方
//                            if ([shareWebRole isEqualToString:@"fromUser"]) {
//                                self.webType = @"0";
//                                if ([keysArr containsObject:@"shareWebName"]) {
//                                    NSString *shareWebName = [userdic valueForKey:@"shareWebName"];
//                                    self.productName = shareWebName;
//                                }
//                                if ([keysArr containsObject:@"shareWebId"]) {
//                                    if (![[userdic valueForKey:@"shareWebId"] isEqualToString:@""]) {
//                                        [self selfPushToWebView:[userdic valueForKey:@"shareWebUrl"] WebId:[userdic valueForKey:@"shareWebId"] ActionType:@"1"];
//                                    }
//                                }
//
//                            }
//                        }
//                    }
//                }
                
                for (int j = 0; j<renderNewArr.count; j++) {
                    
                    TXTUserModel *umodel = renderNewArr[j];
                    if ([umodel.render.userId isEqualToString:[userdic valueForKey:@"userId"]]) {
                        umodel.userName = [userdic valueForKey:@"userName"];
                        umodel.userRole = [userdic valueForKey:@"userRole"];
                        if ([keysArr containsObject:@"userIcon"]) {
                            umodel.userIcon = [userdic valueForKey:@"userIcon"];
                        }
                        
                        if ([umodel.userRole isEqualToString:@"owner"]) {
                            //业务员
                            if ([self.userId isEqualToString:umodel.render.userId]) {
                                [self.renderViews removeObject:umodel];
                                [self.renderViews insertObject:umodel atIndex:0];
                            }else{
                                [self.renderViews replaceObjectAtIndex:j withObject:umodel];
                            }
                        }else{
                            [self.renderViews replaceObjectAtIndex:j withObject:umodel];
                        }
                        
                        
                        break;
                    }
                }
//                for (int j = 0; j<self.manageMembersArr.count; j++) {
//
//                    TXTUserModel *manageModel = self.manageMembersArr[j];
//                    if ([manageModel.render.userId isEqualToString:[userdic valueForKey:@"userId"]]) {
//                        manageModel.userName = [userdic valueForKey:@"userName"];
//                        manageModel.userRole = [userdic valueForKey:@"userRole"];
//                        manageModel.userIcon = [userdic valueForKey:@"userIcon"];
//                        [self.manageMembersArr replaceObjectAtIndex:j withObject:manageModel];
//                        break;
//                    }
//                }
//
            }
            
          
            
//            if (self.otherShareStatus) {
//                self.isShowWhiteBoard = YES;
//                [self updateVideoView:@"insert" Index:1];
//                if (self.landscapeRoomViewController) {
//
//                }else{
//                    [self getWhiteBoard];
//                }
//
//                self.shareState = YES;
//
//                if ([self.ShareStatusUserId isEqualToString:self.userId]) {
//                    //                    self.pptView.hidden = YES;
//
//                }else{
//                    self.pptView.hidden = YES;
//                }
//                [self.shareFileButton setImage:[UIImage imageNamed:@"fileShare_select" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
//                [self.drawBackView addSubview:self.brushView];
//                [self.drawBackView addSubview:self.changeButton];
//            }else{
//                //没有大图
//                if (self.currentBigVideoModel == nil) {
//                    [self updateVideoView:@"remove" Index:1];
//                }else{
//                    NSLog(@"直接加入房间");
//                }
//            }
       
            [self reloadManageMembersArray];
            [self updateRenderViewsLayout];
            
//            if ([userModel.render.userId isEqualToString:self.userId]) {
//                if ([[result valueForKey:@"soundStatus"] boolValue]) {
//                    self.muteState = YES;
//                    [self muteAudioAction];
//                }
//            }
            
        }else{
            userModel.userName = userModel.render.userId;
            [self.renderViews replaceObjectAtIndex:(self.renderViews.count-1) withObject:userModel];
            [self reloadManageMembersArray];
            [self updateRenderViewsLayout];
        }
        
    } failure:^(NSError *error, id response) {
        userModel.userName = userModel.render.userId;
        [self.renderViews replaceObjectAtIndex:(self.renderViews.count-1) withObject:userModel];
        [self reloadManageMembersArray];
        [self updateRenderViewsLayout];
    }];
}


#pragma mark - bottomButtonsDelegate
- (void)bottomMuteClick{
    [self muteAudioAction];
}

- (void)bottomButtonClick{
    TXTGroupMemberViewController *vc = [[TXTGroupMemberViewController alloc] init];
    [self.navigationController pushViewController:self.groupMemberViewController animated:YES];
//    TXTChatViewController *vc = [[TXTChatViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    return;
    [self closeVideoAction];
}

- (void)bottomShareSceneButtonClick{
    
}

#pragma mark - action

- (void)closeVideoAction{
    for (int i = 0; i<self.renderViews.count; i++) {
        TXTUserModel *model = self.renderViews[i];
        if ([model.render.userId isEqualToString:self.userId]) {
            TXTUserModel *newModel = [[TXTUserModel alloc] init];
            newModel.render = model.render;
            newModel.showVideo = self.state;
            newModel.showAudio = model.showAudio;
            newModel.info = model.info;
            newModel.userRole = model.userRole;
            newModel.userName = model.userName;
            newModel.userIcon = model.userIcon;
            [self.renderViews replaceObjectAtIndex:i withObject:newModel];
            break;
        }
    }
    [self updateRenderViewsLayout];
    [[[TICManager sharedInstance] getTRTCCloud] muteLocalVideo:!self.state];
    [self.bottomToos changeVideoButtonStatus:self.state];
    self.state = !self.state;
}


- (void)muteAudioAction{
    for (int i = 0; i<self.renderViews.count; i++) {
        TXTUserModel *model = self.renderViews[i];
        if ([model.render.userId isEqualToString:self.userId]) {
            NSLog(@"mute_unselect == %@",model.render.userId);
            TXTUserModel *newModel = [[TXTUserModel alloc] init];
            newModel.render = model.render;
            newModel.showVideo = model.showVideo;
            newModel.showAudio = self.muteState;
            newModel.info = model.info;
            newModel.userRole = model.userRole;
            newModel.userName = model.userName;
            newModel.userIcon = model.userIcon;
            [self.renderViews replaceObjectAtIndex:i withObject:newModel];
            break;
        }
    }
    [self updateRenderViewsLayout];
    [[[TICManager sharedInstance] getTRTCCloud] muteLocalAudio:!self.muteState];
    [self.bottomToos changeAudioButtonStatus:self.muteState];
    self.muteState = !self.muteState;
}

#pragma mark - render view
//更新布局
- (void)updateRenderViewsLayout
{
    self.renderVideoView.renderArray = self.renderViews;
    NSLog(@"updateRenderViewsLayout");
//    if (self.renderViews.count == 1) {
//        self.renderVideoView.backgroundColor = [UIColor yellowColor];
//        [self.renderVideoView setVideoRenderNumber:TRTCVideoRenderNumber1 mode:TRTCVideoRenderModePortrait];
//    }else if (self.renderViews.count == 2){
//        [self.renderVideoView setVideoRenderNumber:TRTCVideoRenderNumber2 mode:TRTCVideoRenderModePortrait];
//    }
    [_renderVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(Screen_Height/4);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(Screen_Height/2.4);
    }];
    [self.renderVideoView setVideoRenderNumber:TRTCVideoRenderNumber2 mode:TRTCVideoRenderModePortrait];
}


#pragma mark - TIC event listener
-(void)onTICMemberQuit:(NSArray*)members {
    NSString *userId = members[0];
    NSLog(@"onTICMemberQuit === %@",userId);
    [self.userIdArr removeObject:userId];
    NSLog(@"移除列表");
    [self.renderViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TXTUserModel *model = obj;
        if ([model.render.userId isEqualToString:userId]) {
            [self.renderViews removeObject:model];
            [self reloadManageMembersArray];
            [self updateRenderViewsLayout];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageMembersViewControllerLeave" object:userId];
            
        }
    }];
}


-(void)onTICMemberJoin:(NSString *)userId {
    NSLog(@"onTICMemberJoin === %@",userId);
    [self.renderViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TXTUserModel *model = obj;
        if ([model.render.userId isEqualToString:userId]) {
            return;
        }
    }];
    [self.userIdArr addObject:userId];
    if ([[TICConfig shareInstance].role isEqualToString:@"owner"]) {
        self.navigationItem.rightBarButtonItem.title = @"管理成员";
    }
    TXTUserModel *userModel = [[TXTUserModel alloc] init];
    TICRenderView *render = [[TICRenderView alloc] init];
    render.userId = userId;
    render.streamType = TICStreamType_Main;
    [[[TICManager sharedInstance] getTRTCCloud] startRemoteView:userId view:render];
    userModel.render = render;
    userModel.showVideo = NO;
    userModel.showAudio = NO;
    userModel.userName = userId;
    [self.renderViews addObject:userModel];
    [self roomInfo:userModel];
}

- (void)onTICUserAudioAvailable:(NSString *)userId available:(BOOL)available{
    NSLog(@"------------------onTICUserAudioAvailable--%@",userId);
    if ([self.userIdArr containsObject:userId]) {
        for (int i = 0; i<self.renderViews.count; i++) {
            TXTUserModel *model = self.renderViews[i];
            if ([model.render.userId isEqualToString:userId]) {
                TXTUserModel *newModel = [[TXTUserModel alloc] init];
                newModel.render = model.render;
                newModel.showVideo = model.showVideo;
                newModel.showAudio = available;
                newModel.info = model.info;
                newModel.userRole = model.userRole;
                newModel.userName = model.userName;
                newModel.userIcon = model.userIcon;
                [self.renderViews replaceObjectAtIndex:i withObject:newModel];
                //更新某一个cell
                break;
            }
        }
        [self reloadManageMembersArray];
    }else{
        [self.userIdArr addObject:userId];
        TXTUserModel *userModel = [[TXTUserModel alloc] init];
        TICRenderView *render = [[TICRenderView alloc] init];
        render.userId = userId;
        render.streamType = TICStreamType_Main;
        [[[TICManager sharedInstance] getTRTCCloud] startRemoteView:userId view:render];
        userModel.render = render;
        userModel.showVideo = NO;
        userModel.showAudio = available;
        userModel.userName = userId;
        [self.renderViews addObject:userModel];
        [self roomInfo:userModel];
    }
}

- (void)onTICUserVideoAvailable:(NSString *)userId available:(BOOL)available
{
    NSLog(@"------------------onTICUserVideoAvailable==%@",userId);
    if ([self.userIdArr containsObject:userId]) {
        for (int i = 0; i<self.renderViews.count; i++) {
            TXTUserModel *model = self.renderViews[i];
            if ([model.render.userId isEqualToString:userId]) {
                TXTUserModel *newModel = [[TXTUserModel alloc] init];
                newModel.render = model.render;
                newModel.showVideo = available;
                newModel.showAudio = model.showAudio;
                newModel.info = model.info;
                newModel.userName = model.userName;
                newModel.userRole = model.userRole;
                newModel.userIcon = model.userIcon;
                [self.renderViews replaceObjectAtIndex:i withObject:newModel];
                //更新单个视频UI
         
                break;
            }
        }
        [self reloadManageMembersArray];
        [self updateRenderViewsLayout];
    }else{
        [self.userIdArr addObject:userId];
        TXTUserModel *userModel = [[TXTUserModel alloc] init];
        TICRenderView *render = [[TICRenderView alloc] init];
        render.userId = userId;
        render.streamType = TICStreamType_Main;
        [[[TICManager sharedInstance] getTRTCCloud] startRemoteView:userId view:render];
        userModel.render = render;
        userModel.showAudio = NO;
        if(available){
            userModel.showVideo = YES;
        }else{
            userModel.showVideo = NO;
        }
        userModel.userName = userId;
        [self.renderViews addObject:userModel];
        [self roomInfo:userModel];
    }
}

- (void)addNotification{
    [[TICManager sharedInstance] addIMessageListener:self];
    [[TICManager sharedInstance] addEventListener:self];
    [[TICManager sharedInstance] addStatusListener:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)setBottomToolsUI{
    //WithFrame:CGRectMake(0, Screen_Height-100, Screen_Width, 100)
    _bottomToos = [[bottomButtons alloc] init];
    [self.view addSubview:self.bottomToos];
    [_bottomToos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(100);
    }];
    _bottomToos.delegate = self;
}

- (bottomButtons *)bottomToos{
    if (!_bottomToos) {
        //WithFrame:CGRectMake(0, Screen_Height-80, Screen_Width, 80)
        
    }
    return _bottomToos;
}

- (NSMutableArray *)renderViews
{
    if(!_renderViews){
        _renderViews = [NSMutableArray array];
    }
    return _renderViews;
}

- (renderVideoView *)renderVideoView{
    if (!_renderVideoView) {
        _renderVideoView = [[renderVideoView alloc] init];
        [self.view addSubview:_renderVideoView];
        [_renderVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(Screen_Height/4);
            make.left.mas_equalTo(self.view.mas_left).offset(0);
            make.right.mas_equalTo(self.view.mas_right).offset(0);
            make.height.mas_equalTo(Screen_Height/3.5);
        }];
    }
    return _renderVideoView;
}

#pragma  mark 离开房间
- (void)onQuitClassRoom
{
    
    if ([[TICConfig shareInstance].role isEqualToString:@"owner"])  {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"您确定要结束会议吗？" preferredStyle:UIAlertControllerStyleActionSheet];
     
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"结束会议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self quit];
        }];
        [action1 setValue:[UIColor colorWithHexString:@"#FF6666"] forKey:@"_titleTextColor"];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [action2 setValue:[UIColor colorWithHexString:@"#333333"] forKey:@"_titleTextColor"];
        //把action添加到actionSheet里
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        
        //相当于之前的[actionSheet show];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }else{
        if (self.shareState) {
//            if ([self.ShareStatusUserId isEqualToString:self.userId]) {
//                [[JMToast sharedToast] showDialogWithMsg:@"当前正在共享，请结束后再试"];
//                return;
//            }
        }
        if (self.shareScene) {
            [[JMToast sharedToast] showDialogWithMsg:@"当前正在投屏，请结束后再试"];
            return;
        }
        [UIAlertUtil showAlertWithPersentViewController:self alertCallBack:^(NSInteger index) {
            if (index == 0) {
                
            }else{
                [self quit];
            }
        } title:@"" message:@"请确认是否离开会议" cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
    }
}

- (void)quit{
    TXUserDefaultsSetObjectforKey(@"leave", VideoStatus);
    NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":@"end",@"agentId":TXUserDefaultsGetObjectforKey(AgentId)};
    NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
    [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
        NSLog(@"发送消息 %d--%@",code,desc);
        [[TICManager sharedInstance] quitClassroom:NO callback:^(TICModule module, int code, NSString *desc) {
            NSLog(@"退出课堂 %d--%@",code,desc);
            [[TICManager sharedInstance] logout:^(TICModule module, int code, NSString *desc) {
                NSLog(@"TICManager登出 %d--%@",code,desc);
                
            }];
            [[[TICManager sharedInstance] getBoardController] removeDelegate:self];
            [[TICManager sharedInstance] removeIMessageListener:self];
            [[TICManager sharedInstance] removeEventListener:self];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
            [self endRecord];
        }];
    }];
}

//结束录制并结束会话
- (void)endRecord{
    NSString *serviceId = TXUserDefaultsGetObjectforKey(ServiceId);
    NSDictionary *dict = @{@"serviceId":serviceId};
    [[AFNHTTPSessionManager shareInstance] requestURL:ServiceRoom_EndRecord RequestWay:@"POST" Header:nil Body:dict params:nil isFormData:NO success:^(NSError *error, id response) {
        NSLog(@"结束录制并结束会话");
        [ZYSuspensionManager destroyWindowForKey:@"videowindow"];
    } failure:^(NSError *error, id response) {
        [ZYSuspensionManager destroyWindowForKey:@"videowindow"];
    }];
    
}

- (void)reloadManageMembersArray {
    self.groupMemberViewController.manageMembersArr = self.renderViews;
    //数据更新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageMembersViewController" object:nil];
}
#pragma  mark 横屏设置

//- (BOOL)shouldAutorotate{
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationLandscapeLeft;
//}

- (TXTGroupMemberViewController *)groupMemberViewController {
    if (!_groupMemberViewController) {
        TXTGroupMemberViewController *groupMemberViewController = [[TXTGroupMemberViewController alloc] init];
        self.groupMemberViewController = groupMemberViewController;
    }
    return _groupMemberViewController;
}

@end
