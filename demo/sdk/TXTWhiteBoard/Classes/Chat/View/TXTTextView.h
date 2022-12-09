//
//  TXTTextView.h
//  TXTWhiteBoard
//
//  Created by jiangyongjian on 2022/12/6.
//  Copyright © 2022 洪青文. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTTextView : UITextView

@property (nonatomic, copy) NSString *txt_placehoder;
@property (nonatomic, strong) UIColor *txt_placehoderColor;

@end

NS_ASSUME_NONNULL_END
