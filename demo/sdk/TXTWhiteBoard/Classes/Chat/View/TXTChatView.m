//
//  TXTChatView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/1.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTChatView.h"
#import "TXTDefine.h"
#import "TXTCommon.h"
#import "TXTCustomConfig.h"
#import "QSChatInputToolBar.h"
#import "MJRefresh.h"
#import "QSIMMessageModel.h"
#import "QSShowTimeCell.h"
#import "QSLeftMessageCell.h"
#import "QSRightMessageCell.h"
#import "JCHATStringUtils.h"
#import <ImSDK/ImSDK.h>

#define interval 60*3 //static =const
static NSInteger const kInputToolBarH = 65;

@interface TXTChatView()  <TEduBoardDelegate, TICEventListener, TICMessageListener, TICStatusListener, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, V2TIMAdvancedMsgListener, TIMMessageListener, QSChatInputToolBarDelegate>
/** navBgView */
@property (nonatomic, strong) UIView *navBgView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
/** closeBtn */
@property (nonatomic, strong) UIButton *closeBtn;
/** tableView */
@property (nonatomic, strong) UITableView *messageTableView;
/** inputToolBar */
@property (nonatomic, strong) QSChatInputToolBar *inputToolBar;

/** 当前键盘的高度 */
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;
/** 当前的contentOffSet */
@property (nonatomic, assign) CGFloat contentOffsetY;

/** 缓存所有的message model */
@property (nonatomic, strong) NSMutableDictionary *allMessageDic;
/** 按序缓存后有的messageId， 于allMessage 一起使用 */
@property (nonatomic, strong) NSMutableArray *allmessageIdArr;

/** 将要界面即将消失 */
@property (nonatomic, assign) BOOL inputToolBarWillDisappear;

/** needScrollToBottom */
@property (nonatomic, assign) BOOL needScrollToBottom;


@end

@implementation TXTChatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[V2TIMManager sharedInstance] addAdvancedMsgListener:self];
        [[TICManager sharedInstance] addIMessageListener:self];
        [[TICManager sharedInstance] addEventListener:self];
        [[TICManager sharedInstance] addStatusListener:self];
        
        [self initUI];

        [self addTarget:self action:@selector(tapClick:)];
    }
    return self;
}

- (void)tapClick:(UIGestureRecognizer *)gesture {
    [self.inputToolBar.textView resignFirstResponder];
}


/// initUI
- (void)initUI {
    [self addSubview:self.navBgView];
    [self.navBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo([UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 44);
//        make.height.mas_equalTo(44);
    }];
    [self.navBgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.navBgView);
        make.height.mas_equalTo(44);
    }];
    [self.navBgView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(56);
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.inputToolBar];
    [self.inputToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        make.height.mas_equalTo(kInputToolBarH);
    }];
    [self addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBgView.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.inputToolBar.mas_top);
    }];
    [self bringSubviewToFront:self.inputToolBar];

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(flashToLoadMessage)];
    header.stateLabel.hidden = YES;
    self.messageTableView.mj_header = header;
    
    [self addNotification];
    
    [self getPageMessage];
}

- (void)updateUI:(BOOL)isPortrait {
    [self.navBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 44);
    }];
    
//    if (isPortrait) {
//
//        [self.navBgView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo([UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 44);
//        }];
//    } else {
//        [self.allUnmuteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.mas_centerX).offset(15).priorityHigh();
//            make.width.mas_equalTo(120);
//            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
//            make.height.mas_equalTo(35);
//        }];
//    }
//    [self layoutIfNeeded];
}

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
  self.inputToolBar.textView.delegate = self;
}

- (void)getPageMessage {
    [self.allMessageDic removeAllObjects];
    [self.allmessageIdArr removeAllObjects];
    [self.messageTableView reloadData];

    NSString *classId = [NSString stringWithFormat:@"%@",TXUserDefaultsGetObjectforKey(RoomId)];
    [[V2TIMManager sharedInstance] getGroupHistoryMessageList:classId count:20 lastMsg:nil succ:^(NSArray<V2TIMMessage *> *msgs) {
        NSMutableArray *arrList = [[NSMutableArray alloc] init];
//        [arrList addObjectsFromArray:msgs];
        [arrList addObjectsFromArray:[[msgs reverseObjectEnumerator] allObjects]];
        
        for (NSInteger i=0; i< arrList.count; i++) {
            V2TIMMessage *message = [arrList objectAtIndex:i];
            if (message.textElem) {
                
                NSDictionary *dict = [[TXTCommon sharedInstance] dictionaryWithJsonString:message.textElem.text];
                if (![dict[@"type"] isEqualToString:@"wxIM"]) continue;
                
                QSIMMessageModel *model = [[QSIMMessageModel alloc] init];
                 model.message = message;
                 model.messageTime = [NSNumber numberWithLong:(long)[message.timestamp timeIntervalSince1970] * 1000];
                [self dataMessageShowTime:model.messageTime];
                [self.allMessageDic setObject:model forKey:model.message.msgID];
                [self.allmessageIdArr addObject:model.message.msgID];
            }
        }
        [self.messageTableView reloadData];
      //  [self.view layoutIfNeeded];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [self scrollToBottomAnimated:NO];
          });
    } fail:^(int code, NSString *desc) {

    }];
}

/// flashToLoadMessage
- (void)flashToLoadMessage {
    V2TIMMessage *message = nil;
    for (int i=0; i<self.allmessageIdArr.count; i++) {
        NSString *messageId = self.allmessageIdArr[i];
        QSIMMessageModel *model = self.allMessageDic[messageId];
        if (model.isTime) {
            continue;
        } else {
            message = model.message;
            break;
        }
    }
    
//    if (self.allmessageIdArr.count > 0) {
//        NSString *messageId = [self.allmessageIdArr firstObject];
//        if (!messageId) {
//            [self.messageTableView.mj_header endRefreshing];
//          return;
//        }
//        QSIMMessageModel *model = self.allMessageDic[messageId];
//        message = model.message;
//    }
    NSString *classId = [NSString stringWithFormat:@"%@",TXUserDefaultsGetObjectforKey(RoomId)];
    [[V2TIMManager sharedInstance] getGroupHistoryMessageList:classId count:20 lastMsg:message succ:^(NSArray<V2TIMMessage *> *msgs) {
        NSMutableArray *arrList = @[].mutableCopy;
        [arrList addObjectsFromArray:msgs];
      
        
        NSInteger oldCount = self.allmessageIdArr.count;
        for (NSInteger i = 0; i < [arrList count]; i++) {
            V2TIMMessage *message = arrList[i];
            if (message.textElem) {
                NSDictionary *dict = [[TXTCommon sharedInstance] dictionaryWithJsonString:message.textElem.text];
                if (![dict[@"type"] isEqualToString:@"wxIM"]) continue;
                QSIMMessageModel *model = [[QSIMMessageModel alloc] init];
                model.message = message;
                [self.allMessageDic setObject:model forKey:model.message.msgID];
                [self.allmessageIdArr insertObject:model.message.msgID atIndex:0];
                model.messageTime = [NSNumber numberWithLong:(long)[message.timestamp timeIntervalSince1970] * 1000];
                [self dataMessageShowTimeToTop:model.messageTime];// FIXME:
            }
        }
        [self.messageTableView.mj_header endRefreshing];

        NSInteger newCount = self.allmessageIdArr.count;
        [self.messageTableView reloadData];
        [self layoutIfNeeded];
        
        if (newCount - oldCount > 0) {
           [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newCount - oldCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    } fail:^(int code, NSString *desc) {
        [self.messageTableView.mj_header endRefreshing];
    }];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
  NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
  if (rows > 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
  }
}
#pragma mark -- 刷新对应的
- (void)addCellToTabel {
    NSLog(@"%lf----%lf",self.messageTableView.contentOffset.y,self.messageTableView.contentSize.height - self.messageTableView.height);
  NSIndexPath *path = [NSIndexPath indexPathForRow:[self.allmessageIdArr count]-1 inSection:0];
  [_messageTableView beginUpdates];
  [_messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
  [_messageTableView endUpdates];
  [self layoutIfNeeded];
  [self scrollToEnd];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.messageTableView reloadData];
    });
}

#pragma mark --滑动至尾端
- (void)scrollToEnd {
  if ([self.allmessageIdArr count] != 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  }
}
#pragma mark - UITextViewDelegate
- (void)chatInputToolBarDidClickSendBtn:(UIButton *)btn {
    if ([NSString isEmpty:self.inputToolBar.textView.text]) {
       
    } else {
        self.inputToolBar.textView.text = [self.inputToolBar.textView.text stringByAppendingString:@"\n"];
        [self textViewDidChange:self.inputToolBar.textView];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    QSLog(@"%@", textView.text);
    self.inputToolBar.sendBtn.selected = ![NSString isEmpty:textView.text] ? YES : NO;
    
    if (![textView.text hasSuffix:@"\n"] && textView.text.length >= 50) {
        textView.text = [textView.text substringToIndex:50];
    }
    
  // 1.计算textView的高度
  CGFloat textViewH = 0;
  CGFloat minHeight = 35; // textView最小的高度
  CGFloat maxHeight = 82 + 4; // textView最大的高度

  // 获取contentSize 的高度
  CGFloat contentHeight = textView.contentSize.height;
  if (contentHeight < minHeight) {
      textViewH = minHeight;
      [textView setContentInset:UIEdgeInsetsZero];
  } else if (contentHeight > maxHeight) {
      textViewH = maxHeight + 4.5;
      [textView setContentInset:UIEdgeInsetsMake(-5, 0, -3.5, 0)];
  } else {
      if (contentHeight - (minHeight + 2) < 0.01) {
//          QSLog(@"%@", NSStringFromUIEdgeInsets(textView.contentInset));
          [textView setContentInset:UIEdgeInsetsMake(-0.5, 0, -4.5, 0)];
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
//              [self.view makeToast:@"不能发送空白信息" duration:kToastTime position:CSToastPositionCenter];
          } else {
              [self sendText:textView.text];
          }
      } else {
//          [self.view makeToast:@"不能发送空白信息" duration:kToastTime position:CSToastPositionCenter];
      }
      // 清空textView的文字
      textView.text = nil;
      [textView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
      self.inputToolBar.sendBtn.selected = NO;
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
        [self layoutIfNeeded];
        if (textView.text.length) {
//          [self scrollToBottomAnimated:NO];
            [self scrollToEnd];
        }
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

#pragma mark 键盘显示时会触发的方法
- (void)inputKeyboardWillShow:(NSNotification *)noti {
    if (!self.inputToolBar.textView.isFirstResponder) return;
  //1.获取键盘高度
  //1.1获取键盘结束时候的位置
  CGRect kbEndFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGFloat kbHeight = kbEndFrame.size.height;

  CGRect beginRect = [[noti.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];

  CGRect endRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

  QSLog(@"%f", kbHeight);
  QSLog(@"%@    ----   %@,    %f  xxx %f ",NSStringFromCGRect(beginRect), NSStringFromCGRect(endRect), beginRect.size.height, beginRect.origin.y - endRect.origin.y);

  CGFloat animationDuration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
  QSLog(@"%f........", animationDuration);
  // 2.更改inputToolBar 底部约束
  [self.inputToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
     make.bottom.mas_equalTo(-kbHeight);
  }];

  [UIView animateWithDuration:animationDuration animations:^{
     [self layoutIfNeeded];
  }];
  
  // 4.把消息现在在顶部
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToEnd];
    });
}

#pragma mark 键盘退出时会触发的方法
- (void)inputKeyboardWillHide:(NSNotification *)noti {
  CGFloat animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

  //inputToolbar恢复原位
  [self.inputToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
     make.bottom.mas_equalTo(- [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom);
  }];
  // 添加动画
  [UIView animateWithDuration:animationDuration animations:^{
     [self layoutIfNeeded];
  }];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.allmessageIdArr.count;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  NSString *messageId = self.allmessageIdArr[indexPath.row];

  QSLog(@"messageId is %@",messageId);
  if (!messageId) {
    QSLog(@"messageId is nil%@",messageId);
    return nil;
  }

  QSIMMessageModel *model = self.allMessageDic[messageId];
  if (!model) {
    QSLog(@"QSIMMessageModel is nil%@", messageId);
    return nil;
  }

  if (model.isTime == YES || model.isErrorMessage) {
    QSShowTimeCell *cell = [QSShowTimeCell cellWithTableView:tableView];
      
    if (model.isErrorMessage) {
        model.timeStr = [NSString stringWithFormat:@"接收消息错误 错误码:%ld", model.messageError.code];
        cell.model = model;
        return cell;
    }

 
    model.timeStr = [JCHATStringUtils getFriendlyDateString:[model.messageTime longLongValue]];
  
    cell.model = model;
    return cell;
  } else {
      if (!model.message.isSelf) {
          QSLeftMessageCell *cell = [QSLeftMessageCell cellWithTableView:tableView];
          cell.messageData = model;
          cell.delegate = self;
//          [JMessage addDelegate:cell withConversation:self.conversation];
          return cell;
      } else {
          QSRightMessageCell *cell = [QSRightMessageCell cellWithTableView:tableView];
          cell.messageData = model;
          cell.delegate = self;
//          [JMessage addDelegate:cell withConversation:self.conversation];
          return cell;
      }
  }
}


#pragma mark --发送文本
- (void)sendText:(NSString *)text {
  [self prepareTextMessage:text];
}

#pragma mark ----发送文本消息
- (void)prepareTextMessage:(NSString *)text {
    if ([text isEqualToString:@""] || text == nil) {
        return;
    }
    if ([NSString isEmpty:text]) {
        return;
    }
    
//    TIMMessage *message = [[TIMMessage alloc] init];
//    TIMTextElem *elem = [[TIMTextElem alloc] init];
//    elem.text = text;
//    if ([message convertToImportedMsg]) {
//        NSDate *datenow = [NSDate date];
//        [message setTime:(long)[datenow timeIntervalSince1970] * 1000];
//    }
    
    NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),
                                  @"type":@"wxIM",
                                  @"userId":[TICConfig shareInstance].userId,
                                  @"userName":TXUserDefaultsGetObjectforKey(Agent),
                                  @"content":text};
    NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
    
    V2TIMMessage *message = [[V2TIMManager sharedInstance] createTextMessage:str];
    QSIMMessageModel *model = [[QSIMMessageModel alloc] init];
    
    NSString *classId = [NSString stringWithFormat:@"%@",TXUserDefaultsGetObjectforKey(RoomId)];

   NSString *msgID = [[V2TIMManager sharedInstance] sendMessage:message receiver:nil groupID:classId priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:nil succ:^{
        QSLog(@"发送成功");
    } fail:^(int code, NSString *desc) {

    }];
    [[V2TIMManager sharedInstance] findMessages:@[msgID] succ:^(NSArray<V2TIMMessage *> *msgs) {
        model.message = [msgs firstObject];
        model.messageTime = [NSNumber numberWithLong:(long)[message.timestamp timeIntervalSince1970] * 1000];
        [self addmessageShowTimeData:model.messageTime];
        [self addMessage:model];
    } fail:^(int code, NSString *desc) {

    }];
//    [[V2TIMMessage sharedInstance] getMessage:<#(int)#> last:<#(TIMMessage *)#> succ:<#^(NSArray *msgs)succ#> fail:<#^(int code, NSString *msg)fail#>]
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)addmessageShowTimeData:(NSNumber *)timeNumber{
  NSString *messageId = [self.allmessageIdArr lastObject];
  QSIMMessageModel *lastModel = self.allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
  if ([self.allmessageIdArr count] > 0 && lastModel.isTime == NO) {
    NSDate *lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
//    NSDate *lastdate = lastModel.message.timestamp;
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      [self addTimeData:timeInterVal];
    }
  } else if ([self.allmessageIdArr count] == 0) {//首条消息显示时间
    [self addTimeData:timeInterVal];
  } else {
    QSLog(@"不用显示时间");
  }
}

#pragma mark --添加message
- (void)addMessage:(QSIMMessageModel *)model {
  if (model.isTime) {
    [self.allMessageDic setObject:model forKey:model.timeId];
    [self.allmessageIdArr addObject:model.timeId];
    [self addCellToTabel];
    return;
  }
  [self.allMessageDic setObject:model forKey:model.message.msgID];
  [self.allmessageIdArr addObject:model.message.msgID];
  [self addCellToTabel];
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)dataMessageShowTime:(NSNumber *)timeNumber{
  NSString *messageId = [self.allmessageIdArr lastObject];
  QSIMMessageModel *lastModel = self.allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  if ([self.allmessageIdArr count]>0 && lastModel.isTime == NO) {
//      NSDate *lastdate = lastModel.message.timestamp;
      NSDate *lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
      
      NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
      NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
      if (fabs(timeBetween) > interval) {
          QSIMMessageModel *timeModel =[[QSIMMessageModel alloc] init];
          timeModel.timeId = [self getTimeId];
          timeModel.isTime = YES;
          timeModel.messageTime = @(timeInterVal);//!
          [self.allMessageDic setObject:timeModel forKey:timeModel.timeId];
          [self.allmessageIdArr addObject:timeModel.timeId];
      }
  } else if ([self.allmessageIdArr count] ==0) {//首条消息显示时间
      QSIMMessageModel *timeModel =[[QSIMMessageModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      [self.allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [self.allmessageIdArr addObject:timeModel.timeId];
  } else {
      QSLog(@"不用显示时间");
  }
}

- (void)dataMessageShowTimeToTop:(NSNumber *)timeNumber {
  NSString *messageId = [self.allmessageIdArr lastObject];
  QSIMMessageModel *lastModel = self.allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  if ([self.allmessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
//      NSDate *lastdate = lastModel.message.timestamp;
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      QSIMMessageModel *timeModel =[[QSIMMessageModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      [self.allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [self.allmessageIdArr insertObject:timeModel.timeId atIndex:0];
    }
  } else if ([self.allmessageIdArr count] ==0) {//首条消息显示时间
    QSIMMessageModel *timeModel =[[QSIMMessageModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    [self.allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [self.allmessageIdArr insertObject:timeModel.timeId atIndex:0];
  } else {
    QSLog(@"不用显示时间");
  }
}

- (void)addTimeData:(NSTimeInterval)timeInterVal {
  QSIMMessageModel *timeModel = [[QSIMMessageModel alloc] init];
  timeModel.timeId = [self getTimeId];
  timeModel.isTime = YES;
  timeModel.messageTime = @(timeInterVal);
  [self addMessage:timeModel];
}

- (NSString *)getTimeId {
  NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
  return timeId;
}

- (void)onTICRecvMessage:(TIMMessage *)message {
    NSString *msgID = message.msgId;
    [[V2TIMManager sharedInstance] findMessages:@[msgID] succ:^(NSArray<V2TIMMessage *> *msgs) {
        V2TIMMessage *v2message = [msgs firstObject];
        if (!v2message.textElem) return;
        
        NSDictionary *dict = [[TXTCommon sharedInstance] dictionaryWithJsonString:v2message.textElem.text];
        if (![dict[@"type"] isEqualToString:@"wxIM"]) return;
        
        QSIMMessageModel *model = [self.allMessageDic objectForKey:v2message.msgID];
        if (model) {// 说明已经加载，说明可能是同步下来的多媒体消息，下载完成，然后再次收到就去刷新
            model.message = v2message;
            [self.allMessageDic setObject:model forKey:model.message.msgID];
        } else {
            NSString *firstMsgId = [self.allmessageIdArr firstObject];
            QSIMMessageModel *firstModel = [self.allMessageDic objectForKey:firstMsgId];
            if (message.timestamp < firstModel.message.timestamp) {
                // 比数组中最老的消息时间都小的，无需加入界面显示，下次翻页时会加载
                return ;
            }
            model = [[QSIMMessageModel alloc] init];
            model.message = v2message;
            model.messageTime = [NSNumber numberWithLong:(long)[v2message.timestamp timeIntervalSince1970] * 1000];
            [self addmessageShowTimeData:model.messageTime];
            [self addMessage:model];
        }
    } fail:^(int code, NSString *desc) {

    }];
}

- (void)onNewMessage:(NSArray *)msgs {
    
    
}

/// 收到新消息
- (void)onRecvNewMessage:(V2TIMMessage *)message {
    if (!message.textElem) return;
    QSIMMessageModel *model = [self.allMessageDic objectForKey:message.msgID];
    if (model) {// 说明已经加载，说明可能是同步下来的多媒体消息，下载完成，然后再次收到就去刷新
        model.message = message;
        [self.allMessageDic setObject:model forKey:model.message.msgID];
    } else {
        NSString *firstMsgId = [self.allmessageIdArr firstObject];
        QSIMMessageModel *firstModel = [self.allMessageDic objectForKey:firstMsgId];
        if (message.timestamp < firstModel.message.timestamp) {
            // 比数组中最老的消息时间都小的，无需加入界面显示，下次翻页时会加载
            return ;
        }
        model = [[QSIMMessageModel alloc] init];
        model.messageTime = [NSNumber numberWithLong:(long)[message.timestamp timeIntervalSince1970] * 1000];
        [self addmessageShowTimeData:model.messageTime];
        [self addMessage:model];
    }
}


/// closeBtnClick
- (void)closeBtnClick {
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(chatViewDidClickCloseBtn:)]) {
        [self.delegate chatViewDidClickCloseBtn:self.closeBtn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    UIRectCorner corners = 0;
    if (![UIWindow isLandscape]) {
        self.layer.mask = nil;
    } else {
        UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        //设置大小
        maskLayer.frame = self.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
}

/** navBgView */
- (UIView *)navBgView {
    if (!_navBgView) {
        UIView *navBgView = [[UIView alloc] init];
        navBgView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        self.navBgView = navBgView;
    }
    return _navBgView;
}
/** titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
//        [NSString stringWithFormat:@"%@",TXUserDefaultsGetObjectforKey(RoomId)]
        UILabel *titleLabel = [UILabel labelWithTitle:@"聊天" color:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_semiFontWithSize:16]];
        self.titleLabel = titleLabel;
    }
    return _titleLabel;
}
/** closeBtn */
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *closeBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(closeBtnClick)];
        [closeBtn setImage:[UIImage imageNamed:@"member_icon_close" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        self.closeBtn = closeBtn;
    }
    return _closeBtn;
}

- (UITableView *)messageTableView {
  if (!_messageTableView) {
    UITableView *messageTableView = [[UITableView alloc] init];
    messageTableView.delegate = self;
    messageTableView.dataSource = self;
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageTableView.showsVerticalScrollIndicator = NO;
    messageTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    messageTableView.tableFooterView = [UIView new];
    messageTableView.estimatedRowHeight = 100;
    messageTableView.rowHeight = UITableViewAutomaticDimension;
    messageTableView.estimatedSectionHeaderHeight = 0;
    messageTableView.estimatedSectionFooterHeight = 0;
      messageTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.messageTableView = messageTableView;
    if (@available(iOS 11.0, *)) {
        self.messageTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
  }
  return _messageTableView;
}

- (QSChatInputToolBar *)inputToolBar {
  if (!_inputToolBar) {
    QSChatInputToolBar *inputToolBar = [[QSChatInputToolBar alloc] init];
//    inputToolBar.layer.shadowColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:192/255.0 alpha:0.16].CGColor;
//    inputToolBar.layer.shadowOffset = CGSizeMake(0,2);
//    inputToolBar.layer.shadowOpacity = 1;
//    inputToolBar.layer.shadowRadius = 10;
      inputToolBar.delegate = self;
    self.inputToolBar = inputToolBar;
  }
  return _inputToolBar;
}

- (NSMutableDictionary *)allMessageDic {
  if (!_allMessageDic) {
    self.allMessageDic = [NSMutableDictionary dictionary];
  }
  return _allMessageDic;
}

- (NSMutableArray *)allmessageIdArr {
  if (!_allmessageIdArr) {
    self.allmessageIdArr = [NSMutableArray array];
  }
  return _allmessageIdArr;
}

@end
