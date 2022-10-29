//
//  NSString+TXTAES.h
//  TICDemo
//
//  Created by 洪青文 on 2020/9/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TXTAES)
/**< 加密方法 */
- (NSString*)aci_encryptWithAES;
//- (NSString*)aci_encryptWithAESWithType:(NSString *)type;

/**< 解密方法 */
- (NSString*)aci_decryptWithAES;

//@property (strong, nonatomic) NSString *PSW_AES_KEY;
//@property (strong, nonatomic) NSString *AES_IV_PARAMETER;
@end

NS_ASSUME_NONNULL_END
