//
//  JoinRoomViewController.m
//  sample
//
//  Created by 洪青文 on 2021/2/2.
//  Copyright © 2021 洪青文. All rights reserved.
//

#import "JoinRoomViewController.h"

#import <TXTWhiteBoard/TXTManage.h>
#import <TXTWhiteBoard/TXTCustomConfig.h>
#import "NSString+TXTAES.h"
#import "BRPickerView.h"
#import "settingViewController.h"
//#import <TXTWhiteBoard/ClassroomViewController.h>

#define QFSharedddAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
@interface JoinRoomViewController ()<TXTManageDelegate>
@property (weak, nonatomic) IBOutlet UITextField *roomId;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIButton *smallbtn;
@property (weak, nonatomic) IBOutlet UIButton *appbtn;
@property (strong, nonatomic) TXTCustomConfig *config;
@property (weak, nonatomic) IBOutlet UITextField *orgName;

@property (strong, nonatomic) NSString *agentId;
@property (strong, nonatomic) NSString *serviceId;
@property (weak, nonatomic) IBOutlet UITextField *text1;//被邀请人
@property (weak, nonatomic) IBOutlet UITextField *text2;//会议id
@property (weak, nonatomic) IBOutlet UITextField *text3;//邀请人

@end

@implementation JoinRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入会议";
    [self.smallbtn setTitle:@"测试环境" forState:UIControlStateNormal];
    [self.appbtn setTitle:@"测试环境" forState:UIControlStateNormal];
    
    self.smallbtn.layer.borderWidth = 0.5;
    self.smallbtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.smallbtn.layer.cornerRadius = 3;
    self.smallbtn.layer.masksToBounds = YES;
    self.appbtn.layer.borderWidth = 0.5;
    self.appbtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.appbtn.layer.cornerRadius = 3;
    self.appbtn.layer.masksToBounds = YES;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.config = [TXTCustomConfig sharedInstance];
    self.config.appid = @"wx8e6096173bff1149";
    self.config.universalLink = @"https://video-sells-test.ikandy.cn/txWhiteBoard/";
    self.config.userName = @"gh_9fd3da8ad9f6";//gh_534ca5cd3ab2
    self.config.miniprogramTitle = @"国寿e店";
    self.config.miniprogramCard = @"国寿e店国寿e店国寿e店国寿e店国寿e店";
    self.config.isShowInviteButton = YES;
    self.config.miniProgramPath = @"pages/index/index";
    self.config.enableVideo = YES;
    self.config.isChat = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationAction:) name:@"addFriendBtListener" object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TXTManage sharedInstance].manageDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationAction:) name:@"addFriendBtListener" object:nil];
}

- (IBAction)joinRoom:(id)sender {
    [self.view endEditing:YES];
    NSString *roomId = self.roomId.text;
    NSString *userName = self.userName.text;
    if ([userName isEqualToString:@""] || userName == nil) {
        
        return;
    }
    
    NSString *orgName = self.orgName.text;
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%@%.0f",orgName,time];
    
    
    //@"gh_9fd3da8ad9f6"
    NSString *smallstr = self.smallbtn.titleLabel.text;
    NSString *miniprogramType = @"1";
    if ([smallstr isEqualToString:@"生产环境"]) {
        miniprogramType = @"2";
    }else if ([smallstr isEqualToString:@"开发环境"]) {
        miniprogramType = @"0";
    }
    
    NSString *appstr = self.appbtn.titleLabel.text;
    NSString *appType = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:@"net02d2geftdt4tj" forKey:@"PSW_AES_KEY"];
    [[NSUserDefaults standardUserDefaults] setObject:@"4kz8rn8a7yxdy9u8" forKey:@"AES_IV_PARAMETER"];
    if ([appstr isEqualToString:@"生产环境"]) {
        appType = @"2";
        [[NSUserDefaults standardUserDefaults] setObject:@"nvvmjk1hi8qlvoy4" forKey:@"PSW_AES_KEY"];
        [[NSUserDefaults standardUserDefaults] setObject:@"fstvas2suhosmvjl" forKey:@"AES_IV_PARAMETER"];
    }else if ([appstr isEqualToString:@"开发环境"]) {
        appType = @"0";
    }
    NSString *sign = [timeString aci_encryptWithAES];
    NSDictionary *addressDict = @{@"adr":@"eeeeeee",@"city":@"ddd111111111",@"latitude":@11.22,@"longitude":@123.9,@"province":@"hhhhhhhhhhhhh",@"accuracy":@1};
    
    self.config.miniprogramType = miniprogramType;
    
    
    [[TXTManage sharedInstance] setEnvironment:appType wechat:self.config appGroup:@"com.tx.txWhiteBoard.ReplaykitUpload"];
    
    
    [[TXTManage sharedInstance] joinRoom:roomId UserId:userName UserName:userName OrgName:orgName SignOrgName:sign EnableVideo:self.config.enableVideo UserHead:@"" BusinessData:nil CallBack:^(int code, NSString * _Nonnull desc) {
        
//        ClassroomViewController *vc = [[ClassroomViewController alloc]init];
//        vc.delegate = self;
//        if (code == 0) {
//
//        }else if(code == 111111111){
//
//        }else{
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:desc preferredStyle:UIAlertControllerStyleAlert];
//
//
//            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                //确认处理
//            }];
//
//
//            [alert addAction:action2];
//            [self.navigationController presentViewController:alert animated:YES completion:nil];
//        }
    }];
    
}
- (IBAction)chooseSmall:(id)sender {
    /// 1.单列字符串选择器（传字符串数组）
    [self.view endEditing:YES];
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.title = @"选择环境";
    stringPickerView.dataSourceArr = @[@"测试环境", @"生产环境",@"开发环境"];
    stringPickerView.selectIndex = 0;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        NSLog(@"选择的值：%@", resultModel.value);
        [self.smallbtn setTitle:resultModel.value forState:UIControlStateNormal];
    };
    [stringPickerView show];
}
- (IBAction)chooseApp:(id)sender {
    [self.view endEditing:YES];
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.title = @"选择环境";
    stringPickerView.dataSourceArr = @[@"测试环境", @"生产环境",@"开发环境"];
    stringPickerView.selectIndex = 0;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        NSLog(@"选择的值：%@", resultModel.value);
        [self.appbtn setTitle:resultModel.value forState:UIControlStateNormal];
    };
    
    [stringPickerView show];
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.roomId resignFirstResponder];
    [self.userName resignFirstResponder];
    [self.text1 resignFirstResponder];
    [self.text2 resignFirstResponder];
    [self.text3 resignFirstResponder];
}

- (void)setting{
    [self.view endEditing:YES];
    
    settingViewController *vc = [[settingViewController alloc] initWithNibName:@"settingViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
//    NSString *roomId = self.roomId.text;
//    NSString *userName = self.userName.text;
//    if ([userName isEqualToString:@""] || userName == nil) {
//
//        return;
//    }
//
//    NSString *orgName = self.orgName.text;
//
//    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
//    NSTimeInterval time=[date timeIntervalSince1970];
//    NSString *timeString = [NSString stringWithFormat:@"%@%.0f",orgName,time];
//
//
//    //@"gh_9fd3da8ad9f6"
//    NSString *smallstr = self.smallbtn.titleLabel.text;
//    NSString *miniprogramType = @"1";
//    if ([smallstr isEqualToString:@"生产环境"]) {
//        miniprogramType = @"2";
//    }else if ([smallstr isEqualToString:@"开发环境"]) {
//        miniprogramType = @"0";
//    }
//
//    NSString *appstr = self.appbtn.titleLabel.text;
//    NSString *appType = @"1";
//    [[NSUserDefaults standardUserDefaults] setObject:@"net02d2geftdt4tj" forKey:@"PSW_AES_KEY"];
//    [[NSUserDefaults standardUserDefaults] setObject:@"4kz8rn8a7yxdy9u8" forKey:@"AES_IV_PARAMETER"];
//    if ([appstr isEqualToString:@"生产环境"]) {
//        appType = @"2";
//        [[NSUserDefaults standardUserDefaults] setObject:@"nvvmjk1hi8qlvoy4" forKey:@"PSW_AES_KEY"];
//        [[NSUserDefaults standardUserDefaults] setObject:@"fstvas2suhosmvjl" forKey:@"AES_IV_PARAMETER"];
//    }else if ([appstr isEqualToString:@"开发环境"]) {
//        appType = @"0";
//    }
//    NSString *sign = [timeString aci_encryptWithAES];
//    NSDictionary *addressDict = @{@"adr":@"eeeeeee",@"city":@"ddd111111111",@"latitude":@11.22,@"longitude":@123.9,@"province":@"hhhhhhhhhhhhh",@"accuracy":@1};
//
//    self.config.miniprogramType = miniprogramType;
//
//
//    [[TXTManage sharedInstance] setEnvironment:appType wechat:self.config appGroup:@"com.tx.txWhiteBoard.ReplaykitUpload"];
//    NSString *ser = [[NSUserDefaults standardUserDefaults] objectForKey:@"testserviceId"];
//    [[TXTManage sharedInstance] getAgentAndRoomStatus:userName AndServiceId:ser OrgName:orgName SignOrgName:sign CallBack:^(int code, NSString * _Nonnull desc) {
//        NSLog(@"%@",desc);
//    }];
}

- (void)addFriendBtListener:(NSString *)roomId AndserviceId:(NSString *)serviceId inviteAccount:(NSString *)userId{
    NSLog(@"addFriendBtListener00000");
    NSLog(@"%@",self);
}



- (void)getNotificationAction:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];
    // 这样就得到了我们在发送通知时候传入的字典了
    NSLog(@"分享成功");
    NSString *roomId = [infoDic valueForKey:@"inviteNumber"];
    NSString *serviceId = [infoDic valueForKey:@"ServiceId"];
    NSString *userId = [infoDic valueForKey:@"inviteAccount"];
    NSLog(@"%@--%@--%@",roomId,serviceId,userId);
    self.agentId = userId;
    self.serviceId = serviceId;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:serviceId message:@"确认转发" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[TXTManage sharedInstance] startVideo:@"" OrgName:@"" SignOrgName:@"" BusinessData:@{@"test":@"2"} CallBack:^(int code, NSString * _Nonnull desc) {
//            if (code == 0) {
//            }else{
//
//            }
//        }];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //确认处理
//        [[TXTManage sharedInstance] startVideo:@"" OrgName:@"" SignOrgName:@"" BusinessData:@{@"test":@"2"} CallBack:^(int code, NSString * _Nonnull desc) {
//            if (code == 0) {
//            }else{
//
//            }
//        }];
    }];
    [alert addAction:action2];
    [alert addAction:action3];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)onFriendBtListener:(NSString *)roomId AndserviceId:(NSString *)serviceId inviteAccount:(nonnull NSString *)userId{
    NSLog(@"分享成功");
    NSLog(@"%@--%@--%@",roomId,serviceId,userId);
    self.agentId = userId;
    self.serviceId = serviceId;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认转发" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[TXTManage sharedInstance] startVideo:@"" OrgName:@"" SignOrgName:@"" UserHead:@"" BusinessData:@{@"test":@"2"} CallBack:^(int code, NSString * _Nonnull desc) {
            if (code == 0) {
            }else{

            }
        }];

    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //确认处理
        [[TXTManage sharedInstance] startVideo:@"" OrgName:@"" SignOrgName:@"" UserHead:@"" BusinessData:@{@"test":@"2"} CallBack:^(int code, NSString * _Nonnull desc) {
            if (code == 0) {
            }else{

            }
        }];
    }];
    [alert addAction:action2];
    [alert addAction:action3];
    [self.navigationController presentViewController:alert animated:YES completion:nil];

}

//拒绝
- (IBAction)getMessage:(id)sender {
    self.agentId=@"bbb";
    NSString *orgName = self.orgName.text;
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%@%.0f",orgName,time];
    
    
    //@"gh_9fd3da8ad9f6"
    NSString *smallstr = self.smallbtn.titleLabel.text;
    NSString *miniprogramType = @"1";
    if ([smallstr isEqualToString:@"生产环境"]) {
        miniprogramType = @"2";
    }else if ([smallstr isEqualToString:@"开发环境"]) {
        miniprogramType = @"0";
    }
    
    NSString *appstr = self.appbtn.titleLabel.text;
    NSString *appType = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:@"net02d2geftdt4tj" forKey:@"PSW_AES_KEY"];
    [[NSUserDefaults standardUserDefaults] setObject:@"4kz8rn8a7yxdy9u8" forKey:@"AES_IV_PARAMETER"];
    if ([appstr isEqualToString:@"生产环境"]) {
        appType = @"2";
        [[NSUserDefaults standardUserDefaults] setObject:@"nvvmjk1hi8qlvoy4" forKey:@"PSW_AES_KEY"];
        [[NSUserDefaults standardUserDefaults] setObject:@"fstvas2suhosmvjl" forKey:@"AES_IV_PARAMETER"];
    }else if ([appstr isEqualToString:@"开发环境"]) {
        appType = @"0";
    }
    NSString *sign = [timeString aci_encryptWithAES];
    
    [[TXTManage sharedInstance] setAgentInRoomStatus:self.agentId UserName:self.text1.text AndServiceId:self.text2.text InviteAccount:@"aaa" AndAction:@"invited" OrgName:orgName SignOrgName:sign CallBack:^(int code, NSString * _Nonnull desc) {
        if (code == 0) {
            [[TXTManage sharedInstance] setAgentInRoomStatus:self.agentId UserName:self.text1.text AndServiceId:self.text2.text InviteAccount:@"aaa" AndAction:@"refused" OrgName:orgName SignOrgName:sign CallBack:^(int code, NSString * _Nonnull desc) {
                            
            }];
        }
        
    }];
    
//    [[TXTManage sharedInstance] setAgentInRoomStatus:self.agentId AndAction:@"invited" OrgName:orgName SignOrgName:sign CallBack:^(int code, NSString * _Nonnull desc) {
//        [[TXTManage sharedInstance] setAgentInRoomStatus:self.agentId AndAction:@"refused" OrgName:orgName SignOrgName:sign CallBack:^(int code, NSString * _Nonnull desc) {
//
//        }];
//    }];
}

//接受
- (IBAction)setMessage:(id)sender {
//    if (self.agentId == nil || [self.agentId isEqualToString:@""]) {
//        return;
//    }
    NSString *orgName = self.orgName.text;
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%@%.0f",orgName,time];
    
    
    //@"gh_9fd3da8ad9f6"
    NSString *smallstr = self.smallbtn.titleLabel.text;
    NSString *miniprogramType = @"1";
    if ([smallstr isEqualToString:@"生产环境"]) {
        miniprogramType = @"2";
    }else if ([smallstr isEqualToString:@"开发环境"]) {
        miniprogramType = @"0";
    }
    
    NSString *appstr = self.appbtn.titleLabel.text;
    NSString *appType = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:@"net02d2geftdt4tj" forKey:@"PSW_AES_KEY"];
    [[NSUserDefaults standardUserDefaults] setObject:@"4kz8rn8a7yxdy9u8" forKey:@"AES_IV_PARAMETER"];
    if ([appstr isEqualToString:@"生产环境"]) {
        appType = @"2";
        [[NSUserDefaults standardUserDefaults] setObject:@"nvvmjk1hi8qlvoy4" forKey:@"PSW_AES_KEY"];
        [[NSUserDefaults standardUserDefaults] setObject:@"fstvas2suhosmvjl" forKey:@"AES_IV_PARAMETER"];
    }else if ([appstr isEqualToString:@"开发环境"]) {
        appType = @"0";
    }
    NSString *sign = [timeString aci_encryptWithAES];
    [[TXTManage sharedInstance] setAgentInRoomStatus:@"aaa" UserName:self.text1.text AndServiceId:self.text2.text InviteAccount:@"aaa" AndAction:@"invited" OrgName:orgName SignOrgName:sign CallBack:^(int code, NSString * _Nonnull desc) {
            
    }];
 
}



@end
