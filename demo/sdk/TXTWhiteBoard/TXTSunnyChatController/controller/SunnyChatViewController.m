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
#import "TXTCommonAlertView.h"

#import "TXTUserModel.h"
#import "TICRenderView.h"
#import "renderVideoView.h"
#import "QFAlertView.h"

#import "TXTGroupMemberViewController.h"
#import "TXTChatViewController.h"
#import "TXTWhiteBoardViewController.h"
#import "TXTNavigationController.h"
#import "TXTShareFileAlertView.h"
#import "TXTMoreView.h"
#import "TXTSmallChatView.h"
#import "TXTEmojiView.h"
#import "TXTChatInputToolBar.h"
#import "TXTSmallMessageView.h"

static NSInteger const kInputToolBarH = 62;

@interface SunnyChatViewController ()<bottomButtonsDelegate, TICEventListener, TICMessageListener, TICStatusListener, UITextViewDelegate, TXTSmallChatViewDelegate, TXTEmojiViewDelegate>
@property (nonatomic, strong) bottomButtons *bottomToos;//底部视图
@property (nonatomic, strong) NSString *userId;//主持人id
@property (strong, nonatomic) NSMutableArray *userIdArr;//房间存在人员id数组
@property (nonatomic, strong) NSMutableArray *renderViews;//房间人员数组
@property (strong, nonatomic) NSString *webType;//同屏还是被同屏
@property (strong, nonatomic) NSString *productName;//同屏产品名
@property (strong, nonatomic) NSString *webId;//同屏de id
@property (strong, nonatomic) renderVideoView *renderVideoView;//视频视图
@property (nonatomic,strong) UIButton *crossBtn;//移动机器人

@property (assign, nonatomic) BOOL state;//打开摄像头
@property (assign, nonatomic) BOOL muteState;//麦克风开关
//@property (assign, nonatomic) BOOL switchCamera;//反转镜头开关
@property (assign, nonatomic) BOOL shareState;//共享开关
@property (assign, nonatomic) BOOL shareScene;//投屏开关

@property (assign, nonatomic) BOOL hideBottomAndTop;//是否隐藏

// 成员管理
/** groupMemberViewController */
@property (nonatomic, strong) TXTGroupMemberViewController *groupMemberViewController;
/** isShowWhiteBoard */
@property (nonatomic, assign) BOOL isShowWhiteBoard;
/** whiteBoardViewController */
@property (nonatomic, strong) TXTWhiteBoardViewController *whiteBoardViewController;
/** chatViewController */
@property (nonatomic, strong) TXTChatViewController *chatViewController;
/** smallChatView */
@property (nonatomic, strong) TXTSmallChatView *smallChatView;
/** emojiView */
@property (nonatomic, strong) TXTEmojiView *emojiView;
/** coverView */
//@property (nonatomic, strong) UIView *coverView;
/** inputToolBar */
@property (nonatomic, strong) TXTChatInputToolBar *inputToolBar;
/** 当前键盘的高度 */
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;
/** 当前的contentOffSet */
@property (nonatomic, assign) CGFloat contentOffsetY;
/** smallMessageView */
@property (nonatomic, strong) TXTSmallMessageView *smallMessageView;

@end

@implementation SunnyChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"远程会议";
    
    //    //扬声器
    UIImage *speakerImg = [UIImage imageNamed:@"speaker" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
    
    //    //切换摄像头
    UIImage *cameraImg = [UIImage imageNamed:@"camera" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
    
    self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem itemWithTarget:self
                                                                        action:@selector(changeAudioRoute)
                                                                         image:speakerImg],
                                               [UIBarButtonItem itemWithTarget:self
                                                                        action:@selector(switchCamera)
                                                                         image:cameraImg]];
    //onQuitClassRoom
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onQuitClassRoom) title:@"退出" font:[UIFont qs_semiFontWithSize:15] titleColor:[UIColor colorWithHexString:@"#E19797"] highlightedColor:[UIColor colorWithHexString:@"#E19797"] titleEdgeInsets:UIEdgeInsetsMake(5, 5, -5, -5)];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#222222"];
    
    [self joinRoom];
    [self setBottomToolsUI];
    [self addNotification];
    [self initParams];
    
    [self setUpSmallChatUI];
}

/// setUpSmallChatUI
- (void)setUpSmallChatUI {
    [self.view addSubview:self.smallChatView];
    [self.smallChatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-75);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(34);
    }];

    [self.view addSubview:self.smallMessageView];
    [self.smallMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallChatView);
//        make.height.mas_equalTo(39 * 3);
        make.bottom.equalTo(self.smallChatView.mas_top).offset(-10);
        make.width.mas_equalTo(265);
    }];
    
    [self.view addSubview:self.inputToolBar];
    [self.inputToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.height.mas_equalTo(kInputToolBarH);
    }];
    
//    [self.view addSubview:self.coverView];
//    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//    [self.coverView addTarget:self action:@selector(hideKeyBoard)];
//    self.coverView.hidden = YES;
    [self.view addTarget:self action:@selector(hideKeyBoard)];
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}


/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    app.allowRotation = YES;
    if (![UIWindow isLandscape]) {
        [self updateUI:YES];
    } else {
        [self updateUI:NO];
    }
}

- (void)updateUI:(BOOL)isPortrait {
    if (isPortrait) {
        [self.smallChatView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-75);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(34);
        }];
    } else {
        [self.smallChatView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-75);
            make.width.mas_equalTo(150 + [UIApplication sharedApplication].keyWindow.safeAreaInsets.right);
            make.height.mas_equalTo(34);
        }];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
  QSLog(@"%@", textView.text);
    if (![textView.text hasSuffix:@"\n"] && textView.text.length >= 50) {
        textView.text = [textView.text substringToIndex:50];
    }
    // 1.计算textView的高度
    CGFloat textViewH = 0;
    CGFloat minHeight = 32; // textView最小的高度
    CGFloat maxHeight = 82 + 10; // textView最大的高度

    // 获取contentSize 的高度
    CGFloat contentHeight = textView.contentSize.height;
    if (contentHeight < minHeight) {
      textViewH = minHeight;
      [textView setContentInset:UIEdgeInsetsZero];
    } else if (contentHeight > maxHeight) {
      textViewH = maxHeight + 4.5;
      [textView setContentInset:UIEdgeInsetsMake(-5, 0, -3.5, 0)];
    } else {
      if (contentHeight - (minHeight + 7) < 0.01) {
          [textView setContentInset:UIEdgeInsetsMake(-4.5, 0, -4.5, 0)];
          textViewH = minHeight;
      } else {
          textViewH = contentHeight - 8;
          [textView setContentInset:UIEdgeInsetsMake(-4.5, 0, -4.5, 0)];
      }
    }
    // 2.监听send事件--判断最后一个字符串是不是换行符
    if ([textView.text hasSuffix:@"\n"]) {
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, textView.text.length)];
      if (textView.text.length > 0) {
          if ([NSString isEmpty:textView.text]) {
          } else {
              [self.view endEditing:YES];
              [self sendText:textView.text];
          }
      } else {
      }
      // 清空textView的文字
      textView.text = nil;
      [textView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
      
      // 发送时，textViewH的高度为33
      textViewH = minHeight;
      [textView scrollRangeToVisible:textView.selectedRange];
    }
    // 3.调整整个InputToolBar 的高度
    [self.inputToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(textViewH + 30);
    }];
    CGFloat changeH = textViewH - self.previousTextViewContentHeight;
    if (changeH != 0) {
    // 加个动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        // 4.记光标回到原位
        // 下面这几行代码需要写在[self.view layoutIfNeeded]后面，不然系统会自动调整为位置
        if (contentHeight < maxHeight) {
            [textView setContentOffset:CGPointZero animated:YES];
            [textView scrollRangeToVisible:textView.selectedRange];
        }
    }];
      self.previousTextViewContentHeight = textViewH;
    }
    if (contentHeight > maxHeight) {
        [UIView animateWithDuration:0.2 animations:^{
            if (self.contentOffsetY) {
                if (textView.selectedRange.location != textView.text.length && textView.contentOffset.y != self.contentOffsetY) return;
            }
            [textView setContentOffset:CGPointMake(0.0, textView.contentSize.height - textView.frame.size.height - 3.5)];
            self.contentOffsetY = textView.contentOffset.y;
        }];
        [textView scrollRangeToVisible:textView.selectedRange];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)initParams{
    TXTNavigationController *navigationController = (TXTNavigationController *)self.navigationController;
    if (navigationController.interfaceOrientation == UIInterfaceOrientationPortrait) {
        NSString *portrait = [NSString stringWithFormat:@"%ld",(long)TRTCVideoRenderModePortrait];
        TXUserDefaultsSetObjectforKey(portrait, Direction);
    }else{
        NSString *portrait = [NSString stringWithFormat:@"%ld",(long)TRTCVideoRenderModeLandscape];
        TXUserDefaultsSetObjectforKey(portrait, Direction);
    }
    self.hideBottomAndTop = NO;
    
//    TXTUserModel *model = self.renderViews[0];
//    TXTUserModel *newModel = [[TXTUserModel alloc] init];
//    newModel.render = model.render;
//    newModel.showVideo = YES;
//    newModel.showAudio = model.showAudio;
//    newModel.info = model.info;
//    newModel.userRole = @"";
//    newModel.userName = model.userName;
//    newModel.userIcon = model.userIcon;
//
//    TXTUserModel *newModel1 = [[TXTUserModel alloc] init];
//    newModel1.render = model.render;
//    newModel1.showVideo = NO;
//    newModel1.showAudio = model.showAudio;
//    newModel1.info = model.info;
//    newModel1.userRole = @"";
//    newModel1.userName = model.userName;
//    newModel1.userIcon = model.userIcon;
//
//    [self.renderViews addObject:newModel];
//    [self.renderViews addObject:newModel1];
//    [self.renderViews addObject:newModel1];
//    [self.renderViews addObject:newModel1];
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
    userModel.showVideo = YES;
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
            self.isShowWhiteBoard = [[result valueForKey:@"shareStatus"] boolValue];
            
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
            
            
            
            if (self.isShowWhiteBoard) {
                self.isShowWhiteBoard = YES;
                [self getWhiteBoard:self.isShowWhiteBoard];
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
            } else {
//                //没有大图
//                if (self.currentBigVideoModel == nil) {
//                    [self updateVideoView:@"remove" Index:1];
//                }else{
//                    NSLog(@"直接加入房间");
//                }
            }
            
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
//静音
- (void)bottomMuteClick{
    [self muteAudioAction];
}

- (void)bottomButtonClick {
    [self closeVideoAction];
}
//文件分享
- (void)bottomShareFileButtonClick{
    TXTShareFileAlertView *shareFileAlertView = [[TXTShareFileAlertView alloc] init];
    shareFileAlertView.fileBlock = ^{
    };
    shareFileAlertView.whiteBoardBlock = ^{
        [self getWhiteBoard:self.isShowWhiteBoard];
    };
    [shareFileAlertView show];
}
/// getWhiteBoard
- (void)getWhiteBoard:(BOOL)isShowWhiteBoard {
    self.whiteBoardViewController.isShowWhiteBoard = isShowWhiteBoard;
    __weak __typeof(self)weakSelf = self;
    self.whiteBoardViewController.closeBlock = ^{
        weakSelf.isShowWhiteBoard = NO;
        [weakSelf.whiteBoardViewController.view removeFromSuperview];
        weakSelf.whiteBoardViewController = nil;
    };
    [self addChildViewController:self.whiteBoardViewController];
    [self.view insertSubview:self.whiteBoardViewController.view belowSubview:self.smallChatView];
    [self.whiteBoardViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

//成员
- (void)bottomMembersButtonClick{
//    TXTGroupMemberViewController *vc = [[TXTGroupMemberViewController alloc] init];
//    vc.manageMembersArr = self.renderViews;
//    self.groupMemberViewController = vc;
//    vc.closeBlock = ^{
//        self.groupMemberViewController = nil;
//    };
//    [self.navigationController pushViewController:vc animated:YES];
    // 添加成员页面
    __weak __typeof(self)weakSelf = self;
    self.groupMemberViewController.closeBlock = ^{
        [weakSelf.groupMemberViewController.view removeFromSuperview];
        weakSelf.groupMemberViewController = nil;
    };
    [self addChildViewController:self.groupMemberViewController];
    [self.view addSubview:self.groupMemberViewController.view];
    self.groupMemberViewController.manageMembersArr = self.renderViews;
    [self.groupMemberViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
//录制
- (void)bottomShareSceneButtonClick{
    if (self.renderViews.count == 1) {
        NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":MMAgreeStartRecord,@"userId":self.userId};
        NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
        [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
            NSLog(@"发消息");
        }];
    }else{
        TXTCommonAlertView *alert = [TXTCommonAlertView alertWithTitle:@"本次录制需获得全部参会人员授权确认后可进行录制，请您确认" message:@"" leftBtnStr:@"取消" rightBtnStr:@"确认" leftColor:nil rightColor:nil];
        alert.sureBlock = ^{
            [TXTCommonAlertView hide];
            NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":MMStartRecordFromHost,@"userId":self.userId};
            NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
            [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
                NSLog(@"发消息");
            }];
        };
    }
    
}
//更多
- (void)bottomMoreActionButtonClick{
    TXTMoreView *moreView = [[TXTMoreView alloc] init];
    moreView.chatBlock = ^{
        // 添加聊天页面
        __weak __typeof(self)weakSelf = self;
        self.chatViewController.closeBlock = ^{
            [weakSelf.chatViewController.view removeFromSuperview];
            weakSelf.chatViewController = nil;
        };
        [self addChildViewController:self.chatViewController];
        [self.view addSubview:self.chatViewController.view];
        [self.chatViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    };
    [moreView show];
}

#pragma mark - action
///开关摄像头
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

///开关麦克风
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
//    [self updateRenderViewsLayout];
    TRTCVolumeInfo *info = [[TRTCVolumeInfo alloc] init];
    info.userId = self.userId;
    info.volume = 0;
    [self updateRenderViewsLayoutWithIndex:0 userVolumes:@[info]];
    [[[TICManager sharedInstance] getTRTCCloud] muteLocalAudio:!self.muteState];
    [self.bottomToos changeAudioButtonStatus:self.muteState];
    self.muteState = !self.muteState;
}

///翻转摄像头
- (void)switchCamera{
    [[[TICManager sharedInstance] getTRTCCloud] switchCamera];
}

///切换扬声器
- (void)changeAudioRoute{
    
}

///同屏
- (void)selfPushToWebView:(NSString *)url WebId:(nonnull NSString *)webId ActionType:(NSString *)actionType{
    if ([webId isEqualToString:@""] || [self.productName isEqualToString:@""]) {
        [[JMToast sharedToast] showDialogWithMsg:@"同屏链接不存在"];
        return;
    }
    
    //    UIViewController *currentvc = [[AFNHTTPSessionManager shareInstance] getCurrentVC];
    //    if ([currentvc isKindOfClass:[showWebViewController class]]) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
    //    self.webId = webId;
    //    NSLog(@"selfPushToWebView");
    //    self.backView.hidden = YES;
    //    self.shareState = YES;
    //    [self.webViewListController removeFromParentViewController];
    //    [self.webViewListController.view removeFromSuperview];
    //    self.drawBackView.hidden = YES;
    //    self.pptView.hidden = YES;
    //    self.showWebViewController.url = url;
    //    self.showWebViewController.webId = webId;
    //    self.showWebViewController.userModel = self.renderViews[0];
    //    self.showWebViewController.productName = self.productName;
    //    self.showWebViewController.actionType = actionType;
    //    self.showWebViewController.type = self.webType;
    //
    //    [self.navigationController pushViewController:self.showWebViewController animated:YES];
    
}
///结束同屏
- (void)hideshowview{
    //    self.backView.hidden = YES;
    //    self.otherShareStatus = NO;
    //    [self.webViewListController removeFromParentViewController];
    //    [self.webViewListController.view removeFromSuperview];
    //    [self.shareFileButton setImage:[UIImage imageNamed:@"fileShare_unselect" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    //    self.shareState = NO;
}


- (void)showAlertTitle:(NSString *)title Message:(NSString *)message cancleTitle:(NSString *)cancleTitle sureTitle:(NSString *)sureTitile{
    //    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    //     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //     NSLog(@"点击了Cancel");
    //     [alertVC dismissViewControllerAnimated:YES completion:nil];
    //     }];
    //     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //     NSLog(@"点击了OK");
    ////     [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLoginUserKey];
    //     [alertVC dismissViewControllerAnimated:YES completion:nil];
    //     }];
    //     //修改title
    //     NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    //     [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, 2)];
    //     [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 2)];
    //     [alertVC setValue:alertControllerStr forKey:@"attributedTitle"];
    //     //修改message
    //     NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:desStr];
    //     [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSRangeFromString(desStr)];
    //     [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSRangeFromString(desStr)];
    //     [alertVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    //     //修改按钮字体颜色
    //     [cancelAction setValue:[UIColor colorWithHexString:@"#666666"] forKey:@"titleTextColor"];
    //     [okAction setValue:[UIColor colorWithHexString:@"#E6B980"] forKey:@"titleTextColor"];
    //     [alertVC addAction:cancelAction];
    //     [alertVC addAction:okAction];
    //     [self presentViewController:alertVC animated:YES completion:nil];
}

//横竖屏切换
- (void)btnAction{
    TXTNavigationController *navigationController = (TXTNavigationController *)self.navigationController;
    //切换rootViewController的旋转方向
    if (navigationController.interfaceOrientation == UIInterfaceOrientationPortrait) {
        navigationController.interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
        navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeLeft;
        //设置屏幕的转向为横屏
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
        NSString *portrait = [NSString stringWithFormat:@"%ld",(long)TRTCVideoRenderModeLandscape];
        TXUserDefaultsSetObjectforKey(portrait, Direction);
    }
    else {
        navigationController.interfaceOrientation = UIInterfaceOrientationPortrait;
        navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
        //设置屏幕的转向为竖屏
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
        NSString *portrait = [NSString stringWithFormat:@"%ld",(long)TRTCVideoRenderModePortrait];
        TXUserDefaultsSetObjectforKey(portrait, Direction);
    }
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    [self updateRenderViewsLayout];
    [self.bottomToos updateButtons];
}


#pragma mark - render view
//更新布局
- (void)updateRenderViewsLayout{
    self.renderVideoView.renderArray = self.renderViews;
    
    NSString *direction = TXUserDefaultsGetObjectforKey(Direction);
    NSLog(@"Direction = %@-%lu",direction,(unsigned long)self.renderViews.count);
    NSInteger directionInt = [direction integerValue];
    
    NSLog(@"updateRenderViewsLayout");
    if (directionInt == TRTCVideoRenderModeLandscape) {
        [_renderVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        }];
    }else{
        [_renderVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(Screen_Height/4);
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.height.mas_equalTo(Adapt(230)+Adapt(90));
        }];
    }
    [self.renderVideoView setVideoRenderNumber:(self.renderViews.count - 1) mode:directionInt];
}

//更新某一个view
- (void)updateRenderViewsLayoutWithIndex:(NSInteger)index userVolumes:(NSArray<TRTCVolumeInfo *> *)userVolumes{
    NSString *direction = TXUserDefaultsGetObjectforKey(Direction);
//    NSLog(@"Direction = %@-%lu",direction,(unsigned long)self.renderViews.count);
    NSInteger directionInt = [direction integerValue];
    [self.renderVideoView changeViewNumber:(self.renderViews.count - 1) mode:directionInt Index:index userVolumes:userVolumes];
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
                TRTCVolumeInfo *info = [[TRTCVolumeInfo alloc] init];
                info.userId = userId;
                info.volume = 0;
                [self updateRenderViewsLayoutWithIndex:0 userVolumes:@[info]];
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

- (void)onTICUserVoiceVolume:(NSArray<TRTCVolumeInfo *> *)userVolumes totalVolume:(NSInteger)totalVolume{
    [self updateRenderViewsLayoutWithIndex:100 userVolumes:userVolumes];
//    NSMutableArray *arr = [NSMutableArray arrayWithArray:userVolumes];
//    self.userVolumes = [NSMutableArray arrayWithArray:userVolumes];
//    self.renderViewCollectionView.userVolumesArray = arr;
//    for (TRTCVolumeInfo *info in userVolumes) {
//        if (self.currentBigVideoModel != nil && [self.currentBigVideoModel.render.userId isEqualToString:info.userId]) {
//            [self setAudioUI];
//            //            self.muteImageView = [self configWithMute:info.volume subView:self.muteImageView];
//        }
//    }
}


- (void)onTICRecvMessage:(TIMMessage *)message{
    int cnt = [message elemCount];
    for (int i = 0; i < cnt; i++) {
        TIMElem * elem = [message getElem:i];
        NSLog(@"%@",[elem description]);
        for (UIView *view in [ZYSuspensionManager windowForKey:@"videowindow"].subviews) {
            if ([view isKindOfClass:[QFAlertView class]]) {
                [view removeFromSuperview];
            }
        }
        
        
        if ([elem isKindOfClass:[TIMTextElem class]]) {
            TIMTextElem * text_elem = (TIMTextElem * )elem;
            NSLog(@"onTICRecvMessage == %@",text_elem.text);
            NSDictionary *dict = [[TXTCommon sharedInstance] dictionaryWithJsonString:text_elem.text];
            NSString *type = [dict valueForKey:@"type"];
            NSString *serviceId = [dict valueForKey:@"serviceId"];
            NSDictionary *data = [dict valueForKey:@"data"];
            //推送成功
            if ([type isEqualToString:@"wxPushWebFileSuccess"]) {
                NSLog(@"//推送成功");
                NSString *userId = [dict valueForKey:@"userId"];
                if ([userId isEqualToString:[TICConfig shareInstance].userId]) {
                    [[JMToast sharedToast] showDialogWithMsg:@"推送成功"];
                }
            }
            //参会人点击同意录制按钮
            if ([type isEqualToString:MMAgreeStartRecord]) {
                NSLog(@"参会人点击同意录制按钮");
                NSString *userId = [dict valueForKey:@"userId"];
                if ([userId isEqualToString:[TICConfig shareInstance].userId]) {
                    //同意录制按钮变色
                }
            }
            //参会人点击取消按钮
            if ([type isEqualToString:MMRefuseStartRecord]) {
                NSLog(@"参会人点击取消按钮");
                NSString *userId = [dict valueForKey:@"userId"];
                if ([userId isEqualToString:[TICConfig shareInstance].userId]) {
                    //弹框，点击取消按钮,结束会议
                }
            }
            //同屏
            if ([type isEqualToString:@"wxShareWebFile"]) {
                NSLog(@"同屏");
                NSString *userId = [dict valueForKey:@"userId"];
                if ([userId isEqualToString:[TICConfig shareInstance].userId]) {
                    NSString *webURL = [dict valueForKey:@"webUrl"];
                    NSString *webId = [dict valueForKey:@"webId"];
                    self.webType = [dict valueForKey:@"fromId"];
                    self.productName = [dict valueForKey:@"fileName"];
                    [self selfPushToWebView:webURL WebId:webId ActionType:@"1"];
                }
                
            }
            
            //结束同屏
            if ([type isEqualToString:@"wxShareWebFileEnd"]) {
                NSLog(@"同屏");
                NSString *webURL = [dict valueForKey:@"webUrl"];
                NSString *webId = [dict valueForKey:@"webId"];
                NSString *userId = [dict valueForKey:@"userId"];
                NSString *fromUserId = [dict valueForKey:@"fromUserId"];
                NSString *toUserId = [dict valueForKey:@"toUserId"];
                
                if ([fromUserId isEqualToString:[TICConfig shareInstance].userId]) {
                    NSDictionary *bodydic = @{@"webId":self.webId,@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"userId":userId};
                    [[AFNHTTPSessionManager shareInstance] requestURL:ShareWebs_Stop RequestWay:@"POST" Header:nil Body:bodydic params:nil isFormData:NO success:^(NSError *error, id response) {
                        NSString *errCode = [response valueForKey:@"errCode"];
                        if ([errCode intValue] == 0) {
                            [self.navigationController popViewControllerAnimated:YES];
                            [self hideshowview];
                        }
                    } failure:^(NSError *error, id response) {
                        
                    }];
                    [[JMToast sharedToast] showDialogWithMsg:@"对方已结束同屏"];
                }
                if ([toUserId isEqualToString:[TICConfig shareInstance].userId]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self hideshowview];
                    [[JMToast sharedToast] showDialogWithMsg:@"对方已结束同屏"];
                }
                
                
            }
            
            //共享白板
            if ([type isEqualToString:@"shareWhiteboard"]) {
                NSLog(@"shareWhiteboard");
                //                self.ShareStatusUserId = [dict valueForKey:@"shareUserId"];
                //                [self updateVideoView:@"insert" Index:self.renderViews.count];
                //                [self getWhiteBoard];
                //                self.isShowWhiteBoard = YES;
                //                self.otherShareStatus = YES;
                //                //                self.shareState = YES;
                //                self.pptView.hidden = YES;
                //                [self.drawBackView addSubview:self.brushView];
                //                [self.drawBackView addSubview:self.changeButton];
            }
            //结束共享白板
            if ([type isEqualToString:@"endWhiteboard"]) {
                //                if (self.landscapeRoomViewController) {
                //                    [self.landscapeRoomViewController dismissViewControllerAnimated:YES completion:nil];
                //                }
                //                self.ShareStatusUserId = [dict valueForKey:@"shareUserId"];
                //                [self updateVideoView:@"remove" Index:1];
                //                self.isShowWhiteBoard = NO;
                //                [self removeWhiteBoard];
                //                [[[TICManager sharedInstance] getBoardController] reset];
                //                [self.brushView removeFromSuperview];
                //                self.otherShareStatus = NO;
                //                [self.shareFileButton setImage:[UIImage imageNamed:@"fileShare_unselect" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            }
            
            //静音muteAudio
            if ([type isEqualToString:@"muteAudio"]) {
                NSLog(@"静音");
                NSArray *usersArr = [dict valueForKey:@"users"];
                for (NSDictionary *dict in usersArr) {
                    NSString *userid = [dict valueForKey:@"userId"];
                    if ([userid isEqualToString:[TICConfig shareInstance].userId]) {
                        self.muteState = ![[dict valueForKey:@"muteAudio"] boolValue];
                        [self muteAudioAction];
                    }
                    
                }
                
            }
            //摄像头
            if ([type isEqualToString:@"muteVideo"]) {
                NSLog(@"摄像头");
                NSArray *usersArr = [dict valueForKey:@"users"];
                for (NSDictionary *dict in usersArr) {
                    NSString *userid = [dict valueForKey:@"userId"];
                    if ([userid isEqualToString:[TICConfig shareInstance].userId]) {
                        self.state = ![[dict valueForKey:@"muteVideo"] boolValue];
                        [self closeVideoAction];
                    }
                    
                }
                
            }
            //客户拒绝加入房间
            if ([type isEqualToString:@"notifyRefused"]) {
                NSLog(@"客户拒绝加入房间");
                NSDictionary *dataDict = [dict valueForKey:@"data"];
                if ([[dataDict valueForKey:@"inviteAccount"] isEqualToString:[TICConfig shareInstance].userId]) {
                    [[JMToast sharedToast] showDialogWithMsg:[NSString stringWithFormat:@"%@拒绝了您的邀请,请稍后再试",[dataDict valueForKey:@"userName"]]];
                }
            }
            //通知延长
            //            if ([[TICConfig shareInstance].role isEqualToString:@"owner"]) {
            //                if (!self.sendMessage) {
            //                    return;
            //                }
            //                UIWindow *currentWindow = [ZYSuspensionManager windowForKey:@"videowindow"];
            //
            //                //通知延长
            //                if ([type isEqualToString:@"notifyExtend"]) {
            //                    if (currentWindow.frame.size.width < Screen_Width) {
            //                        NSLog(@"小屏中%f-%f",currentWindow.frame.size.width,Screen_Width);
            //                        return;
            //                    }
            //                    for (UIView *view in [ZYSuspensionManager windowForKey:@"videowindow"].subviews) {
            //                        if ([view isKindOfClass:[QFAlertView class]]) {
            //                            [view removeFromSuperview];
            //                        }
            //                    }
            //                    float notifyExtendTime = [[data valueForKey:@"notifyExtendTime"] floatValue];
            //                    NSInteger notifyExtendTimeMin = notifyExtendTime / 60 ;//房间通知延长时剩余时间/秒
            //                    float extendRoomTime = [[data valueForKey:@"extendRoomTime"] floatValue];//房间单次延长时间/秒
            //                    NSInteger extendRoomTimeMin = extendRoomTime / 60 ;
            //                    [[QFAlertView alertViewTitle:[NSString stringWithFormat:@"距离会议结束还有%d分钟,",notifyExtendTimeMin] des:[NSString stringWithFormat:@"确认延长有效时间%d分钟!",extendRoomTimeMin] leftTitle:@"取消延长" rightTitle:@"延长会话" leftAction:^{
            //
            //                    } rightAction:^{
            //                        [self extendTime:serviceId];
            //                    }] show];
            //                }
            //                //通知结束
            //                else if ([type isEqualToString:@"notifyEnd"]){
            //                    if (!self.sendMessage) {
            //                        return;
            //                    }
            //                    float extendRoomTime = [[data valueForKey:@"extendRoomTime"] floatValue];//房间单次延长时间/秒
            //                    NSInteger extendRoomTimeMin = extendRoomTime / 60 ;
            //                    NSInteger notifyEndTime = [[data valueForKey:@"notifyEndTime"] intValue];////房间通知延长时剩余时间/秒
            //                    __block NSInteger timeout = notifyEndTime +1;
            //                    dispatch_source_t _timer;
            //                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //                    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            //                    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
            //                    dispatch_source_set_event_handler(_timer, ^{
            //                        if (timeout == 0) {
            //                            dispatch_source_cancel(_timer);
            //                            dispatch_async(dispatch_get_main_queue(), ^{
            //                                NSLog(@"计时结束");
            //                                for (UIView *view in self.view.subviews) {
            //                                    if ([view isKindOfClass:[QFAlertView class]]) {
            //                                        [view removeFromSuperview];
            //                                    }
            //                                }
            //                                [self quit];
            //                            });
            //                        }else {
            //                            timeout--;
            //                        }
            //                    });
            //                    dispatch_resume(_timer);
            //                    if (currentWindow.frame.size.width < Screen_Width) {
            //                        NSLog(@"小屏中%f-%f",currentWindow.frame.size.width,Screen_Width);
            //                        return;
            //                    }
            //                    for (UIView *view in [ZYSuspensionManager windowForKey:@"videowindow"].subviews) {
            //                        if ([view isKindOfClass:[QFAlertView class]]) {
            //                            [view removeFromSuperview];
            //                        }
            //                    }
            //                    [[QFAlertView alertViewTitle:@"会议有效时间已用尽" msg:[NSString stringWithFormat:@"确认延长有效时间%d分钟?",extendRoomTimeMin] des:[NSString stringWithFormat:@"(若%d秒内无操作将自动结束会话)",notifyEndTime] leftTitle:[NSString stringWithFormat:@"结束会话(%ds)",notifyEndTime] rightTitle:@"延长会话" time:notifyEndTime leftAction:^{
            //                        dispatch_source_cancel(_timer);
            //                        [self quit];
            //                    } rightAction:^{
            //                        dispatch_source_cancel(_timer);
            //                        [self extendTime:serviceId];
            //                    }] show];
            //
            //
            //                }else{
            //                    break;
            //                }
            //
            //            }else{
            //                if ([type isEqualToString:@"end"]) {
            //                    [self participantQuit];
            //                }
            //            }
            
        }
    }
}

- (void)inputKeyboardWillShow:(NSNotification *)noti {
    if (![self.inputToolBar.textView isFirstResponder]) return;
    self.inputToolBar.hidden = NO;
    //1.获取键盘高度
    //1.1获取键盘结束时候的位置
    CGRect kbEndFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbEndFrame.size.height;
    CGFloat animationDuration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    QSLog(@"%f........", animationDuration);
    // 2.更改inputToolBar 底部约束
    [self.inputToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kbHeight);
    }];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark 键盘退出时会触发的方法
- (void)inputKeyboardWillHide:(NSNotification *)noti {
   CGFloat animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
   //inputToolbar恢复原位
   [self.inputToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
       make.bottom.mas_equalTo(0);
   }];
   // 添加动画
   [UIView animateWithDuration:animationDuration animations:^{
       [self.view layoutIfNeeded];
       self.inputToolBar.hidden = YES;
   }];
}

- (void)smallChatViewDidClickEmoji:(UIButton *)btn {
//    self.emojiView.hidden = NO;
   [self.emojiView showFromView:btn];
}

- (void)emojiViewDidClickEmoji:(NSString *)emoji {
   [self sendText:emoji];
//    self.emojiView.hidden = YES;
   [self.emojiView dismiss];
}

#pragma mark - 🎬event response
- (void)sendText:(NSString *)text {
  [self prepareTextMessage:text];
}
#pragma mark ----发送文本消息
- (void)prepareTextMessage:(NSString *)text {
    if ([text isEqualToString:@""] || text == nil) {
        return;
    }
    NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),
                                  @"type":@"wxIM",
                                  @"userId":[TICConfig shareInstance].userId,
                                  @"userName":TXUserDefaultsGetObjectforKey(Agent),
                                  @"content":text};
    NSString *str = [NSString objectToJsonString:messagedict];
    
    V2TIMMessage *message = [[V2TIMManager sharedInstance] createTextMessage:str];
    NSString *classId = [NSString stringWithFormat:@"%@",TXUserDefaultsGetObjectforKey(RoomId)];
    
//    [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
//
//    }];
    
   NSString *msgID = [[V2TIMManager sharedInstance] sendMessage:message receiver:nil groupID:classId priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:nil succ:^{
        QSLog(@"发送成功");
       [self.smallMessageView addMessage:str];
    } fail:^(int code, NSString *desc) {

    }];
}


/// showKeyBoard
- (void)showKeyBoard {
    self.inputToolBar.hidden = NO;
    [self.inputToolBar.textView becomeFirstResponder];
}

- (void)addNotification{
    [[TICManager sharedInstance] addIMessageListener:self];
    [[TICManager sharedInstance] addEventListener:self];
    [[TICManager sharedInstance] addStatusListener:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma  mark --懒加载

- (void)setBottomToolsUI{
    //WithFrame:CGRectMake(0, Screen_Height-100, Screen_Width, 100)
    _bottomToos = [[bottomButtons alloc] init];
    [self.view addSubview:self.bottomToos];
    [_bottomToos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(Adapt(60) + safeAreaBottom);
    }];
    _bottomToos.delegate = self;
    [self.view bringSubviewToFront:_bottomToos];
    
    _crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_crossBtn];
    [_crossBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-Adapt(15));
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(self.hideBottomAndTop ? -Adapt(15) : -(Adapt(15+60)));
        make.width.mas_equalTo(Adapt(38));
        make.height.mas_equalTo(Adapt(38));
    }];
    NSString *direction = TXUserDefaultsGetObjectforKey(Direction);
    NSString *imageNameStr = ( direction = @"0" )? @"Landscape-Portrait" : @"Portrait-Landscape";
    [_crossBtn setImage:[UIImage imageNamed:imageNameStr inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    //     _crossBtn.frame = CGRectMake(15, 0, 50, 50);
    [_crossBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
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
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.height.mas_equalTo(Adapt(230)+Adapt(90));//Screen_Height/3.5
        }];
        [self.view sendSubviewToBack:_renderVideoView];
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
        //切为竖屏
//        TXTNavigationController *navigationController = (TXTNavigationController *)self.navigationController;
//        //切换rootViewController的旋转方向
//        navigationController.interfaceOrientation = UIInterfaceOrientationPortrait;
//        navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
//        //设置屏幕的转向为横屏
//        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
//        NSString *portrait = [NSString stringWithFormat:@"%ld",(long)TRTCVideoRenderModePortrait];
//        TXUserDefaultsSetObjectforKey(portrait, Direction);
//        //刷新
//        [UIViewController attemptRotationToDeviceOrientation];
//        [self updateRenderViewsLayout];
//        [self.bottomToos updateButtons];
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

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

- (TXTGroupMemberViewController *)groupMemberViewController {
    if (!_groupMemberViewController) {
        TXTGroupMemberViewController *groupMemberViewController = [[TXTGroupMemberViewController alloc] init];
        self.groupMemberViewController = groupMemberViewController;
    }
    return _groupMemberViewController;
}
- (TXTWhiteBoardViewController *)whiteBoardViewController {
    if (!_whiteBoardViewController) {
        TXTWhiteBoardViewController *whiteBoardViewController = [[TXTWhiteBoardViewController alloc] init];
        self.whiteBoardViewController = whiteBoardViewController;
    }
    return _whiteBoardViewController;
}
- (TXTChatViewController *)chatViewController {
    if (!_chatViewController) {
        TXTChatViewController *chatViewController = [[TXTChatViewController alloc] init];
        self.chatViewController = chatViewController;
    }
    return _chatViewController;
}

- (TXTSmallChatView *)smallChatView {
    if (!_smallChatView) {
        TXTSmallChatView *smallChatView = [[TXTSmallChatView alloc] init];
        smallChatView.cornerRadius = 5;
        [smallChatView addTarget:self action:@selector(showKeyBoard) forControlEvents:UIControlEventTouchUpInside];
        smallChatView.delegate = self;
        self.smallChatView = smallChatView;
    }
    return _smallChatView;
}
- (TXTEmojiView *)emojiView {
    if (!_emojiView) {
        TXTEmojiView *emojiView = [[TXTEmojiView alloc] init];
//        emojiView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.74];
//        emojiView.cornerRadius = 8;
        emojiView.delegate = self;
        self.emojiView = emojiView;
    }
    return _emojiView;
}
//- (UIView *)coverView {
//    if (!_coverView) {
//        UIView *coverView = [[UIView alloc] init];
////        coverView.backgroundColor = [UIColor colorWithHexString:@"D70110"];
//        self.coverView = coverView;
//    }
//    return _coverView;
//}
- (TXTChatInputToolBar *)inputToolBar {
    if (!_inputToolBar) {
        TXTChatInputToolBar *inputToolBar = [[TXTChatInputToolBar alloc] init];
        inputToolBar.hidden = YES;
        inputToolBar.textView.delegate = self;
        self.inputToolBar = inputToolBar;
    }
    return _inputToolBar;
}

- (TXTSmallMessageView *)smallMessageView {
    if (!_smallMessageView) {
        TXTSmallMessageView *smallMessageView = [[TXTSmallMessageView alloc] init];
        smallMessageView.backgroundColor = [UIColor clearColor];
        self.smallMessageView = smallMessageView;
    }
    return _smallMessageView;
}

@end
