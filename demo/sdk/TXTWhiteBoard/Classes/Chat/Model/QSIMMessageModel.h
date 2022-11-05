//
//  QSIMMessageModel.h
//  62580
//
//  Created by QSZX001 on 2020/5/13.
//  Copyright © 2020 qscx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSIMMessageModel : NSObject

@property (nonatomic, strong) V2TIMMessage *message;

@property (nonatomic, strong) NSString *timeId;
@property (nonatomic, assign) BOOL isTime;

@property (nonatomic, assign) NSInteger photoIndex;

@property (nonatomic, assign) float contentHeight;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGSize contentSize;

@property (nonatomic, assign) BOOL isDefaultAvatar;
@property (nonatomic, assign) NSUInteger avatarDataLength;
@property (nonatomic, assign) NSUInteger messageMediaDataLength;

@property (nonatomic, assign) BOOL isErrorMessage;
@property (nonatomic, strong) NSError *messageError;

@property (nonatomic, strong) NSNumber *messageTime;

/** timeStr */
@property (nonatomic, strong) NSString *timeStr;


- (void)setErrorMessageChatModelWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
