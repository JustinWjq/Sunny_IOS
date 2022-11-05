//
//  UIButton+link.m
//  KDFDApp
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import "UIButton+link.h"
#import <objc/runtime.h>

@implementation UIButton (link)

- (void)setLinkUrl:(NSString *)linkUrl{
    
    objc_setAssociatedObject(self, @selector(linkUrl), linkUrl, OBJC_ASSOCIATION_COPY);
    
}
- (NSString *)linkUrl{
    return objc_getAssociatedObject(self, _cmd);//获得关联对象
}
@end
