//
//  NSString+TXTAES.m
//  TICDemo
//
//  Created by 洪青文 on 2020/9/8.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "NSString+TXTAES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
//加密方式: 将orgAccount的内容+当前时间戳（单位秒）拼接起来后，得到例如 test_org1599471205 的字符串，
//然后对该字符串进行aes-128-cbc方式加密，将加密后的字符串填入orgAccount字段中。
//测试  加密测试key: net02d2geftdt4tj，测试IV: 4kz8rn8a7yxdy9u8
//生产  加密测试key: nvvmjk1hi8qlvoy4，测试IV: fstvas2suhosmvjl

//生产
//static NSString *const PSW_AES_KEY = @"nvvmjk1hi8qlvoy4";
//static NSString *const AES_IV_PARAMETER = @"fstvas2suhosmvjl";
//测试
static NSString *const PSW_AES_KEY = @"net02d2geftdt4tj";
static NSString *const AES_IV_PARAMETER = @"4kz8rn8a7yxdy9u8";

@implementation NSString (TXTAES)

//- (void)aci_encryptWithAESWithType:(NSString *)type{
//
//    [self aci_decryptWithAES];
//}


- (NSString*)aci_encryptWithAES {

    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:[[NSUserDefaults standardUserDefaults] objectForKey:@"PSW_AES_KEY"]
                                         iv:[[NSUserDefaults standardUserDefaults] objectForKey:@"AES_IV_PARAMETER"]];
//    NSLog(@"%lx",AESData);
   
    NSString *baseStr_GTM = [self encodeBase64Data:AESData];
    return baseStr_GTM;
}

- (NSString*)aci_decryptWithAES {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *baseData_GTM = [self decodeBase64Data:data];
    NSData *baseData = [[NSData alloc]initWithBase64EncodedString:self options:0];
    
    NSData *AESData_GTM = [self AES128operation:kCCDecrypt
                                           data:baseData_GTM
                                            key:[[NSUserDefaults standardUserDefaults] objectForKey:@"PSW_AES_KEY"]
                                             iv:[[NSUserDefaults standardUserDefaults] objectForKey:@"AES_IV_PARAMETER"]];
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:[[NSUserDefaults standardUserDefaults] objectForKey:@"PSW_AES_KEY"]
                                         iv:[[NSUserDefaults standardUserDefaults] objectForKey:@"AES_IV_PARAMETER"]];
    
    NSString *decStr_GTM = [[NSString alloc] initWithData:AESData_GTM encoding:NSUTF8StringEncoding];
    NSLog(@"decStr_GTM : %@",decStr_GTM);
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    
    return decStr;
}

/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *
 */
- (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    
    char keyPtr[kCCKeySizeAES128 + 1];  //kCCKeySizeAES128是加密位数 可以替换成256位的
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    // 设置加密参数
    /**
        这里设置的参数ios默认为CBC加密方式，如果需要其他加密方式如ECB，在kCCOptionPKCS7Padding这个参数后边加上kCCOptionECBMode，即kCCOptionPKCS7Padding | kCCOptionECBMode，但是记得修改上边的偏移量，因为只有CBC模式有偏移量之说

    */
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}

- (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}


// 这里附上GTMBase64编码的代码，可以手动写一个分类，也可以直接cocopods下载，pod 'GTMBase64'。
/**< GTMBase64编码 */
- (NSString*)encodeBase64Data:(NSData *)data {
     NSString *base64String = [self convertDataToHexStr:data];
//    NSString *base64String = [GTMBase64 encodeData:data];
       return base64String;
}

/**< GTMBase64解码 */
- (NSData*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    return data;
}

@end
