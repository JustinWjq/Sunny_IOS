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
        make.left.right.equalTo(self);
        make.height.mas_equalTo(23);
        make.top.mas_equalTo(15);
    }];
    
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(56);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
        make.top.mas_equalTo(64);
    }];
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-60);
    }];
    
    [self addSubview:self.allUnmuteBtn];
    [self.allUnmuteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
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
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
        [self updateUI:YES];
    } else {
        [self updateUI:NO];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown) {
        corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(20, 20)];
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
            make.right.equalTo(self);
            make.height.mas_equalTo(40);
        }];
        [self.allUnmuteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.mas_equalTo(125);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
            make.height.mas_equalTo(35);
        }];
    } else {
        [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(56);
            make.centerY.equalTo(self.titleLabel);
            make.left.equalTo(self);
            make.height.mas_equalTo(40);
        }];
        [self.allUnmuteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(15);
            make.width.mas_equalTo(120);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
            make.height.mas_equalTo(35);
        }];
    }
    [self layoutIfNeeded];
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
    
}

/// invitationBtnClick
- (void)invitationBtnClick {
    
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
    [TXTMemberInfoView alertWithUserModel:cell.model];
}

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-55);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
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
        UIButton *allUnmuteBtn = [UIButton buttonWithTitle:@"解除全员静音" titleColor:[UIColor colorWithHexString:@"333333"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(allMuteBtnClick)];
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
