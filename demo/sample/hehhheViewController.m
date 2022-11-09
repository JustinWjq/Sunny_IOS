//
//  hehhheViewController.m
//  txWhiteBoardSample
//
//  Created by 洪青文 on 2020/9/3.
//  Copyright © 2020 洪青文. All rights reserved.
//

#import "hehhheViewController.h"

#import <TXTWhiteBoard/TXTManage.h>
#import <TXTWhiteBoard/TXTCustomConfig.h>
#import "NSString+TXTAES.h"
#import "BRPickerView.h"
#import "settingViewController.h"


@interface hehhheViewController ()
@property (weak, nonatomic) IBOutlet UITextField *agentName;
@property (weak, nonatomic) IBOutlet UITextField *orgName;
@property (weak, nonatomic) IBOutlet UILabel *smalllab;
@property (weak, nonatomic) IBOutlet UILabel *phonelab;
@property (weak, nonatomic) IBOutlet UIButton *smallbtn;
@property (weak, nonatomic) IBOutlet UIButton *appbtn;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@property (strong, nonatomic) TXTCustomConfig *config;

@end

@implementation hehhheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号登录";
    [self.smallbtn setTitle:@" 生产环境" forState:UIControlStateNormal];
    [self.appbtn setTitle:@" 测试环境" forState:UIControlStateNormal];
//    self.phonelab.text = @"app是生产环境";
    self.smallbtn.layer.borderWidth = 0.5;
    self.smallbtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.smallbtn.layer.cornerRadius = 3;
    self.smallbtn.layer.masksToBounds = YES;
    self.appbtn.layer.borderWidth = 0.5;
    self.appbtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.appbtn.layer.cornerRadius = 3;
    self.appbtn.layer.masksToBounds = YES;
    
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.config = [TXTCustomConfig sharedInstance];
    self.config.appid = @"wx8e6096173bff1149";//wx8ac1db9b5f5e385e  wx8e6096173bff1149
    self.config.universalLink = @"https://video-sells-test.ikandy.cn/txWhiteBoard/";
    self.config.userName = @"gh_c7b7987a7660";//gh_534ca5cd3ab2
    self.config.miniprogramTitle = @"智慧展业-足不出户，随时联系您的顾问";
    self.config.miniprogramCard = @"智慧展业-足不出户，随时联系您的顾问";
    self.config.isShowInviteButton = YES;
    self.config.isShowTemporaryButton = YES;
    self.config.miniProgramPath = @"components/PromoteBusiness/pages/index/index";
    self.config.enableVideo = YES;
    self.config.isChat = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.route isEqualToString:@"creat"]) {
        [self.actionBtn setTitle:@"预约会议" forState:UIControlStateNormal];
    }else{
        [self.actionBtn setTitle:@"开始会议" forState:UIControlStateNormal];
    }
}


- (IBAction)start:(id)sender {
    [self.view endEditing:YES];
    NSString *agentName = self.agentName.text;
    NSString *orgName = self.orgName.text;
    if ([agentName isEqualToString:@""] || agentName == nil) {
        
        return;
    }
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%@%.0f",orgName,time];
    //    NSString *sign = [timeString aci_encryptWithAES];
    
    
    //@"gh_9fd3da8ad9f6"
    NSString *smallstr = self.smallbtn.titleLabel.text;
    NSString *miniprogramType = @"1";
//    if ([smallstr isEqualToString:@" 生产环境"]) {
//        miniprogramType = @"2";
//    }else if ([smallstr isEqualToString:@" 开发环境"]) {
//        miniprogramType = @"0";
//    }
    
    NSString *appstr = self.appbtn.titleLabel.text;
    NSString *appType = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:@"net02d2geftdt4tj" forKey:@"PSW_AES_KEY"];
    [[NSUserDefaults standardUserDefaults] setObject:@"4kz8rn8a7yxdy9u8" forKey:@"AES_IV_PARAMETER"];
//    if ([appstr isEqualToString:@" 生产环境"]) {
//        appType = @"2";
//        [[NSUserDefaults standardUserDefaults] setObject:@"nvvmjk1hi8qlvoy4" forKey:@"PSW_AES_KEY"];
//        [[NSUserDefaults standardUserDefaults] setObject:@"fstvas2suhosmvjl" forKey:@"AES_IV_PARAMETER"];
//    }else if ([appstr isEqualToString:@" 开发环境"]) {
//        appType = @"0";
//    }
    NSString *sign = [timeString aci_encryptWithAES];
    //    NSDictionary *dict = @{@"appid":@"wx8e6096173bff1149",@"universalLink":@"https://video-sells-test.ikandy.cn/txWhiteBoard/",@"userName":@"gh_9fd3da8ad9f6",@"miniprogramType":miniprogramType};
    
    NSDictionary *addressDict = @{@"adr":@"eeeeeee",@"city":@"ddd111111111",@"latitude":@11.22,@"longitude":@123.9,@"province":@"hhhhhhhhhhhhh",@"accuracy":@1};
    
    self.config.miniprogramType = miniprogramType;
     
    
    [[TXTManage sharedInstance] setEnvironment:appType wechat:self.config appGroup:@"com.tx.txWhiteBoard.ReplaykitUpload"];

    if ([self.route isEqualToString:@"creat"]) {
      
        [[TXTManage sharedInstance] createRoom:agentName OrgName:orgName SignOrgName:sign EnableVideo:self.config.enableVideo BusinessData:nil RoomInfo:nil CallBack:^(int code, NSString * _Nonnull desc) {
            if (code == 0) {
                NSLog(@"%@",desc);
                NSData *jsonData = [desc dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&err];
                NSString *inviteNumber = [dic valueForKey:@"inviteNumber"];
                [[NSUserDefaults standardUserDefaults] setObject:inviteNumber forKey:@"inviteNumber"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }];
    }else{
        
        [[TXTManage sharedInstance] startVideo:agentName OrgName:orgName SignOrgName:sign EnableVideo:self.config.enableVideo UserHead:@"" BusinessData:nil CallBack:^(int code, NSString * _Nonnull desc) {
            if (code == 0) {
            }else if(code == 111111111){
                
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:desc preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //确认处理
                }];
                [alert addAction:action2];
                [self.navigationController presentViewController:alert animated:YES completion:nil];
            }
        }];
        
    }
}

- (void)creat{
    
}

- (void)start{
    
}

- (IBAction)chooseSmall:(id)sender {
    /// 1.单列字符串选择器（传字符串数组）
    [self.view endEditing:YES];
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.title = @"选择环境";
    stringPickerView.dataSourceArr = @[@" 测试环境", @" 生产环境",@" 开发环境"];
    stringPickerView.selectIndex = 0;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        NSLog(@"选择的值：%@", resultModel.value);
        [self.smallbtn setTitle:resultModel.value forState:UIControlStateNormal];
        if ([resultModel.value isEqualToString:@" 生产环境"]) {
            self.smalllab.text = @"小程序是生产环境";
        }else if ([resultModel.value isEqualToString:@" 测试环境"]){
            self.smalllab.text = @"小程序是测试环境";
        }else{
            self.smalllab.text = @"小程序是开发环境";
        }
    };

    [stringPickerView show];
    
}
- (IBAction)chooseApp:(id)sender {
    [self.view endEditing:YES];
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.title = @"选择环境";
    stringPickerView.dataSourceArr = @[@" 测试环境", @" 生产环境",@" 开发环境"];
    stringPickerView.selectIndex = 0;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        NSLog(@"选择的值：%@", resultModel.value);
        [self.appbtn setTitle:resultModel.value forState:UIControlStateNormal];
        if ([resultModel.value isEqualToString:@" 生产环境"]) {
            self.phonelab.text = @"app是生产环境";
            self.orgName.text = @"gsc_test";
        }else if ([resultModel.value isEqualToString:@" 测试环境"]){
            self.phonelab.text = @"app是测试环境";
            self.orgName.text = @"test_org2";
        }else{
            self.phonelab.text = @"app是开发环境";
        }
    };

    [stringPickerView show];
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.agentName resignFirstResponder];
    [self.orgName resignFirstResponder];
}

- (void)setting{
    settingViewController *vc = [[settingViewController alloc] initWithNibName:@"settingViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
   
@end
