//
//  TXTSmallMessageView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/4.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTSmallMessageView.h"
#import "TXTSmallMessageCell.h"
#import "TXTSmallMessage.h"
#import "YYModel.h"

@interface TXTSmallMessageView () <UITableViewDelegate, UITableViewDataSource, TICMessageListener>
/** tableView */
@property (nonatomic, strong) UITableView *messageTableView;

/** dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;

/** dataArray */
@property (nonatomic, strong) NSMutableDictionary *dataDic;

/** count */
@property (nonatomic, assign) NSInteger count;
@end

@implementation TXTSmallMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.hidden = YES;
        [[TICManager sharedInstance] addIMessageListener:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postMessage:) name:@"POSTMessage" object:nil];
    }
    return self;
}

/// 别人发送消息
- (void)postMessage:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    V2TIMMessage *message = dict[@"POSTMessage"];
    if (!message.textElem) return;
    [self addMessage:message.textElem.text];
}

#pragma mark - Setup UI
/**
 *  setupUI
 */
- (void)setupUI {
    [self addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(0);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)endPolling {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    });
}

- (void)countDown {
    self.count -= 1;
    if (self.count <= 0.01) {
        [self endPolling];
        self.hidden = YES;
        [self.dataArray removeAllObjects];
    } else {
        [self performSelector:@selector(countDown) withObject:nil afterDelay:1.0];
    }
}


/// 添加消息
- (void)addMessage:(NSString *)message {
    [self endPolling];
    self.hidden = NO;
    self.count = 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self countDown];
    });
    if (self.dataArray.count >= 3) {
        [self.dataArray removeObjectAtIndex:0];
    }
    [self.dataArray addObject:message];
    CGFloat tableViewH = 0;
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *dict = [[TXTCommon sharedInstance] dictionaryWithJsonString:self.dataArray[i]];
        TXTSmallMessage *msg = [TXTSmallMessage yy_modelWithDictionary:dict];
        tableViewH += [msg cellH];
    }
    [self.messageTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableViewH);
    }];
    [self.messageTableView reloadData];
    [self scrollToEnd];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    TXTSmallMessageCell *cell = [TXTSmallMessageCell cellWithTableView:tableView];
    cell.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)onTICRecvMessage:(TIMMessage *)message {
    NSString *msgID = message.msgId;
    [[V2TIMManager sharedInstance] findMessages:@[msgID] succ:^(NSArray<V2TIMMessage *> *msgs) {
        V2TIMMessage *v2message = [msgs firstObject];
        if (!v2message.textElem) return;
        
        NSLog(@"v2message.textElem === %@", v2message);
        
        NSDictionary *dict = [[TXTCommon sharedInstance] dictionaryWithJsonString:v2message.textElem.text];
        
        if (![dict[@"type"] isEqualToString:@"wxIM"]) return;
//        if (self.dataArray.count >= 3) {
//            [self.dataArray removeObjectAtIndex:0];
//        }
//        [self.dataArray addObject:v2message.textElem.text];
        
        //防止出现重复的判断
        if(v2message.msgID != nil && ![@"" isEqualToString:v2message.msgID]) {
            NSString *vl = [self.dataDic objectForKey:v2message.msgID];
            if(vl != nil) {
                return;
            }
            [self.dataDic setObject:@"1" forKey:v2message.msgID];
        }
    
        [self addMessage:v2message.textElem.text];
        
        [self.messageTableView reloadData];
        [self scrollToEnd];
//        [self addCellToTabel];
    } fail:^(int code, NSString *desc) {
        
    }];
}

- (void)addCellToTabel {
    QSLog(@"%lf----%lf",self.messageTableView.contentOffset.y,self.messageTableView.contentSize.height - self.messageTableView.height);
    NSIndexPath *path = [NSIndexPath indexPathForRow:[self.dataArray count]-1 inSection:0];
    [self.messageTableView beginUpdates];
    [self.messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    [self.messageTableView endUpdates];
    [self layoutIfNeeded];
    [self scrollToEnd];
}

- (void)scrollToEnd {
  if ([self.dataArray count] != 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  }
}

- (UITableView *)messageTableView {
    if (!_messageTableView) {
        UITableView *messageTableView = [[UITableView alloc] init];
        messageTableView.delegate = self;
        messageTableView.dataSource = self;
        messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        messageTableView.showsVerticalScrollIndicator = NO;
        messageTableView.backgroundColor = [UIColor clearColor];
        messageTableView.tableFooterView = [UIView new];
        messageTableView.estimatedRowHeight = 100;
        messageTableView.rowHeight = UITableViewAutomaticDimension;
        messageTableView.estimatedSectionHeaderHeight = 0;
        messageTableView.estimatedSectionFooterHeight = 0;
          messageTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        messageTableView.userInteractionEnabled = NO;
        self.messageTableView = messageTableView;
        if (@available(iOS 11.0, *)) {
            self.messageTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _messageTableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        self.dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
@end
