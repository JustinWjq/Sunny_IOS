//
//  QSIMMessageModel.m
//  62580
//
//  Created by QSZX001 on 2020/5/13.
//  Copyright © 2020 qscx. All rights reserved.
//

#import "QSIMMessageModel.h"

@implementation QSIMMessageModel

- (instancetype)init {
  self = [super init];
  if (self) {
    _isTime = NO;
  }
  return self;
}

- (void)setErrorMessageChatModelWithError:(NSError *)error {
  _isErrorMessage = YES;
  _messageError = error;
}



@end
