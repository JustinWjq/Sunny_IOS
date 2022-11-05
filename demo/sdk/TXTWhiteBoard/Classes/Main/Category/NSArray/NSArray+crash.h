//
//  NSArray+crash.h
//  ChinaBus
//
//  Created by 高明亮 on 2018/10/23.
//  Copyright © 2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//    dictionary
//---------------------------------------------------------------------------------------
id xm_dicGetObject(NSDictionary *dic, id aKey, Class aClass);
NSString * xm_dicGetString(NSDictionary *dic, id aKey);
NSString *xm_dicGetNoNullString(NSDictionary *dic, id aKey);
int xm_dicGetInt(NSDictionary *dic, id aKey, int nDefault);
NSDictionary * xm_dicGetDic(NSDictionary *dic, id aKey);
NSMutableDictionary * xm_dicGetMutableDic(NSDictionary *dic, id aKey);
NSArray * xm_dicGetArray(NSDictionary *dic, id aKey);
NSMutableArray * xm_dicGetMutableArray(NSDictionary *dic, id aKey);
float xm_dicGetFloat(NSDictionary *dic, id aKey, float fDefault);
long long xm_dicGetLong(NSDictionary *dic, id aKey, float fDefault);

//数组取值
id xm_arrGetObject(NSArray *arr, NSUInteger index, Class aClass);
NSString *xm_arrGetString(NSArray *arr, NSUInteger index);
NSDictionary * xm_arrGetDic(NSArray *arr, NSUInteger index);
NSMutableDictionary * xm_arrGetMutableDic(NSArray *arr, NSUInteger index);
NSArray * xm_arrGetArray(NSArray *arr, NSUInteger index);

@interface NSArray (crash)

@end


@interface NSMutableDictionary (xm_xm_safe_setObject)
- (void)xm_safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)xm_setValue:(nullable id)value forKey:(NSString *)key;
@end

//-----------------------------------------------------------------------------------------------------

@interface NSMutableDictionary (xm_CacheFile)

+ (NSMutableDictionary *)xm_xm_dictionaryWithCacheFile:(NSString *)filename;
- (void)xm_saveToDocumentFile:(NSString *)filename;
+ (NSMutableDictionary *)xm_dictionaryWithCacheFile:(NSString *)filename path:(NSString *)path;
- (void)xm_saveToCacheFile:(NSString *)filename path:(NSString *)path;
+ (void)xm_removeCacheFile:(NSString *)filename path:(NSString *)path;
+ (NSMutableDictionary *)xm_dictionaryWitxmundleFile:(NSString *)filename path:(NSString *)path;

+ (NSMutableDictionary *)xm_dictionaryWithCacheFile:(NSString *)filename ;
- (void)xm_saveToCacheFile:(NSString *)filename ;
+ (void)xm_removeCacheFile:(NSString *)filename ;
+ (NSMutableDictionary *)xm_dictionaryWitxmundleFile:(NSString *)filename ;
@end


//-----------------------------------------------------------------------------------------------------

@interface NSData (xm_CacheFile)
+ (NSData *)xm_dataWithCacheFile:(NSString *)filename path:(NSString *)path;
+ (NSData *)xm_dataWitxmundleFile:(NSString *)filename path:(NSString *)path;
- (void)xm_saveToCacheFile:(NSString *)filename path:(NSString *)path;
+ (void)xm_removeCacheFile:(NSString *)filename path:(NSString *)path;
@end


//-----------------------------------------------------------------------------------------------------
//
//
//-----------------------------------------------------------------------------------------------------
@interface NSMutableArray (xm_OpenetExt)
-(void)xm_safe_addObject:(id)anObject;

- (void)xm_safe_removeObjectsInRange:(NSRange)range;

- (void)xm_saveToCacheFile:(NSString *)filename path:(NSString *)path;
- (void)xm_saveToCacheFile:(NSString *)filename;
+ (NSMutableArray *)xm_arrayWithCacheFile:(NSString *)filename path:(NSString *)path;
+ (NSMutableArray *)xm_arrayWithCacheFile:(NSString *)filename;

@end

NS_ASSUME_NONNULL_END

