//
//  TXTSmallMessageView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/4.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTSmallMessageView.h"
#import "TXTSmallMessageCell.h"

@interface TXTSmallMessageView () <UITableViewDelegate, UITableViewDataSource, TICMessageListener>
/** tableView */
@property (nonatomic, strong) UITableView *messageTableView;

/** dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TXTSmallMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
        [[TICManager sharedInstance] addIMessageListener:self];
    }
    return self;
}

#pragma mark - Setup UI
/**
 *  setupUI
 */
- (void)setupUI {
    [self addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

/// 添加消息
- (void)addMessage:(NSString *)message {
    if (self.dataArray.count >= 3) {
        [self.dataArray removeObjectAtIndex:0];
    }
    [self.dataArray addObject:message];
    [self.messageTableView reloadData];
    [self scrollToEnd];
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
        NSDictionary *dict = [[TXTCommon sharedInstance] dictionaryWithJsonString:v2message.textElem.text];
        if (![dict[@"type"] isEqualToString:@"wxIM"]) return;
        if (self.dataArray.count >= 3) {
            [self.dataArray removeObjectAtIndex:0];
        }
        [self.dataArray addObject:v2message.textElem.text];
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
        messageTableView.backgroundColor = [UIColor colorWithHexString:@"F8F9FB"];
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
