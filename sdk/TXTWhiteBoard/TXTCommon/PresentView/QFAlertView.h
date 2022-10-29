//
//  QFAlertView.h
//  KYH
//
//  Created by 尚振兴 on 2020/6/5.
//  Copyright © 2020 AIA. All rights reserved.
//

#import <UIKit/UIKit.h>


//常用的icon
static NSString * _Nonnull const QFAlertSuccess = @"pay_duigou";//对号的图标
static NSString * _Nonnull const QFAlertError = @"red_exclamation_point";//感叹号的图标

@interface QFAlertView : UIView

@property(nonatomic,strong)UIColor *rightBtnColor;

///1个Title 1个Des 2个Btn
+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     des:(NSString *_Nullable)des
                               leftTitle:(NSString *_Nullable)leftTitle
                              rightTitle:(NSString *_Nullable)rightTitle
                              leftAction:(void(^ _Nullable)(void))leftAction
                             rightAction:(void(^ _Nullable)(void))rightAction;
///1个Title 1个Des 1个Btn
+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     des:(NSString *_Nullable)des
                               btnTitle:(NSString *_Nullable)btnTitle
                               btnAction:(void(^ _Nullable)(void))btnAction;

///1个Title 1个Des  1个Btn(title右侧有icon)
+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     des:(NSString *_Nullable)des
                                 btnIcon:(NSString *_Nullable)btnIcon
                               btnTitle:(NSString *_Nullable)btnTitle
                               btnAction:(void(^ _Nullable)(void))btnAction;

///1个TitleIcon 1个Title  1个Des 2个Btn
+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                               titleIcon:(NSString *_Nullable)titleIcon
                                     des:(NSString *_Nullable)des
                               leftTitle:(NSString *_Nullable)leftTitle
                              rightTitle:(NSString *_Nullable)rightTitle
                              leftAction:(void(^ _Nullable)(void))leftAction
                             rightAction:(void(^ _Nullable)(void))rightAction;

///1个TitleIcon 1个Title  1个Des 1个Btn
+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                               titleIcon:(NSString *_Nullable)titleIcon
                                     des:(NSString *_Nullable)des
                                btnTitle:(NSString *_Nullable)btnTitle
                               btnAction:(void(^ _Nullable)(void))btnAction;

///1个TitleIcon 1个Title 1个msg 1个Des 1个Btn
+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     msg:(NSString *_Nullable)msg
                                     des:(NSString *_Nullable)des
                                btnTitle:(NSString *_Nullable)btnTitle
                               btnAction:(void(^ _Nullable)(void))btnAction;

///1个Title 1个msg 1个Des 2个Btn
+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     msg:(NSString *_Nullable)msg
                                     des:(NSString *_Nullable)des
                               leftTitle:(NSString *_Nullable)leftTitle
                              rightTitle:(NSString *_Nullable)rightTitle
                              leftAction:(void(^ _Nullable)(void))leftAction
                             rightAction:(void(^ _Nullable)(void))rightAction;

//倒计时
+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     msg:(NSString *_Nullable)msg
                                     des:(NSString *_Nullable)des
                               leftTitle:(NSString *_Nullable)leftTitle
                              rightTitle:(NSString *_Nullable)rightTitle
                                    time:(NSInteger)time
                              leftAction:(void(^ _Nullable)(void))leftAction
                             rightAction:(void(^ _Nullable)(void))rightAction;

/// 显示在keywindow上
- (void)show;

/// 显示在指定view上
/// @param view 当前view
- (void)showInView:(UIView *_Nullable)view;


//用例
/*
 //        [[QFAlertView alertViewTitle:@"系统提示"
 //                                 des:@"描述文字"
 //                           leftTitle:@"确认离开"
 //                          rightTitle:@"继续支付"
 //                          leftAction:nil
 //                         rightAction:^{
 //            NSLog(@"点击了支付按钮");
 //        }] show];
         
 //        [[QFAlertView alertViewTitle:@"系统提示"
 //                           titleIcon:QFAlertError
 //                                 des:@"描述文字"
 //                           leftTitle:@"确认离开"
 //                          rightTitle:@"继续支付"
 //                          leftAction:nil
 //                         rightAction:^{
 //            NSLog(@"点击了支付按钮");
 //        }] show];
         
 //        [[QFAlertView alertViewTitle:@"提示" des:@"世纪东方计算方法即可洒就分手酸辣粉吉林省" btnTitle:@"确定" btnAction:^{
 //            NSLog(@"确定");
 //        }] show];
         
 //        [[QFAlertView alertViewTitle:@"提示" titleIcon:QFAlertSuccess des:@"世纪东方计算方法即可洒就分手酸辣粉吉林省" btnTitle:@"确定" btnAction:^{
 //            NSLog(@"确定");
 //        }] show];
 
 */

@end

