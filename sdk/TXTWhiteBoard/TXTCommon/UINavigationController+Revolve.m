//
//  UINavigationController+Revolve.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2021/3/22.
//  Copyright © 2021 洪青文. All rights reserved.
//

#import "UINavigationController+Revolve.h"

@implementation UINavigationController (Revolve)
//是否自动旋转,返回YES可以自动旋转
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}
//返回支持的方向
- (NSUInteger)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}
//这个是返回优先方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}
@end
