//
//  UIViewController+UIViewController_Extension.m
//  62580
//
//  Created by JYJ on 2020/4/15.
//  Copyright © 2020 qscx. All rights reserved.
//

#import "UIViewController+Extension.h"


@implementation UIViewController (Extension)


+ (UIViewController *)getCurrentVc {
   UINavigationController *nav = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    NSLog(@"%@   xxxx------", nav.topViewController);
    return nav.topViewController;
}
@end
