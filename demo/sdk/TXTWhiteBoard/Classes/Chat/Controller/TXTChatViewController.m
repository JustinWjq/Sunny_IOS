//
//  TXTChatViewController.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/1.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTChatViewController.h"
#import "TXTChatView.h"
#import "TXTSmallChatView.h"
#import "TXTChatInputToolBar.h"
#import "TXTCommon.h"
#import "TXTSmallMessageView.h"
#import "TXTEmojiView.h"


static NSInteger const kInputToolBarH = 62;

@interface TXTChatViewController () <TICMessageListener, UITextViewDelegate, TXTSmallChatViewDelegate, TXTEmojiViewDelegate>
/** groupChatRoomView */
@property (nonatomic, strong) TXTChatView *groupChatRoomView;
/** smallChatView */
@property (nonatomic, strong) TXTSmallChatView *smallChatView;
/** emojiView */
@property (nonatomic, strong) TXTEmojiView *emojiView;

/** inputToolBar */
@property (nonatomic, strong) TXTChatInputToolBar *inputToolBar;
/** 当前键盘的高度 */
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;
/** 当前的contentOffSet */
@property (nonatomic, assign) CGFloat contentOffsetY;

/** smallMessageView */
@property (nonatomic, strong) TXTSmallMessageView *smallMessageView;
@end

@implementation TXTChatViewController

#pragma mark - ♻️life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self qs_initData];
    [self qs_initSubViews];
    
    [[TICManager sharedInstance] addIMessageListener:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

#pragma mark - 🔒private

- (void)qs_initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self addNotification];
}

- (void)qs_initSubViews {
    self.view.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];

    self.title = [NSString stringWithFormat:@"%@",TXUserDefaultsGetObjectforKey(RoomId)];
    
    [self.view addSubview:self.groupChatRoomView];
    [self.groupChatRoomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];

    [self.groupChatRoomView addSubview:self.smallChatView];
    [self.smallChatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.equalTo(self.groupChatRoomView.mas_bottom).offset(-75);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(34);
    }];
    
//    [self.view addSubview:self.smallChatView];
//    [self.smallChatView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(15);
//        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-75);
//        make.width.mas_equalTo(150);
//        make.height.mas_equalTo(34);
//    }];


    [self.view addSubview:self.smallMessageView];
    [self.smallMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallChatView);
        make.height.mas_equalTo(39 * 3);
        make.bottom.equalTo(self.smallChatView.mas_top).offset(-10);
        make.width.mas_equalTo(265);
    }];
    [self.view addSubview:self.emojiView];
    [self.emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallChatView);
        make.height.mas_equalTo(160);
        make.bottom.equalTo(self.smallChatView.mas_top).offset(-10);
        make.width.mas_equalTo(345);
    }];
    self.emojiView.hidden = YES;
    
    [self.view addSubview:self.inputToolBar];
    [self.inputToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.height.mas_equalTo(kInputToolBarH);
    }];
}
/// orientationChange
- (void)handleScreenOrientationChange:(NSNotification *)noti {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.allowRotation = YES;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
        [self leftAction];
        // 竖屏
        [self.groupChatRoomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
        [self.smallChatView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.equalTo(self.groupChatRoomView.mas_bottom).offset(-75);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(34);
        }];
    } else {
        [self rightAction];
        // 横屏
        [self.groupChatRoomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.width.mas_equalTo(375);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
        [self.smallChatView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.bottom.equalTo(self.groupChatRoomView.mas_bottom).offset(-75);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(34);
        }];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation {
    return NO;
}

- (void)leftAction {
//    #这种情况下，iOS16的强制横竖屏切换需要添加代码设置强制旋转，例如：
    // 强制屏幕竖屏：手机
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
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
         } else {
              // iOS16以下
              NSNumber *orientationPortrait = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
              [[UIDevice currentDevice] setValue:orientationPortrait forKey:@"orientation"];
             NSLog(@"%f", [UIScreen mainScreen].bounds.size.width);
          }
    }
}

- (void)rightAction {
    //    #这种情况下，iOS16的强制横竖屏切换需要添加代码设置强制旋转，例如：
        // 强制屏幕竖屏：手机
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
            if (@available(iOS 16.0, *)) {
                // iOS16新API，让控制器刷新方向，新方向为上面设置的orientations
        #if defined(__IPHONE_16_0)
                [self setNeedsUpdateOfSupportedInterfaceOrientations];
                NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
                UIWindowScene *scene = [array firstObject];
                // 屏幕方向
                UIInterfaceOrientationMask orientation = UIInterfaceOrientationMaskLandscapeLeft;

                if ( [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) {
                    orientation = UIInterfaceOrientationMaskLandscapeRight;
                }
                UIWindowSceneGeometryPreferencesIOS *geometryPreferencesIOS = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:orientation];
                // 开始切换
                [scene requestGeometryUpdateWithPreferences:geometryPreferencesIOS errorHandler:^(NSError * _Nonnull error) {
                    NSLog(@"强制%@错误:%@", @"横屏", error);
                }];
        #endif
             } else {
                  // iOS16以下
                 
                 if ( [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft) {
                     NSNumber *orientationPortrait = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
                     [[UIDevice currentDevice] setValue:orientationPortrait forKey:@"orientation"];
                 } else {
                     NSNumber *orientationPortrait = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
                     [[UIDevice currentDevice] setValue:orientationPortrait forKey:@"orientation"];
                 }
//                  NSNumber *orientationPortrait = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//                  [[UIDevice currentDevice] setValue:orientationPortrait forKey:@"orientation"];
                 NSLog(@"%f", [UIScreen mainScreen].bounds.size.width);
              }
        }
}

#pragma mark - 🔄overwrite

#pragma mark - 🚪public

#pragma mark - 🍐delegate
- (void)onTICRecvMessage:(TIMMessage *)message {
    NSString *msgID = message.msgId;
    [[V2TIMManager sharedInstance] findMessages:@[msgID] succ:^(NSArray<V2TIMMessage *> *msgs) {
        V2TIMMessage *v2message = [msgs firstObject];
        if (!v2message.textElem) return;
        NSDictionary *dict = [[TXTCommon sharedInstance] dictionaryWithJsonString:v2message.textElem.text];
        if (![dict[@"type"] isEqualToString:@"wxIM"]) return;
    } fail:^(int code, NSString *desc) {
        
    }];
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

#pragma mark - ☎️notification
#pragma mark --加载通知
- (void)addNotification {
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
    self.emojiView.hidden = NO;
}

- (void)emojiViewDidClickEmoji:(NSString *)emoji {
    [self sendText:emoji];
    self.emojiView.hidden = YES;
}

- (void)dealloc {
    
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
    NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
    
    V2TIMMessage *message = [[V2TIMManager sharedInstance] createTextMessage:str];
    NSString *classId = [NSString stringWithFormat:@"%@",TXUserDefaultsGetObjectforKey(RoomId)];
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


#pragma mark - ☸getter and setter
- (TXTChatView *)groupChatRoomView {
    if (!_groupChatRoomView) {
        TXTChatView *groupChatRoomView = [[TXTChatView alloc] init];
        groupChatRoomView.backgroundColor = [UIColor colorWithHexString:@"D70110"];
        self.groupChatRoomView = groupChatRoomView;
    }
    return _groupChatRoomView;
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
        emojiView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.74];
        emojiView.cornerRadius = 8;
        emojiView.delegate = self;
        self.emojiView = emojiView;
    }
    return _emojiView;
}

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
