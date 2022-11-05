//
//  UILabel+currency.h
//  ChinaBus
//
//  Created by 高明亮 on 2018/10/25.
//  Copyright © 2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (currency)

+(UILabel *)labelWithFont:(UIFont *)font  textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment;

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;
/**
*  改变字间距
*/
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;
/**
*  改变行间距和字间距
*/
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end

