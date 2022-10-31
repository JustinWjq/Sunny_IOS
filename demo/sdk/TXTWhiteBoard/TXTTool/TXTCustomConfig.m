//
//  TXTCustomConfig.m
//  TXTWhiteBoard
//
//  Created by 洪青文 on 2021/1/25.
//  Copyright © 2021 洪青文. All rights reserved.
//

#import "TXTCustomConfig.h"

@implementation TXTCustomConfig
+ (instancetype)sharedInstance
{
    static TXTCustomConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TXTCustomConfig alloc] init];;
    });
    return instance;
}
@end
