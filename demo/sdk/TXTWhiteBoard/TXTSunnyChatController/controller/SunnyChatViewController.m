//
//  SunnyChatViewController.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2022/10/21.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "SunnyChatViewController.h"
#import "bottomButtons.h"
#import "TXTTopButtons.h"
#import "UIBarButtonItem+SXCreate.h"
#import "UINavigationSXFixSpace.h"
#import "TXTCommon.h"
#import "ZYSuspensionManager.h"
#import "TXTCommonAlertView.h"

#import "TXTUserModel.h"
#import "TICRenderView.h"
#import "renderVideoView.h"
#import "QFAlertView.h"

#import "TXTStatusBar.h"
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
#import "QSTapGestureRecognizer.h"
#import "showWebViewController.h"

static NSInteger const kInputToolBarH = 62;

@interface SunnyChatViewController ()<bottomButtonsDelegate, TXTTopButtonsDelegate, TICEventListener, TICMessageListener, TICStatusListener, UITextViewDelegate, TXTSmallChatViewDelegate, TXTEmojiViewDelegate, TXTGroupMemberViewControllerDelegate, showWebViewControllerDelegate, TXTChatInputToolBarDelegate>
@property (nonatomic, strong) bottomButtons *bottomToos;//底部视图
/** navView */
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) TXTTopButtons *topToos;//导航栏视图
@property (nonatomic, strong) TXTStatusBar *statusToos;//导航栏视图
@property (nonatomic, strong) UIImageView *bgImageView;//背景图

@property (nonatomic, strong) NSString *userId;//主持人id
@property (strong, nonatomic) NSMutableArray *userIdArr;//房间存在人员id数组
@property (nonatomic, strong) NSMutableArray *renderViews;//房间人员数组
@property (strong, nonatomic) NSString *webType;//同屏还是被同屏
@property (strong, nonatomic) NSString *productName;//同屏产品名
@property (strong, nonatomic) NSString *webId;//同屏de id
@property (strong, nonatomic) renderVideoView *renderVideoView;//视频视图
@property (nonatomic,strong) UIButton *crossBtn;//横竖屏按钮

@property (assign, nonatomic) BOOL state;//打开摄像头
@property (assign, nonatomic) BOOL muteState;//麦克风开关
//@property (assign, nonatomic) BOOL switchCamera;//反转镜头开关
@property (assign, nonatomic) BOOL shareState;//共享开关
@property (assign, nonatomic) BOOL shareScene;//投屏开关

@property (assign, nonatomic) BOOL hideBottomAndTop;//是否隐藏
@property (nonatomic, assign) NSInteger count;//隐藏tab+nav时间
@property (nonatomic, assign) BOOL isSpeak;//是否是扬声器

// 成员管理
/** groupMemberViewController */
@property (nonatomic, strong) TXTGroupMemberViewController *groupMemberViewController;
/** isShowWhiteBoard */
@property (nonatomic, assign) BOOL isShowWhiteBoard;
/** whiteBoardViewController */
@property (nonatomic, strong) TXTWhiteBoardViewController *whiteBoardViewController;
/** 是否当前展示白板 */
@property (nonatomic, assign) BOOL isWhite;
/** chatViewController */
@property (nonatomic, strong) TXTChatViewController *chatViewController;
/** smallChatView */
@property (nonatomic, strong) TXTSmallChatView *smallChatView;
/** emojiView */
@property (nonatomic, strong) TXTEmojiView *emojiView;
/** coverView */
@property (nonatomic, strong) UIView *coverView;
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
    self.view.backgroundColor = [UIColor colorWithHexString:@"#222222"];
    [self joinRoom];
    [self addNotification];
    [self initParams];
//    [self hiddenTabAndNav];
    
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
    }];
    [self.navView addSubview:self.statusToos];
    [self.statusToos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    [self.navView addSubview:self.topToos];
    [self.topToos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(Adapt(60));
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.topToos.mas_bottom).offset(0);
    }];
    
    [self setBottomToolsUI];
    [self setUpSmallChatUI];
    
    QSTapGestureRecognizer *contentviewTap = [[QSTapGestureRecognizer alloc] initWithTarget:self action:@selector(clickContentView)];
    [self.view addGestureRecognizer:contentviewTap];
    
    
    TXTNavigationController *navigationController = (TXTNavigationController *)self.navigationController;
    //切换rootViewController的旋转方向
    if (navigationController.interfaceOrientation == UIInterfaceOrientationPortrait) {
        navigationController.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
        navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
        //设置屏幕的转向为横屏
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeRight) forKey:@"orientation"];
        NSString *portrait = [NSString stringWithFormat:@"%ld",(long)TRTCVideoRenderModeLandscape];
        TXUserDefaultsSetObjectforKey(portrait, Direction);
        //刷新
        [UIViewController attemptRotationToDeviceOrientation];
        [self updateRenderViewsLayout];
        [self.bottomToos updateButtons];
    }
}

/// setUpSmallChatUI
- (void)setUpSmallChatUI {
    [self.view addSubview:self.smallChatView];
    [self.smallChatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(15);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-(Adapt(15+60)));
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
    
    [self.view addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.coverView addTarget:self action:@selector(hideKeyBoard)];
    self.coverView.hidden = YES;
    [self.view addSubview:self.inputToolBar];
    [self.inputToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.height.mas_equalTo(kInputToolBarH);
    }];
//    QSTapGestureRecognizer *gesture = [[QSTapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
//    [self.view addGestureRecognizer:gesture];
    _crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_crossBtn];
    [_crossBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-Adapt(15));
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-(Adapt(15+60)));
        make.width.mas_equalTo(Adapt(38));
        make.height.mas_equalTo(Adapt(38));
    }];
    NSString *direction = TXUserDefaultsGetObjectforKey(Direction);
    NSString *imageNameStr = ( [direction intValue] == 0 )? @"Landscape-Portrait" : @"Portrait-Landscape";
    [_crossBtn setImage:[UIImage imageNamed:imageNameStr inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    //     _crossBtn.frame = CGRectMake(15, 0, 50, 50);
    [_crossBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hideKeyBoard {
    self.coverView.hidden = YES;
    [self.view endEditing:YES];
}


/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
    NSLog(@"handleScreenOrientationChange");
    if (![UIWindow isLandscape]) {
        [self updateUI:YES];
    } else {
        [self updateUI:NO];
    }
    if (self.isWhite) {
        self.crossBtn.hidden = [UIWindow isLandscape];
    }
}

- (void)updateUI:(BOOL)isPortrait {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (isPortrait) {
//        for (UIView *view in self.view.subviews) {
//            if ([view isKindOfClass:[TXTStatusBar class]]) {
//                [view removeFromSuperview];
//            }
//        }
//        [self.topToos mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
//            make.left.mas_equalTo(self.view.mas_left).offset(0);
//            make.right.mas_equalTo(self.view.mas_right).offset(0);
//            make.height.mas_equalTo(Adapt(60));
//        }];
    } else {
//        TXTStatusBar *statusBar = [[TXTStatusBar alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 20)];
//        [self.view addSubview:self.statusToos];
//        [self.topToos mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.view.mas_top).offset(20);
//            make.left.mas_equalTo(self.view.mas_left).offset(0);
//            make.right.mas_equalTo(self.view.mas_right).offset(0);
//            make.height.mas_equalTo(Adapt(60));
//        }];
//

    }
    
//    NSString *direction = TXUserDefaultsGetObjectforKey(Direction);
//    NSString *imageNameStr = ( [direction intValue] == 0 )? @"Portrait-Landscape" : @"Landscape-Portrait";
//    NSLog(@"updateUI direction = %@",direction);
//    [_crossBtn setImage:[UIImage imageNamed:imageNameStr inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
}

- (void)chatInputToolBarDidClickSendBtn:(UIButton *)btn {
    self.inputToolBar.textView.text = [self.inputToolBar.textView.text stringByAppendingString:@"\n"];
    [self textViewDidChange:self.inputToolBar.textView];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if ([UIWindow isLandscape]) {
        self.statusToos.hidden = NO;
        if (self.isWhite) {
            self.crossBtn.hidden = YES;
        }
    } else {
        self.statusToos.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self hiddenTabAndNav];
//    TXTNavigationController *navigationController = (TXTNavigationController *)self.navigationController;
//    if (navigationController.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//
////        [self.view addSubview:self.statusToos];
////        [self.topToos mas_remakeConstraints:^(MASConstraintMaker *make) {
////                make.top.mas_equalTo(self.view.mas_top).offset(20);
////                make.left.mas_equalTo(self.view.mas_left).offset(0);
////                make.right.mas_equalTo(self.view.mas_right).offset(0);
////                make.height.mas_equalTo(Adapt(60));
////            }];
//    }
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setBottomToolsUI];
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
    self.hideBottomAndTop = YES;
    //切换rootViewController的旋转方向
    if (navigationController.interfaceOrientation == UIInterfaceOrientationPortrait) {
        navigationController.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
        navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
        //设置屏幕的转向为横屏
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeRight) forKey:@"orientation"];
        NSString *portrait = [NSString stringWithFormat:@"%ld",(long)TRTCVideoRenderModeLandscape];
        TXUserDefaultsSetObjectforKey(portrait, Direction);
        //刷新
        [UIViewController attemptRotationToDeviceOrientation];
        [self updateRenderViewsLayout];
        [self.bottomToos updateButtons];
    }
}

- (void)joinRoom{
    [self addNotification];
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
    [[[TICManager sharedInstance] getTRTCCloud] setAudioRoute:TRTCAudioModeSpeakerphone];
    self.isSpeak = YES;
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
            NSDictionary *roomInfoDic = [result valueForKey:@"roomInfo"];
            NSString *bgImageStr = [roomInfoDic valueForKey:@"bgImage"];
            [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:bgImageStr] placeholderImage:nil];
//            [self.view insertSubview:self.bgImageView belowSubview:self.renderVideoView];
            self.isShowWhiteBoard = [[result valueForKey:@"shareStatus"] boolValue];
            
            NSArray *userInfo = [result valueForKey:@"userInfo"];
            NSMutableArray *renderNewArr = self.renderViews;
            for (int i = 0; i<userInfo.count; i++) {
                
                NSDictionary *userdic = userInfo[i];
                NSArray *keysArr = [userdic allKeys];
                // 判断本人是同屏的发送方还是接收方
                if ([userModel.render.userId isEqualToString:[TICConfig shareInstance].userId]) {
                    if ([[userdic valueForKey:@"userId"] isEqualToString:[TICConfig shareInstance].userId]) {
                        if ([keysArr containsObject:@"shareWebRole"]) {
                            NSString *shareWebRole = [userdic valueForKey:@"shareWebRole"] ? [userdic valueForKey:@"shareWebRole"] : @"";
                            //发送方
                            if ([shareWebRole isEqualToString:@"fromUser"]) {
                                self.webType = @"0";
                                if ([keysArr containsObject:@"shareWebName"]) {
                                    NSString *shareWebName = [userdic valueForKey:@"shareWebName"];
                                    self.productName = shareWebName;
                                }
                                if ([keysArr containsObject:@"shareWebId"]) {
                                    if (![[userdic valueForKey:@"shareWebId"] isEqualToString:@""]) {
                                        [self selfPushToWebView:[userdic valueForKey:@"shareWebUrl"] WebId:[userdic valueForKey:@"shareWebId"] ActionType:@"1"];
                                    }
                                }
                            }
                            //接收方
                            else if ([shareWebRole isEqualToString:@"toUser"]){
                                self.webType = [TICConfig shareInstance].userId;
                                if ([keysArr containsObject:@"shareWebName"]) {
                                    NSString *shareWebName = [userdic valueForKey:@"shareWebName"];
                                    self.productName = shareWebName;
                                }
                                if ([keysArr containsObject:@"shareWebId"]) {
                                    if (![[userdic valueForKey:@"shareWebId"] isEqualToString:@""]) {
                                        [self selfPushToWebView:[userdic valueForKey:@"shareWebUrl"] WebId:[userdic valueForKey:@"shareWebId"] ActionType:@"1"];
                                    }
                                }
                            }
                        }
                    }
                }
                
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
//        [self addFile:FileTypePics fileModel:[[TXTFileModel alloc] init]];
        [self addFile:FileTypeH5 fileModel:[[TXTFileModel alloc] init]];
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
        weakSelf.isWhite = NO;
        [weakSelf.whiteBoardViewController.view removeFromSuperview];
        weakSelf.whiteBoardViewController = nil;
        [weakSelf.smallChatView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom).offset(-(Adapt(15+60)));
        }];
        weakSelf.crossBtn.hidden = NO;
        weakSelf.smallChatView.hidden = YES;
        [weakSelf.crossBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom).offset(weakSelf.hideBottomAndTop ? -Adapt(15) : -(Adapt(15+60)));
            make.bottom.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom).offset(-(Adapt(15+60)));
        }];
    };
    [self addChildViewController:self.whiteBoardViewController];
    [self.view insertSubview:self.whiteBoardViewController.view belowSubview:self.smallChatView];
    [self.whiteBoardViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    weakSelf.isWhite = YES;
    [self.smallChatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
    }];
    self.smallChatView.hidden = NO;
    self.crossBtn.hidden = [UIWindow isLandscape];
    [self.crossBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
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
//    return;
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

/**
 *  fileType 文件类型
 *  fileModel 文件数据
 */
- (void)addFile:(FileType)fileType fileModel:(TXTFileModel *)fileModel {
    // 开始做事情
    if (fileType == FileTypePics) {
        
        fileModel.pics = @[@"https://wisdom-exhibition-1301905869.cos.ap-shenzhen-fsi.myqcloud.com/testdocument/0jsoaidalsh31nr2bk4c_tiw/picture/1.jpg",
                           @"https://wisdom-exhibition-1301905869.cos.ap-shenzhen-fsi.myqcloud.com/testdocument/0jsoaidalsh31nr2bk4c_tiw/picture/2.jpg",
                           @"https://wisdom-exhibition-1301905869.cos.ap-shenzhen-fsi.myqcloud.com/testdocument/0jsoaidalsh31nr2bk4c_tiw/picture/3.jpg"];
        [self showWhiteViewController:fileType fileModel:fileModel];
    } else if (fileType == FileTypeVideo) {
        fileModel.videoUrl = @"https://res.qcloudtiw.com/demo/tiw-vod.mp4";
        [self showWhiteViewController:fileType fileModel:fileModel];
    } else if (fileType == FileTypeH5) {
        fileModel.h5Url = @"https://recall-sync-demo.cloud-ins.cn/mirror.html?syncid=51-cvsstest123-1&synctoken=0060490432279104e008daf9a660dfb8d2aIABaoflIqpo4-W91SrtSeG8e-QAQ5_O7_RsAQrms1PxSLJ597XwAAAAAEADKL1Dbsjd_YwEA6AOyN39j";
        fileModel.name = @"同期Canon";
        if (fileModel.h5Url.length <= 0) {
            [TXTToast toastWithTitle:@"url为空" type:TXTToastTypeWarn];
            return;
        }
        if (fileModel.name.length <= 0) {
            [TXTToast toastWithTitle:@"name为空" type:TXTToastTypeWarn];
            return;
        }
        NSDictionary *bodydic = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"name":(fileModel.name.length > 0 ? fileModel.name : @""),@"url":(fileModel.h5Url.length > 0 ? fileModel.h5Url : @""), @"agent" : TXUserDefaultsGetObjectforKey(AgentId)};
        [[AFNHTTPSessionManager shareInstance] requestURL:ShareWebs_Add RequestWay:@"POST" Header:nil Body:bodydic params:nil isFormData:NO success:^(NSError *error, id response) {
            NSString *errCode = [response valueForKey:@"errCode"];
            NSLog(@"%@", [response valueForKey:@"errInfo"]);
            if ([errCode intValue] == 0) {
                NSDictionary *resultDic = [response valueForKey:@"result"];
                NSString *webId = [resultDic valueForKey:@"webId"];
                if (webId.length <= 0) {
                    [TXTToast toastWithTitle:@"webId为空" type:TXTToastTypeWarn];
                    return;
                }
                [self showWebViewControllerWithFileModel:fileModel webId:webId];
            } else {
                [TXTToast toastWithTitle:[response valueForKey:@"errInfo"] type:TXTToastTypeWarn];
            }
        } failure:^(NSError *error, id response) {
                
        }];
    }
}

/// 切换文件
- (void)showWhiteViewController:(FileType)fileType fileModel:(TXTFileModel *)fileModel {
    NSString *serviceId = TXUserDefaultsGetObjectforKey(ServiceId);
    NSDictionary *bodyDict = @{@"serviceId":serviceId,@"shareStatus":@(YES),@"userId":[TICConfig shareInstance].userId};
    NSLog(@"shareStatusoooo == %@",[bodyDict description]);
    [[AFNHTTPSessionManager shareInstance] requestURL:ServiceRoom_ShareStatus RequestWay:@"POST" Header:nil Body:bodyDict params:nil isFormData:NO success:^(NSError *error, id response) {
        NSString *errCode = [response valueForKey:@"errCode"];
        if ([errCode intValue] == 0) {
            //发送消息
            NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":@"shareWhiteboard",@"shareUserId":[TICConfig shareInstance].userId};
            NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
            QSLog(@"切换文件 == %@",str);
            [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
                QSLog(@"切换文件 == %@",desc);
                [self getWhiteBoard:YES];
                if (fileType == FileTypePics) {
                    [self.whiteBoardViewController showImages:fileModel.pics];
                } else if (fileType == FileTypeVideo) {
                    [self.whiteBoardViewController showVideo:fileModel.videoUrl];
                }
            }];
        }else{
            [TXTToast toastWithTitle:@"他人正在操作" type:TXTToastTypeWarn];
        }
        NSLog(@"shareStatus == %@",[response description]);
    } failure:^(NSError *error, id response) {
        [TXTToast toastWithTitle:@"网络连接错误" type:TXTToastTypeWarn];
    }];
}

/// 同屏展示webview
- (void)showWebViewControllerWithFileModel:(TXTFileModel *)fileModel webId:(NSString *)webId {
    NSMutableArray *membersListArr = [NSMutableArray arrayWithArray:self.renderViews];
    for (int i = 0 ; i < membersListArr.count; i ++) {
        TXTUserModel *model = membersListArr[i];
        if ([model.render.userId isEqualToString:[TICConfig shareInstance].userId]) {
            [membersListArr removeObject:model];
        }
    }
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (membersListArr.count < 1) {
        [[JMToast sharedToast] showDialogWithMsg:@"推送失败，会议内暂无其他人员"];
        return;
    } else if (membersListArr.count == 1){
        for (int i = 0; i<membersListArr.count; i++) {
            TXTUserModel *usermodel = membersListArr[i];
            QSLog(@"%@", TXUserDefaultsGetObjectforKey(AgentName));
            if ([usermodel.userName isEqualToString:TXUserDefaultsGetObjectforKey(AgentName)]) {
                
            } else {
                [self startH5Show:usermodel.render.userId fileModel:fileModel webId:webId];
            }
        }
    } else {
        for (int i = 0; i<membersListArr.count; i++) {
            TXTUserModel *usermodel = membersListArr[i];
            if ([usermodel.userName isEqualToString:TXUserDefaultsGetObjectforKey(AgentName)]) {
            } else {
                UIAlertAction *action0 = [UIAlertAction actionWithTitle:usermodel.userName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 跳转web
                    [self startH5Show:usermodel.render.userId fileModel:fileModel webId:webId];
                }];
                [actionSheet addAction:action0];
            }
        }
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actionSheet addAction:action3];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

- (void)startH5Show:(NSString *)userId fileModel:(TXTFileModel *)fileModel webId:(NSString *)webId {
    NSDictionary *bodydic = @{@"webId":webId,@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"fromUserId":[TICConfig shareInstance].userId,@"toUserId":userId};
    [[AFNHTTPSessionManager shareInstance] requestURL:ShareWebs_Start RequestWay:@"POST" Header:nil Body:bodydic params:nil isFormData:NO success:^(NSError *error, id response) {
        NSString *errCode = [response valueForKey:@"errCode"];
        NSLog(@"%@", [response valueForKey:@"errInfo"]);
        if ([errCode intValue] == 0) {
            NSDictionary *resultDic = [response valueForKey:@"result"];
         
            NSString *clientUrl = [resultDic valueForKey:@"clientUrl"];
            NSString *agentUrl = [resultDic valueForKey:@"agentUrl"];
            //发消息
            TXUserDefaultsSetObjectforKey(userId, @"miniUserId");
            NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":@"wxShareWebFile",@"userId":userId,@"webId":webId,@"webUrl":clientUrl,@"fromId":[TICConfig shareInstance].userId,@"fileName":fileModel.name};
            NSLog(@"wxShareWebFile = %@",[messagedict description]);
            NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
            [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
                NSLog(@"发消息");
                [self pushToWebView:agentUrl WebId:webId ActionType:@"1" ProductName:fileModel.name];
            }];
        } else {
            [TXTToast toastWithTitle:[response valueForKey:@"errInfo"] type:TXTToastTypeWarn];
        }
    } failure:^(NSError *error, id response) {
    }];
}

- (void)pushToWebView:(NSString *)url WebId:(nonnull NSString *)webId ActionType:(NSString *)actionType ProductName:(NSString *)productName {
    self.webId = webId;
    NSLog(@"pushToWebView");
//    self.shareState = YES;
    showWebViewController *webViewVc = [[showWebViewController alloc] init];
    webViewVc.delegate = self;
    webViewVc.url = url;
    webViewVc.webId = webId;
    webViewVc.userModel = self.renderViews[0];
    webViewVc.productName = productName;
    webViewVc.actionType = actionType;
    webViewVc.type = @"0";
    [self.navigationController pushViewController:webViewVc animated:YES];
//    [self presentViewController:self.showWebViewController animated:YES completion:nil];
}
- (void)selfPushToWebView:(NSString *)url WebId:(nonnull NSString *)webId ActionType:(NSString *)actionType {
    if ([webId isEqualToString:@""] || [self.productName isEqualToString:@""]) {
        [[JMToast sharedToast] showDialogWithMsg:@"同屏链接不存在"];
        return;
    }
    UIViewController *currentvc = [[AFNHTTPSessionManager shareInstance] getCurrentVC];
    if ([currentvc isKindOfClass:[showWebViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.webId = webId;
    NSLog(@"selfPushToWebView");
//    self.shareState = YES;
    showWebViewController *webViewVc = [[showWebViewController alloc] init];
//    _showWebViewController.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    webViewVc.delegate = self;
    webViewVc.url = url;
    webViewVc.webId = webId;
    webViewVc.userModel = self.renderViews[0];
    webViewVc.productName = self.productName;
    webViewVc.actionType = actionType;
    webViewVc.type = self.webType;
    [self.navigationController pushViewController:webViewVc animated:YES];
    //    [self presentViewController:self.showWebViewController animated:YES completion:nil];
}


- (void)hideWebViewController {
    NSLog(@"hideWebViewController");
    //结束共享
    self.isShowWhiteBoard = NO;
    //发送消息
    NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":@"endWhiteboard",@"shareUserId":[TICConfig shareInstance].userId};
    NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
    [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
        [[[TICManager sharedInstance] getBoardController] reset];
    }];
    [self shareStatus:NO];
}
- (void)shareStatus:(BOOL)shareStatus {
    NSString *serviceId = TXUserDefaultsGetObjectforKey(ServiceId);
    NSDictionary *bodyDict = @{@"serviceId":serviceId,@"shareStatus":@(shareStatus),@"userId":[TICConfig shareInstance].userId};
    NSLog(@"shareStatusoooo == %@",[bodyDict description]);
    [[AFNHTTPSessionManager shareInstance] requestURL:ServiceRoom_ShareStatus RequestWay:@"POST" Header:nil Body:bodyDict params:nil isFormData:NO success:^(NSError *error, id response) {
        NSLog(@"shareStatus == %@",[response description]);
    } failure:^(NSError *error, id response) {
        [[JMToast sharedToast] showDialogWithMsg:@"网络连接错误"];
    }];
}

- (void)muteAction:(showWebViewController *)showWebViewController {
    [self muteAudioAction];
//    TXTUserModel *model = [self.renderViews firstObject];
//    TXTUserModel *newModel = [[TXTUserModel alloc] init];
//    if(self.muteState){
//        newModel.render = model.render;
//        newModel.showVideo = model.showVideo;
//        newModel.showAudio = YES;
//        newModel.info = model.info;
//        newModel.userName = model.userName;
//        [self.renderViews replaceObjectAtIndex:0 withObject:newModel];
//        [self updateRenderViewsLayout];
//        [[[TICManager sharedInstance] getTRTCCloud] muteLocalAudio:NO];
////        [self.muteButton setImage:[UIImage imageNamed:@"mute_unselect" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
//    }
//    else{
//        newModel.render = model.render;
//        newModel.showVideo = model.showVideo;
//        newModel.showAudio = NO;
//        newModel.info = model.info;
//        newModel.userName = model.userName;
//        [self.renderViews replaceObjectAtIndex:0 withObject:newModel];
//        [self updateRenderViewsLayout];
//        [[[TICManager sharedInstance] getTRTCCloud] muteLocalAudio:YES];
////        [self.muteButton setImage:[UIImage imageNamed:@"mute_select" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
//    }
//    self.muteState = !self.muteState;
    showWebViewController.userModel = [self.renderViews firstObject];
}
#pragma mark -- TXTTopButtonsDelegate

- (void)txSpeakBtnClick{
    if (self.isSpeak) {
        [self.topToos changeSpeakBtnStatus:self.isSpeak];
        [[[TICManager sharedInstance] getTRTCCloud] setAudioRoute:TRTCAudioModeEarpiece];
    }else{
        [self.topToos changeSpeakBtnStatus:self.isSpeak];
        [[[TICManager sharedInstance] getTRTCCloud] setAudioRoute:TRTCAudioModeSpeakerphone];
    }
    self.isSpeak = !self.isSpeak;
}

- (void)txSwitchBtnClick{
    [[[TICManager sharedInstance] getTRTCCloud] switchCamera];
}

- (void)txQuitBtnClick{
    [self onQuitClassRoom];
}

#pragma mark - TXTGroupMemberViewControllerDelegate
- (void)memberViewControllerDidUpdateInfo:(TXTUserModel *)model {
    
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
        TXTCommonAlertView *alert = [TXTCommonAlertView alertWithTitle:@"本次录制需获得全部参会人员授权确认后可进行录制，请您确认"  titleColor:nil titleFont:nil leftBtnStr:@"取消" rightBtnStr:@"确定" leftColor:nil rightColor:nil];
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
- (void)bottomMoreActionButtonClick {
    TXTMoreView *moreView = [[TXTMoreView alloc] init];
    moreView.chatBlock = ^{
        // 添加聊天页面
        __weak __typeof(self)weakSelf = self;
        self.chatViewController.closeBlock = ^{
            [weakSelf.chatViewController.view removeFromSuperview];
//            weakSelf.chatViewController = nil;
        };
        [self addChildViewController:self.chatViewController];
        [self.view addSubview:self.chatViewController.view];
//        [self.view insertSubview:self.chatViewController.view belowSubview:self.smallChatView];
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
    //更新单个视图
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
//- (void)switchCamera{
//    [[[TICManager sharedInstance] getTRTCCloud] switchCamera];
//}

///切换扬声器
//- (void)changeAudioRoute:(UIButton *)button{
//    if (self.isSpeak) {
//        UIImage *speakerImg = [UIImage imageNamed:@"white_icon_shotNormal" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//        [button setImage:[speakerImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        [[[TICManager sharedInstance] getTRTCCloud] setAudioRoute:TRTCAudioModeEarpiece];
//    }else{
//        UIImage *speakerImg = [UIImage imageNamed:@"speaker" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
//        [button setImage:[speakerImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        [[[TICManager sharedInstance] getTRTCCloud] setAudioRoute:TRTCAudioModeSpeakerphone];
//    }
//    self.isSpeak = !self.isSpeak;
//}

///同屏
//- (void)selfPushToWebView:(NSString *)url WebId:(nonnull NSString *)webId ActionType:(NSString *)actionType{
//    if ([webId isEqualToString:@""] || [self.productName isEqualToString:@""]) {
//        [[JMToast sharedToast] showDialogWithMsg:@"同屏链接不存在"];
//        return;
//    }
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
//}
///结束同屏
- (void)hideshowview{
    //    self.backView.hidden = YES;
    //    self.otherShareStatus = NO;
    //    [self.webViewListController removeFromParentViewController];
    //    [self.webViewListController.view removeFromSuperview];
    //    [self.shareFileButton setImage:[UIImage imageNamed:@"fileShare_unselect" inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    //    self.shareState = NO;
}

//横竖屏切换
- (void)btnAction{
    TXTNavigationController *navigationController = (TXTNavigationController *)self.navigationController;
    //切换rootViewController的旋转方向
    if (navigationController.interfaceOrientation == UIInterfaceOrientationPortrait) {
        navigationController.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
        navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
        //设置屏幕的转向为横屏
        if (@available(iOS 16.0, *)) {
            // iOS16新API，让控制器刷新方向，新方向为上面设置的orientations
    #if defined(__IPHONE_16_0)
            [self setNeedsUpdateOfSupportedInterfaceOrientations];
            NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *scene = [array firstObject];
            // 屏幕方向
            UIInterfaceOrientationMask orientation = UIInterfaceOrientationMaskLandscapeRight;
            UIWindowSceneGeometryPreferencesIOS *geometryPreferencesIOS = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:orientation];
            // 开始切换
            [scene requestGeometryUpdateWithPreferences:geometryPreferencesIOS errorHandler:^(NSError * _Nonnull error) {
                NSLog(@"强制%@错误:%@", @"横屏", error);
            }];
    #endif
        }else{
            [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeRight) forKey:@"orientation"];
        }
        NSString *portrait = [NSString stringWithFormat:@"%ld",(long)TRTCVideoRenderModeLandscape];
        TXUserDefaultsSetObjectforKey(portrait, Direction);
    }
    else {
        navigationController.interfaceOrientation = UIInterfaceOrientationPortrait;
        navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
        //设置屏幕的转向为竖屏
        if (@available(iOS 16.0, *)) {
            // iOS16新API，让控制器刷新方向，新方向为上面设置的orientations
    #if defined(__IPHONE_16_0)
            [self setNeedsUpdateOfSupportedInterfaceOrientations];
            NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *scene = [array firstObject];
            // 屏幕方向
            UIInterfaceOrientationMask orientation = UIInterfaceOrientationMaskPortrait;
            UIWindowSceneGeometryPreferencesIOS *geometryPreferencesIOS = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:orientation];
            // 开始切换
            [scene requestGeometryUpdateWithPreferences:geometryPreferencesIOS errorHandler:^(NSError * _Nonnull error) {
                NSLog(@"强制%@错误:%@", @"横屏", error);
            }];
    #endif
        }else{
            [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
        }
        NSString *portrait = [NSString stringWithFormat:@"%ld",(long)TRTCVideoRenderModePortrait];
        TXUserDefaultsSetObjectforKey(portrait, Direction);
    }
    [self setPortraitLandscapeUI];
}

- (void)setPortraitLandscapeUI{
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    [self updateRenderViewsLayout];
    [self.bottomToos updateButtons];
    NSString *portrait = TXUserDefaultsGetObjectforKey(Direction);
    NSString *imageNameStr = ( [portrait intValue] == 0 ) ? @"Landscape-Portrait" : @"Portrait-Landscape";
    [_crossBtn setImage:[UIImage imageNamed:imageNameStr inBundle:TXSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
//    self.crossBtn.hidden = self.isWhite ? YES : NO;
//    if ([portrait intValue] == 0) {
//        self.statusToos.hidden = NO;
////        for (UIView *view in self.view.subviews) {
////            if ([view isKindOfClass:[TXTStatusBar class]]) {
////                [view removeFromSuperview];
////            }
////        }
////        [self.topToos mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
////            make.left.mas_equalTo(self.view.mas_left).offset(0);
////            make.right.mas_equalTo(self.view.mas_right).offset(0);
////            make.height.mas_equalTo(Adapt(60));
////        }];
//    } else {
//        self.statusToos.hidden = YES;
//////        [self.view addSubview:self.statusToos];
////        [self.topToos mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.top.mas_equalTo(self.statusToos.mas_bottom).offset(0);
////            make.left.mas_equalTo(self.view.mas_left).offset(0);
////            make.right.mas_equalTo(self.view.mas_right).offset(0);
////            make.height.mas_equalTo(Adapt(60));
////        }];
//    }
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
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        }];
    }else{
        [_renderVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(Adapt(168));
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.height.mas_equalTo(Adapt(230)+Adapt(90));
        }];
    }
    [self.renderVideoView setVideoRenderNumber:(self.renderViews.count - 1) mode:directionInt];
}

//更新某一个view，audio
- (void)updateRenderViewsLayoutWithIndex:(NSInteger)index userVolumes:(NSArray<TRTCVolumeInfo *> *)userVolumes{
    NSString *direction = TXUserDefaultsGetObjectforKey(Direction);
    NSInteger directionInt = [direction integerValue];
    [self.renderVideoView changeViewNumber:(self.renderViews.count - 1) mode:directionInt Index:index userVolumes:userVolumes];
}

//更新某一个view，video
- (void)updateVideoRenderViewsLayoutWithIndex:(NSInteger)index{
    NSString *direction = TXUserDefaultsGetObjectforKey(Direction);
    NSInteger directionInt = [direction integerValue];
    [self.renderVideoView changeVideoViewNumber:(self.renderViews.count - 1) mode:directionInt Index:index];
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
                [self updateRenderViewsLayoutWithIndex:i userVolumes:@[info]];
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
                [self updateVideoRenderViewsLayoutWithIndex:i];
                break;
            }
        }
        [self reloadManageMembersArray];
//        [self updateRenderViewsLayout];
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
            // 同屏
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
//                NSString *webURL = [dict valueForKey:@"webUrl"];
//                NSString *webId = [dict valueForKey:@"webId"];
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

- (void)onAudioRouteChanged:(TRTCAudioRoute)route fromRoute:(TRTCAudioRoute)fromRoute{
    NSLog(@"onAudioRouteChanged = %d-%d",fromRoute,route);
}

- (void)inputKeyboardWillShow:(NSNotification *)noti {
    if (![self.inputToolBar.textView isFirstResponder]) return;
    self.coverView.hidden = NO;
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
       self.coverView.hidden = YES;
   }];
}

- (void)smallChatViewDidClickEmoji:(UIButton *)btn {
//    self.emojiView.hidden = NO;
    self.emojiView.isWhite = self.isWhite;
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
    } fail:^(int code, NSString *desc) {
    }];
    
    [[V2TIMManager sharedInstance] findMessages:@[msgID] succ:^(NSArray<V2TIMMessage *> *msgs) {
        [self.smallMessageView addMessage:str];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"POSTSmallMessage" object:nil userInfo:@{@"POSTSmallMessage" : [msgs firstObject]}];
    } fail:^(int code, NSString *desc) {
    }];
}


/// showKeyBoard
- (void)showKeyBoard {
    self.coverView.hidden = NO;
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

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        [self.view addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(0);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
            make.left.mas_equalTo(self.view.mas_left).offset(0);
            make.right.mas_equalTo(self.view.mas_right).offset(0);
        }];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view sendSubviewToBack:_bgImageView];
    }
    return _bgImageView;
}

- (void)setBottomToolsUI{
    self.bottomToos.hidden = NO;
//    self.topToos.hidden = NO;
//    self.statusToos.hidden = NO;
    [self.navView addSubview:self.statusToos];
    self.navView.hidden = NO;
}

- (bottomButtons *)bottomToos{
    if (!_bottomToos) {
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
        
    }
    return _bottomToos;
}

- (TXTTopButtons *)topToos{
    if (!_topToos) {
        _topToos = [[TXTTopButtons alloc] init];
        _topToos.delegate = self;
    }
    return _topToos;
}

- (TXTStatusBar *)statusToos{
    if (!_statusToos) {
        CGFloat width = MAX(Screen_Height, Screen_Width);
        _statusToos = [[TXTStatusBar alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
//        [self.view addSubview:_statusToos];
//        [self.view bringSubviewToFront:_statusToos];
    }
    return _statusToos;
}

- (UIView *)navView {
    if (!_navView) {
        UIView *navView = [[UIView alloc] init];
        navView.backgroundColor = [UIColor colorWithHexString:@"424548"];
        self.navView = navView;
    }
    return _navView;
}


- (NSMutableArray *)renderViews {
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
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(Adapt(168));
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.height.mas_equalTo(Adapt(230)+Adapt(90));//Screen_Height/3.5
        }];
//        [self.view sendSubviewToBack:_renderVideoView];
        [self.view insertSubview:_renderVideoView aboveSubview:self.bgImageView];
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
            //切为竖屏
            TXTNavigationController *navigationController = (TXTNavigationController *)self.navigationController;
            //切换rootViewController的旋转方向
            navigationController.interfaceOrientation = UIInterfaceOrientationPortrait;
            navigationController.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
            //设置屏幕的转向为横屏
            [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
            NSString *portrait = [NSString stringWithFormat:@"%ld",(long)TRTCVideoRenderModePortrait];
            TXUserDefaultsSetObjectforKey(portrait, Direction);
            //刷新
            [UIViewController attemptRotationToDeviceOrientation];
            [self updateRenderViewsLayout];
            [self.bottomToos updateButtons];
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

#pragma mark -- 隐藏tab+nav
- (void)clickContentView{
    [self hiddenTabAndNav];
}

- (void)endPolling {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    });
}

- (void)countDown {
    self.count -= 1;
    if (self.count <= 0.01) {
        [self.statusToos removeFromSuperview];
        self.statusToos = nil;
//        self.topToos.hidden = YES;
        self.navView.hidden = YES;
        self.bottomToos.hidden = YES;
        if (!self.isWhite) {
            self.smallChatView.hidden = YES;
        }
        self.hideBottomAndTop = YES;
        [self endPolling];
    } else {
        [self performSelector:@selector(countDown) withObject:nil afterDelay:1.0];
    }
}

- (void)hiddenTabAndNav{

//    if (self.hideBottomAndTop) {
//
//    }else{
//
//    }
//    self.hideBottomAndTop = !self.hideBottomAndTop;
    //显示
//    [self endPolling];
////    self.statusToos.hidden = NO;
////    self.topToos.hidden = NO;
//    self.navView.hidden = NO;
//    self.bottomToos.hidden = NO;
//    self.count = 3;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self countDown];
//    });
    //隐藏转显示
    if (self.hideBottomAndTop) {
        [self endPolling];
    //    self.statusToos.hidden = NO;
    //    self.topToos.hidden = NO;
        [self.navView addSubview:self.statusToos];
        self.navView.hidden = NO;
        self.bottomToos.hidden = NO;
        self.smallChatView.hidden = NO;
        self.count = 3;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self countDown];
        });
    }
    //显示转隐藏
    else{
        [self.statusToos removeFromSuperview];
        self.statusToos = nil;
        self.navView.hidden = YES;
//        [self.statusToos removeFromSuperview];
//        self.topToos.hidden = YES;
        self.bottomToos.hidden = YES;
        if (!self.isWhite) {
            self.smallChatView.hidden = YES;
        }
        self.hideBottomAndTop = YES;
        [self endPolling];
    }
}



- (void)reloadManageMembersArray {
    self.groupMemberViewController.manageMembersArr = self.renderViews;
    //数据更新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ManageMembersViewController" object:nil];
}
#pragma  mark 横屏设置

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (TXTGroupMemberViewController *)groupMemberViewController {
    if (!_groupMemberViewController) {
        TXTGroupMemberViewController *groupMemberViewController = [[TXTGroupMemberViewController alloc] init];
        groupMemberViewController.delegate = self;
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
- (UIView *)coverView {
    if (!_coverView) {
        UIView *coverView = [[UIView alloc] init];
//        coverView.backgroundColor = [UIColor colorWithHexString:@"D70110"];
        self.coverView = coverView;
    }
    return _coverView;
}
- (TXTChatInputToolBar *)inputToolBar {
    if (!_inputToolBar) {
        TXTChatInputToolBar *inputToolBar = [[TXTChatInputToolBar alloc] init];
        inputToolBar.hidden = YES;
        inputToolBar.textView.delegate = self;
        inputToolBar.delegate = self;
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
