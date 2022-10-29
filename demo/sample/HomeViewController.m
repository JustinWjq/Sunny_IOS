//
//  HomeViewController.m
//  sample
//
//  Created by 洪青文 on 2021/2/2.
//  Copyright © 2021 洪青文. All rights reserved.
//

#import "HomeViewController.h"
#import "JoinRoomViewController.h"
#import "hehhheViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *roomId;
@property (weak, nonatomic) IBOutlet UIButton *roomIdCopyBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小腾讯";
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *roomid = [[NSUserDefaults standardUserDefaults] objectForKey:@"inviteNumber"];
    
    
    if ([roomid isEqualToString:@""] || roomid == nil) {
        self.roomIdCopyBtn.hidden = YES;
        self.roomId.text = @"暂无预约";
    }else{
        self.roomIdCopyBtn.hidden = NO;
        self.roomId.text = [NSString stringWithFormat:@"%@",roomid];
    }
}

- (IBAction)joinRoom:(id)sender {
    JoinRoomViewController *vc = [[JoinRoomViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)startRoom:(id)sender {
    hehhheViewController *vc = [[hehhheViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)creatRoom:(id)sender {
    hehhheViewController *vc = [[hehhheViewController alloc] initWithNibName:@"hehhheViewController" bundle:nil];
    vc.route = @"creat";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)copyRoomId:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.roomId.text;
}


@end
