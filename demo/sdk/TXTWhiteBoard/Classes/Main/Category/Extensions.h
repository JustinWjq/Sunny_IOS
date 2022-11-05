//
//  CLExtensions.h
//  CarLoan
//
//  Created by JYJ on 2018/3/23.
//  Copyright © 2018年 ylch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Singleton.h"

// UIApplication
#import "UIApplication+Extensions.h"

// UIColor
#import "UIColor+Extention.h"

// UIView
#import "UIView+Runtime.h"
#import "UIView+IBExtension.h"
#import "UIView+Extension.h"
#import "UIView+Additions.h"

// UIImage
#import "UIImage+Transform.h"
#import "UIImage+Orientation.h"
#import "UIImage+Extension.h"

// UILabel
#import "UILabel+currency.h"
#import "UILabel+Extension.h"

// UIButton
#import "UIButton+Extension.h"
#import "QSButton.h"
#import "UIButton+link.h"

// UITextField
#import "UITextField+placeholderColor.h"

// UIScrollView

// UIImageView
#import "UIImageView+Indicator.h"

// UIFont
#import "UIFont+QSExtention.h"

// UIScreen
#import "UIScreen+Extension.h"

// UIViewController
#import "UIViewController+Extension.h"

// UINavigationController
//#import "UINavigationController+NavigationLock.h"

// UIWindow
#import "UIWindow+Extesion.h"

// NSArray
#import "NSArray+crash.h"


// NSDate
#import "NSDate+extend.h"

// NSString
#import "NSString+EsayEncrypt.h"
#import "NSString+extend.h"
#import "NSString+Frame.h"
#import "NSString+Url.h"
#import "NSString+QSExtension.h"
#import "NSString+Emoji.h"

// NSNumber
//#import "NSNumber+Comma.h"

// NSDictionary
//#import "NSDictionary+Extension.h"

// MBProgressHUD
//#import "MBProgressHUD+SC.h"


//单例模式定义

#define xm_define_singleton_interface(classname) \
+ (instancetype)shared;

#define xm_define_singleton_implate(classname) \
+ (instancetype)shared {\
static dispatch_once_t  onceToken;\
static classname *share##classname  ;\
dispatch_once(&onceToken, ^{\
share##classname = [[self alloc] init];\
});\
return share##classname;\
}
