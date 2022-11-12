//
//  TXTMemberView.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/5.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTMemberView.h"
#import "TXTSearchMemberCell.h"
#import "TXTTextField.h"
#import "TXTMemberInfoView.h"
#import "QSTapGestureRecognizer.h"
#import "TXTAlertShareView.h"
#import "WXApi.h"
#import "TXTCustomConfig.h"
#import "TXTCommonAlertView.h"

@interface TXTMemberView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
/** closeBtn */
@property (nonatomic, strong) UIButton *closeBtn;
/** textField */
@property (nonatomic, strong) TXTTextField *textField;
/** cancelBtn */
@property (nonatomic, strong) UIButton *cancelBtn;
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** allMuteBtn */
@property (nonatomic, strong) UIButton *allMuteBtn;
/** allUnmuteBtn */
@property (nonatomic, strong) UIButton *allUnmuteBtn;
/** invitationBtn */
@property (nonatomic, strong) UIButton *invitationBtn;

/** dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** searchedArray */
@property (nonatomic, strong) NSArray *searchedArray;

/** keyWord */
@property (nonatomic, copy) NSString *keyWord;
@end

@implementation TXTMemberView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.keyWord = nil;
        self.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        [self setupUI];
        
        // 添加textField改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
        
        QSTapGestureRecognizer *gesture =[[QSTapGestureRecognizer alloc] initWithTarget:self action:@selector(tipClick)];
      //    gesture.cancelsTouchesInView = NO;
        [self addGestureRecognizer:gesture];
    }
    return self;
}
/// tipClick
- (void)tipClick {
    [self endEditing:YES];
}

#pragma mark - Setup UI
/**
 *  setupUI
 */
- (void)setupUI {
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        make.height.mas_equalTo(23);
        make.top.mas_equalTo(15);
    }];
    
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(56);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
        make.top.mas_equalTo(64);
    }];
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-15);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-60);
    }];
    
    [self addSubview:self.allUnmuteBtn];
    [self.allUnmuteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).priorityHigh();
        make.width.mas_equalTo(125);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
        make.height.mas_equalTo(35);
    }];
    
    [self addSubview:self.allMuteBtn];
    [self.allMuteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.equalTo(self.allUnmuteBtn.mas_left).offset(-10);
        make.top.height.equalTo(self.allUnmuteBtn);
    }];
    [self addSubview:self.invitationBtn];
    [self.invitationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.equalTo(self.allUnmuteBtn.mas_right).offset(10);
        make.top.height.equalTo(self.allUnmuteBtn);
    }];
    
    if (![UIWindow isLandscape]) {
        [self updateUI:YES];
    } else {
        [self updateUI:NO];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    if (![UIWindow isLandscape]) {
        corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)updateUI:(BOOL)isPortrait {
    if (isPortrait) {
        [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(56);
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
            make.height.mas_equalTo(40);
        }];
        [self.allUnmuteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).priorityHigh();
            make.width.mas_equalTo(125);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
            make.height.mas_equalTo(35);
        }];
    } else {
        [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(56);
            make.centerY.equalTo(self.titleLabel);
            make.left.equalTo(self.mas_left);
            make.height.mas_equalTo(40);
        }];
        [self.allUnmuteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(15).priorityHigh();
            make.width.mas_equalTo(120);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
            make.height.mas_equalTo(35);
        }];
    }
//    [self layoutIfNeeded];
}

- (void)setManageMembersArr:(NSMutableArray *)manageMembersArr {
    _manageMembersArr = [manageMembersArr copy];
    self.titleLabel.text = [NSString stringWithFormat:@"成员（%zd）", manageMembersArr.count];
    [self getTableData];
}

- (void)getTableData {
    [self.dataArray removeAllObjects];
    if (self.keyWord.length > 0) {
        for (TXTUserModel *model in self.searchedArray) {
            [self.dataArray addObject:model];
        }
        if (self.dataArray.count > 0) {
            self.tableView.tableFooterView = nil;
        } else {
            [self setupFooterView];
        }
        
    } else {
        for (TXTUserModel *model in self.manageMembersArr) {
            [self.dataArray addObject:model];
        }
        self.tableView.tableFooterView = nil;
    }
    [self.tableView reloadData];
}

/// setupFooterView
- (void)setupFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:self.tableView.bounds];
//    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.tableView);
//    }];
    self.tableView.tableFooterView = footerView;
    
    UILabel *tipLabel = [UILabel labelWithTitle:@"暂无搜索结果" color:[UIColor colorWithHexString:@"999999"] font:[UIFont qs_regularFontWithSize:14]];
    [footerView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView);
        make.centerY.equalTo(footerView);
    }];
}

/// closeBtnClick
- (void)closeBtnClick {
    self.keyWord = nil;
    self.searchedArray = nil;
    if ([self.delegate respondsToSelector:@selector(memberViewDidClickCloseBtn:)]) {
        [self.delegate memberViewDidClickCloseBtn:self.closeBtn];
    }
}

/// cancelBtnClick
- (void)cancelBtnClick {
    self.keyWord = nil;
    [self.textField resignFirstResponder];
    self.searchedArray = nil;
    [self getTableData];
}

/// allMuteBtnClick
- (void)allMuteBtnClick {
//    TXTCommonAlertView *alert = [TXTCommonAlertView alertWithTitle:@"所有参会人员将被静音" titleColor:nil titleFont:nil leftBtnStr:@"取消" rightBtnStr:@"确定" leftColor:nil rightColor:nil];
    TXTCommonAlertView *alert = [TXTCommonAlertView alertWithTitle:@"所有参会人员将被静音" message:@"允许参会人员自行解除静音" leftBtnStr:@"取消" rightBtnStr:@"确定" leftColor:nil rightColor:nil];
    alert.sureBlock = ^{
        [TXTCommonAlertView hide];
 
        NSMutableArray *usersArr = [NSMutableArray array];
        for (TXTUserModel *usermodel in self.manageMembersArr) {
            NSDictionary *dict = @{@"userId":usermodel.render.userId,@"muteAudio":@YES};
            [usersArr addObject:dict];
        }
        NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":@"muteAudio",@"agentId":TXUserDefaultsGetObjectforKey(AgentId),@"users":usersArr};
        NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
        [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
            if (code == 0) {
                 NSLog(@"消息发送成功");
            }
//            [self getTableData];
            [self setSoundStatus:NO];
        }];
    };
}

/// allUnMuteBtnClick
- (void)allUnMuteBtnClick {
    NSMutableArray *usersArr = [NSMutableArray array];
    for (TXTUserModel *usermodel in self.manageMembersArr) {
        NSDictionary *dict = @{@"userId":usermodel.render.userId,@"muteAudio":@NO};
        [usersArr addObject:dict];
    }
    NSDictionary *messagedict = @{@"serviceId":TXUserDefaultsGetObjectforKey(ServiceId),@"type":@"muteAudio",@"agentId":TXUserDefaultsGetObjectforKey(AgentId),@"users":usersArr};
    NSString *str = [[TXTCommon sharedInstance] convertToJsonData:messagedict];
    [[TICManager sharedInstance] sendGroupTextMessage:str callback:^(TICModule module, int code, NSString *desc) {
        if(code == 0){
             [[JMToast sharedToast] showDialogWithMsg:@"当前全体静音已解除，参会人本人可控制静音状态"];
        }
//        [self getTableData];
        [self setSoundStatus:YES];
    }];
}

- (void)setSoundStatus:(BOOL)soundStatus{
    NSString *serviceId = TXUserDefaultsGetObjectforKey(ServiceId);
    NSDictionary *bodyDict = @{@"serviceId":serviceId,@"soundStatus":@(soundStatus)};
    [[AFNHTTPSessionManager shareInstance] requestURL:ServiceRoom_SoundStatus RequestWay:@"POST" Header:nil Body:bodyDict params:nil isFormData:NO success:^(NSError *error, id response) {
        NSLog(@"soundStatus == %@",[response description]);
    } failure:^(NSError *error, id response) {
        [[JMToast sharedToast] showDialogWithMsg:@"网络连接错误"];
    }];
}

/// invitationBtnClick
- (void)invitationBtnClick {
    TXTAlertShareView *alert = [TXTAlertShareView alert];
    alert.sureBlock = ^{
        [TXTAlertShareView hide];
        
        WXMiniProgramObject *object = [WXMiniProgramObject object];
        object.webpageUrl = @"";
        object.userName = TXUserDefaultsGetObjectforKey(ShareLink);
        NSDictionary *shareConfig = @{@"version":TXTVersion,@"terminal":@"iOS",@"title":@"智慧展业"};
        if ([[TXTCustomConfig sharedInstance].miniProgramPath isEqualToString:@""] || [TXTCustomConfig sharedInstance].miniProgramPath == nil) {
            [TXTCustomConfig sharedInstance].miniProgramPath = @"pages/index/index";
        }
        NSString *path = [NSString stringWithFormat:@"%@?serviceId=%@&agentId=%@&inviteNumber=%@&shareConfig=%@",[TXTCustomConfig sharedInstance].miniProgramPath,TXUserDefaultsGetObjectforKey(ServiceId),TXUserDefaultsGetObjectforKey(AgentId),TXUserDefaultsGetObjectforKey(InviteNumber),[[TXTCommon sharedInstance] convertToJsonData:shareConfig]];
        NSLog(@"chooseWeChat = %@",path);
        object.path = path;
        UIImage *logoimg = [UIImage imageNamed:@"smallLogo" inBundle:TXSDKBundle compatibleWithTraitCollection:nil];
        object.hdImageData = UIImagePNGRepresentation(logoimg);
        object.withShareTicket = NO;
        NSString *environment = TXUserDefaultsGetObjectforKey(MiniEnvironment);
        if ([environment isEqualToString:@"1"]) {
            object.miniProgramType = WXMiniProgramTypePreview;
        }else if ([environment isEqualToString:@"2"]){
            object.miniProgramType = WXMiniProgramTypeRelease;
        }else if ([environment isEqualToString:@"0"]){
            object.miniProgramType = WXMiniProgramTypeTest;
        }else{
            object.miniProgramType = WXMiniProgramTypePreview;
        }
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"智慧展业-足不出户，随时联系您的顾问";
        message.description = @"智慧展业-足不出户，随时联系您的顾问";
        message.thumbData = nil;  //兼容旧版本节点的图片，小于32KB，新版本优先
                                  //使用WXMiniProgramObject的hdImageData属性
        message.mediaObject = object;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;  //目前只支持会话
        [WXApi sendReq:req completion:^(BOOL success) {
            if (success) {

            }else{

            }
        }];
    };
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    TXTSearchMemberCell *cell = [TXTSearchMemberCell cellWithTableView:tableView];
    cell.keyWord = self.keyWord;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TXTSearchMemberCell *cell = (TXTSearchMemberCell *)[tableView cellForRowAtIndexPath:indexPath];
    TXTMemberInfoView *infoView = [TXTMemberInfoView alertWithUserModel:cell.model];
    infoView.sureBlock = ^{
        if ([self.delegate respondsToSelector:@selector(memberViewDidUpdateInfo:)]) {
            [self.delegate memberViewDidUpdateInfo:cell.model];
        }
        [TXTMemberInfoView hide];
        [tableView reloadData];
    };
}

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-55);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-15);
    }];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.searchedArray = nil;
    [self getTableData];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *newStr = textField.text;
//    newStr = [newStr stringByReplacingCharactersInRange:range withString:string];
//    if (newStr.length <= 20) {
//        textField.text = newStr;
//    }
//
////    if (textField.hasText) {
////        // 开始模糊搜索
////        if ([NSString isEmpty:textField.text]) {
////            return NO;
////        }
////        self.keyWord = textField.text;
////        [self searchCustomers:self.dataArray withSearchText:textField.text];
////
////    } else {
////        self.searchedArray = nil;
////        self.keyWord = nil;
////        [self getTableData];
////    }
//    return NO;
//}

- (void)textFieldDidTextChange:(UITextField *)textField {
    if (textField != self.textField) return;
    if (textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
    }
    if (textField.hasText) {
        self.keyWord = textField.text;
        // 开始模糊搜索
//        if (self.keyWord) {
//           self.searchedArray = pois;
//        } else {
//            self.searchedArray = nil;
//        }
//        [self getTableData];
        if ([NSString isEmpty:textField.text]) {
            return;
        }
        [self searchCustomers:self.manageMembersArr withSearchText:textField.text];

    } else {
        self.searchedArray = nil;
        self.keyWord = nil;
        [self getTableData];
    }
}


- (void)searchCustomers:(NSArray *)customers withSearchText:(NSString *)searchText {
    NSMutableArray *searchItems = [NSMutableArray array];
    for (TXTUserModel *customer in customers) {
        if ([customer.userName containsString:searchText]) {
            [searchItems addObject:customer];
        }
    }
    self.searchedArray = searchItems;
    [self getTableData];
}

/** titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel labelWithTitle:@"成员（0）" color:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_semiFontWithSize:16]];
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
/** textField */
- (TXTTextField *)textField {
    if (!_textField) {
        TXTTextField *textField = [[TXTTextField alloc] init];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.textColor = [UIColor colorWithHexString:@"333333"];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索成员" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"CCCCCC"]}];
        textField.tintColor = [UIColor colorWithHexString:@"E6B980"];
//        [[textField valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"member_icon_searchClear" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 31, 30)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 16, 16)];
        imageView.image = [UIImage imageNamed:@"member_icon_search" inBundle:TXTSDKBundle compatibleWithTraitCollection:nil];
        [leftView addSubview:imageView];
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewModeAlways;
//        textField.returnKeyType = UIReturnKeyDone;
        textField.font = [UIFont qs_regularFontWithSize:12];
        textField.delegate = self;
        [textField addTarget:self action:@selector(textFieldDidTextChange:) forControlEvents:UIControlEventEditingChanged];
        textField.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        textField.cornerRadius = 5;
        self.textField = textField;
    }
    return _textField;
}

/** cancelBtn */
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        UIButton *cancelBtn = [UIButton buttonWithTitle:@"取消" titleColor:[UIColor colorWithHexString:@"E6B980"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(cancelBtnClick)];
        self.cancelBtn = cancelBtn;
    }
    return _cancelBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.tableView = tableView;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

/** allMuteBtn */
- (UIButton *)allMuteBtn {
    if (!_allMuteBtn) {
        UIButton *allMuteBtn = [UIButton buttonWithTitle:@"全员静音" titleColor:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(allMuteBtnClick)];
        allMuteBtn.borderColor = [UIColor colorWithHexString:@"D6D6D6" alpha:0.8];
        allMuteBtn.borderWidth = 1;
        allMuteBtn.cornerRadius = 5;
        self.allMuteBtn = allMuteBtn;
    }
    return _allMuteBtn;
}
/** allUnmuteBtn */
- (UIButton *)allUnmuteBtn {
    if (!_allUnmuteBtn) {
        UIButton *allUnmuteBtn = [UIButton buttonWithTitle:@"解除全员静音" titleColor:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(allUnMuteBtnClick)];
        allUnmuteBtn.borderColor = [UIColor colorWithHexString:@"D6D6D6" alpha:0.8];
        allUnmuteBtn.borderWidth = 1;
        allUnmuteBtn.cornerRadius = 5;
        self.allUnmuteBtn = allUnmuteBtn;
    }
    return _allUnmuteBtn;
}
/** invitationBtn */
- (UIButton *)invitationBtn {
    if (!_invitationBtn) {
        UIButton *invitationBtn = [UIButton buttonWithTitle:@"邀请" titleColor:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(invitationBtnClick)];
        invitationBtn.borderColor = [UIColor colorWithHexString:@"D6D6D6" alpha:0.8];
        invitationBtn.borderWidth = 1;
        invitationBtn.cornerRadius = 5;
        self.invitationBtn = invitationBtn;
    }
    return _invitationBtn;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
