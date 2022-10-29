//
//  AppDelegate.h
//  sample
//
//  Created by 洪青文 on 2020/9/4.
//  Copyright © 2020 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, assign) BOOL allowRotation;//允许旋转

@property (nonatomic, assign) BOOL rightRotation;//右侧旋转
@property (strong, nonatomic) UIWindow * window;

- (void) didtxt;
@end

