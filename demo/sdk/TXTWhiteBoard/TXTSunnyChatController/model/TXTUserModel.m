//
//  TXTUserModel.m
//  TICDemo
//
//  Created by 洪青文 on 2020/9/16.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "TXTUserModel.h"

@implementation TXTUserModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(NSString *)removeExtraForUserId:(NSString *)userid {
    if(userid != nil && [userid isKindOfClass:[NSString class]]) {
        NSArray *arr = [userid componentsSeparatedByString:@"extra"];
        if(arr == nil || arr.count == 0) {
            return userid;
        }
        NSString *newUserId = [arr firstObject];
        return newUserId;
    }
    return userid;
}

-(BOOL)compareUserIdWithoutExtra:(NSString *)tuserId {
    
    if(_render == nil || _render.userId == nil) {
        return NO;
    }
    
    NSArray *arr = [_render.userId componentsSeparatedByString:@"extra"];
    if(arr == nil || arr.count == 0) {
        return NO;
    }
    
    NSString *newUserId = [arr firstObject];
    if([newUserId isEqualToString:tuserId]) {
        return YES;
    }
    
    return NO;
}
@end
