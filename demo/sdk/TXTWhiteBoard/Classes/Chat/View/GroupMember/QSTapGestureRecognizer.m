//
//  QSTapGestureRecognizer.m
//  62580
//
//  Created by QSZX001 on 2020/5/22.
//  Copyright © 2020 qscx. All rights reserved.
//

#import "QSTapGestureRecognizer.h"

@implementation QSTapGestureRecognizer



- (instancetype)initWithTarget:(id)target action:(SEL)action{
    self = [ super initWithTarget:target action:action];
    
    if (self) {
        self.delegate  = self;
    }
    return self;
}
 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    QSLog(@"%@", [touch.view class]);
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return NO;
    } else if ([touch.view isKindOfClass:NSClassFromString(@"TXTSearchMemberCell")]) {
        return ![touch.view isKindOfClass:NSClassFromString(@"TXTSearchMemberCell")];
    } else if ([touch.view isKindOfClass:NSClassFromString(@"UICollectionView")]) {
        return NO;
    }
    return ![touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")];
}

@end
