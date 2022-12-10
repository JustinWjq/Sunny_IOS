//
//  TXTTestViewController.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/12/10.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTTestViewController.h"
#import "TXTManage.h"
#import "TXTFileModel.h"

@interface TXTTestViewController ()

@end

@implementation TXTTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *clickBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor colorWithHexString:@"D70110"] font:[UIFont qs_regularFontWithSize:15] target:self action:@selector(click)];
    clickBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:clickBtn];
    [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.mas_equalTo(100);
    }];
    
    
    [self.view addTarget:self action:@selector(click)];
}

/// click
- (void)click {
    TXTFileModel *fileModel = [[TXTFileModel alloc] init];
    fileModel.h5Url = @"https://recall-sync-demo.cloud-ins.cn/mirror.html?syncid=51-cvsstest123-1&synctoken=0060490432279104e008daf9a660dfb8d2aIABaoflIqpo4-W91SrtSeG8e-QAQ5_O7_RsAQrms1PxSLJ597XwAAAAAEADKL1Dbsjd_YwEA6AOyN39j";
    fileModel.name = @"test";
    [[TXTManage sharedInstance] addFileToSdk:FileTypeH5 fileModel:fileModel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    TXTFileModel *fileModel = [[TXTFileModel alloc] init];
    fileModel.h5Url = @"https://recall-sync-demo.cloud-ins.cn/mirror.html?syncid=51-cvsstest123-1&synctoken=0060490432279104e008daf9a660dfb8d2aIABaoflIqpo4-W91SrtSeG8e-QAQ5_O7_RsAQrms1PxSLJ597XwAAAAAEADKL1Dbsjd_YwEA6AOyN39j";
    fileModel.name = @"test";
    [[TXTManage sharedInstance] addFileToSdk:FileTypeH5 fileModel:fileModel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
