//
//  settingViewController.m
//  sample
//
//  Created by 洪青文 on 2021/1/26.
//  Copyright © 2021 洪青文. All rights reserved.
//

#import "settingViewController.h"
#import <TXTWhiteBoard/TXTCustomConfig.h>
#import <TXTWhiteBoard/TXTManage.h>


@interface settingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *miniTitle;
@property (weak, nonatomic) IBOutlet UITextField *miniContent;
@property (weak, nonatomic) IBOutlet UISwitch *showInvite;
@property (weak, nonatomic) IBOutlet UITextField *originID;
@property (strong, nonatomic) TXTCustomConfig *config;
@property (weak, nonatomic) IBOutlet UISwitch *isShowTemporaryButton;
@property (weak, nonatomic) IBOutlet UITextField *miniprogramPath;

@property (weak, nonatomic) IBOutlet UISwitch *enableVideo;
@property (weak, nonatomic) IBOutlet UISwitch *isChat;
@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.showInvite setOn:YES];
    UIBarButtonItem *lefBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onQuit)];
    self.navigationItem.leftBarButtonItem = lefBarItem;
    
    self.config = [TXTCustomConfig sharedInstance];
    self.miniTitle.text = self.config.miniprogramTitle;
    self.miniContent.text = self.config.miniprogramCard;
    self.originID.text = self.config.userName;
    self.miniprogramPath.text = self.config.miniProgramPath;
    [self.enableVideo setOn:self.config.enableVideo];
    [self.isChat setOn:self.config.isChat];
}
- (IBAction)showInviteButton:(id)sender {
    if([sender isOn]){

    NSLog(@"turn on");

    }else{

    NSLog(@"turned off");

    }
}
- (IBAction)ShowTemporaryButton:(id)sender {
    if([sender isOn]){

    NSLog(@"turn on");

    }else{

    NSLog(@"turned off");

    }
}
- (IBAction)enableVideo:(id)sender {
    if([sender isOn]){

    NSLog(@"turn on");

    }else{

    NSLog(@"turned off");

    }
}
- (IBAction)isChatModel:(id)sender {
    if([sender isOn]){

    NSLog(@"turn on");

    }else{

    NSLog(@"turned off");

    }
}

- (void)onQuit{
    TXTCustomConfig *config = [TXTCustomConfig sharedInstance];
    config.miniprogramTitle = self.miniTitle.text;
    config.miniprogramCard = self.miniContent.text;
    config.userName = self.originID.text;
    config.miniProgramPath = self.miniprogramPath.text;
    if([self.showInvite isOn]){

    config.isShowInviteButton = YES;
    config.isShowTemporaryButton = YES;

    }else{

    config.isShowInviteButton = NO;

    }
    if([self.isShowTemporaryButton isOn]){
    config.isShowTemporaryButton = YES;
    }else{

    config.isShowTemporaryButton = NO;

    }
    if([self.enableVideo isOn]){
    config.enableVideo = YES;
    }else{

    config.enableVideo = NO;

    }
    if([self.isChat isOn]){
    config.isChat = YES;
    }else{

    config.isChat = NO;

    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.miniTitle resignFirstResponder];
    [self.miniContent resignFirstResponder];
    [self.originID resignFirstResponder];
}


@end
