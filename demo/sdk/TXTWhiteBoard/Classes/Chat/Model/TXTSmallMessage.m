//
//  TXTSmallMessage.m
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/11/4.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import "TXTSmallMessage.h"

@implementation TXTSmallMessage

- (CGFloat)cellH {
    CGFloat sizeH = [[NSString stringWithFormat:@"%@：%@", self.userName, self.content] sizeWithFont:[UIFont qs_regularFontWithSize:12] maxSize:CGSizeMake(252, MAXFLOAT)].height;
//    if (sizeH + 22 > 52) {
//        return 52;
//    }
    return sizeH + 22;
}

@end
