//
//  NSArray+crash.m
//  ChinaBus
//
//  Created by 高明亮 on 2018/10/23.
//  Copyright © 2018 Alibaba. All rights reserved.
//

#import "NSArray+crash.h"

//字典
//-----------------------------------------------------------------------------
id xm_dicGetObject(NSDictionary *dic, id aKey, Class aClass) {
    id result = [dic objectForKey:aKey];
    if ( result && [result isKindOfClass:aClass] ) {
        return result;
    }
    return nil;
}

NSDictionary * xm_dicGetDic(NSDictionary *dic, id aKey)
{
    return (NSDictionary *)xm_dicGetObject(dic, aKey, [NSDictionary class]);
}

NSMutableDictionary * xm_dicGetMutableDic(NSDictionary *dic, id aKey)
{
    return (NSMutableDictionary *)xm_dicGetObject(dic, aKey, [NSMutableDictionary class]);
}

NSString * xm_dicGetString(NSDictionary *dic, id aKey)
{
    id result = [dic objectForKey:aKey];
    if ( result && [result isKindOfClass:[NSString class]] ) {
        return result;
    }
    else if ( result && [result isKindOfClass:[NSNumber class]] ) {
        NSNumber *n = (NSNumber *)result;
        return [n stringValue];
    }
    
    return nil;
    
}

NSString *xm_dicGetNoNullString(NSDictionary *dic, id aKey) {
    NSString *result = xm_dicGetString(dic, aKey);
    if (result) {
        return result;
    }
    return @"";
}

int xm_dicGetInt(NSDictionary *dic, id aKey, int nDefault) {
    id result = [dic objectForKey:aKey];
    if ( result && [result isKindOfClass:[NSNumber class]] ) {
        return [(NSNumber *)result intValue];
    }
    else if ( result && [result isKindOfClass:[NSString class]] ) {
        return [(NSString *)result intValue];
    }
    
    return nDefault;
    
}

NSArray * xm_dicGetArray(NSDictionary *dic, id aKey)
{
    return (NSArray *)xm_dicGetObject(dic, aKey, [NSArray class]);
}

NSMutableArray * xm_dicGetMutableArray(NSDictionary *dic, id aKey)
{
    return (NSMutableArray *)xm_dicGetObject(dic, aKey, [NSMutableArray class]);
}

float xm_dicGetFloat(NSDictionary *dic, id aKey, float fDefault)
{
    id result = [dic objectForKey:aKey];
    if ( result && [result isKindOfClass:[NSNumber class]] ) {
        return [(NSNumber *)result floatValue];
    }
    else if ( result && [result isKindOfClass:[NSString class]] ) {
        return [(NSString *)result floatValue];
    }
    
    return fDefault;
}


long long xm_dicGetLong(NSDictionary *dic, id aKey, float fDefault)
{
    id result = [dic objectForKey:aKey];
    if ( result && [result isKindOfClass:[NSNumber class]] ) {
        return [(NSNumber *)result longLongValue];
    }
    else if ( result && [result isKindOfClass:[NSString class]] ) {
        return [(NSString *)result longLongValue];
    }
    
    return fDefault;
}
//数组
id xm_arrGetObject(NSArray *arr, NSUInteger index, Class aClass) {
    NSDictionary *result = nil;
    if ( index<arr.count ) {
        result = [arr objectAtIndex:index];
        if ( result && [result isKindOfClass:aClass] ) {
            return result;
        }
    }
    return nil;
}

NSString *xm_arrGetString(NSArray *arr, NSUInteger index)
{
    return xm_arrGetObject(arr, index, [NSString class]);
}

NSDictionary * xm_arrGetDic(NSArray *arr, NSUInteger index) {
    return xm_arrGetObject(arr, index, [NSDictionary class]);
}

NSMutableDictionary * xm_arrGetMutableDic(NSArray *arr, NSUInteger index) {
    return xm_arrGetObject(arr, index, [NSMutableDictionary class]);
}

NSArray * xm_arrGetArray(NSArray *arr, NSUInteger index) {
    return xm_arrGetObject(arr, index, [NSArray class]);
}


@implementation NSArray (crash)

@end


@implementation NSMutableDictionary (xm_safe_setObject)

- (void)xm_safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if ( aKey ) {
        if ( anObject==nil ) {
            [self removeObjectForKey:aKey];
        }
        else {
            [self setObject:anObject forKey:aKey];
        }
    }
}

- (void)xm_setValue:(nullable id)value forKey:(NSString *)key
{
    if (key) {
        [self setValue:value forKey:key];
    }
}
@end


//-----------------------------------------------------------------------------------------------------


@implementation NSMutableDictionary (xm_CacheFile)

//Document

+ (NSMutableDictionary *)xm_xm_dictionaryWithCacheFile:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        NSMutableDictionary *dicCache = [[NSMutableDictionary alloc]initWithContentsOfFile:filepath];
        return dicCache;
    }
    else {
        return nil;
    }
}

- (void)xm_saveToDocumentFile:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    [self writeToFile:filepath atomically:YES];
    
}

//Cache
+ (NSMutableDictionary *)xm_dictionaryWithCacheFile:(NSString *)filename path:(NSString *)path{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filepath = [paths objectAtIndex:0];
    if ( path.length > 0 ) {
        filepath = [filepath stringByAppendingPathComponent:path];
        filepath = [filepath stringByAppendingFormat:@"/%@", filename];
    }
    else {
        filepath = [filepath stringByAppendingPathComponent:filename];
    }
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        NSMutableDictionary *dicCache = [[NSMutableDictionary alloc]initWithContentsOfFile:filepath];
        return dicCache;
    }
    else {
        return nil;
    }
}

- (void)xm_saveToCacheFile:(NSString *)filename path:(NSString *)path {
    if ( filename.length== 0 ) {
        return ;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filepath = [paths objectAtIndex:0];
    if ( path.length > 0 ) {
        filepath = [filepath stringByAppendingPathComponent:path];
        BOOL isDirectory = NO;
        if ( [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory]) {
            if ( isDirectory ) {
                //NSLog(@"cache dic:%@", filepath);
                filepath = [filepath stringByAppendingFormat:@"/%@", filename];
                [self writeToFile:filepath atomically:YES];
                //NSLog(@"write cache file(%d)%@", bResult, filepath);
            }
        }
        else {
            [[NSFileManager defaultManager] createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error: nil];
            filepath = [filepath stringByAppendingFormat:@"/%@", filename];
            [self writeToFile:filepath atomically:YES];
        }
        
        
    }
    else {
        filepath = [filepath stringByAppendingPathComponent:filename];
        [self writeToFile:filepath atomically:YES];
    }
    
}

+ (void)xm_removeCacheFile:(NSString *)filename path:(NSString *)path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filepath = [paths objectAtIndex:0];
    if ( path.length > 0 ) {
        filepath = [filepath stringByAppendingPathComponent:path];
        filepath = [filepath stringByAppendingFormat:@"/%@", filename];
        
    }
    else {
        filepath = [filepath stringByAppendingPathComponent:filename];
    }
    
    BOOL isDirectory = NO;
    if ( [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory]) {
        if ( !isDirectory ) {
            [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
        }
    }
    
    
}


+ (NSMutableDictionary *)xm_dictionaryWitxmundleFile:(NSString *)filename path:(NSString *)path {
    if (filename.length == 0)
        return nil;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *pathExtension = [filename pathExtension];
    if ( pathExtension.length > 0 && [filename hasSuffix:pathExtension] ) {
        filename = [filename substringToIndex:filename.length - pathExtension.length - 1];
    }
    NSString *filepath = [bundle pathForResource:filename ofType:pathExtension inDirectory:path];
    if ( filepath ) {
        return [[NSMutableDictionary alloc] initWithContentsOfFile:filepath];
    }
    
    return nil;
    
}

+ (NSMutableDictionary *)xm_dictionaryWithCacheFile:(NSString *)filename {
    return  [NSMutableDictionary xm_dictionaryWithCacheFile:filename path:nil];
}
- (void)xm_saveToCacheFile:(NSString *)filename {
    [self xm_saveToCacheFile:filename path:nil];
}
+ (void)xm_removeCacheFile:(NSString *)filename {
    [self xm_removeCacheFile:filename path:nil];
}
+ (NSMutableDictionary *)xm_dictionaryWitxmundleFile:(NSString *)filename {
    return [NSMutableDictionary xm_dictionaryWitxmundleFile:filename path:nil];
}
@end


//-----------------------------------------------------------------------------------------------------

@implementation NSData (xm_CacheFile)

+ (NSData *)xm_dataWithCacheFile:(NSString *)filename path:(NSString *)path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filepath = [paths objectAtIndex:0];
    if ( path.length > 0 ) {
        filepath = [filepath stringByAppendingPathComponent:path];
        filepath = [filepath stringByAppendingFormat:@"/%@", filename];
    }
    else {
        filepath = [filepath stringByAppendingPathComponent:filename];
    }
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:filepath];
        return data;
    }
    else {
        return nil;
    }
    
}

+ (NSData *)xm_dataWitxmundleFile:(NSString *)filename path:(NSString *)path {
    if (filename.length == 0)
        return nil;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *pathExtension = [filename pathExtension];
    if ( pathExtension.length > 0 && [filename hasSuffix:pathExtension] ) {
        filename = [filename substringToIndex:filename.length - pathExtension.length - 1];
    }
    NSString *filepath = [bundle pathForResource:filename ofType:pathExtension inDirectory:path];
    if ( filepath ) {
        return [[NSData alloc] initWithContentsOfFile:filepath];
    }
    
    return nil;
    
}


- (void)xm_saveToCacheFile:(NSString *)filename path:(NSString *)path {
    if ( filename.length== 0 ) {
        return ;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filepath = [paths objectAtIndex:0];
    if ( path.length > 0 ) {
        filepath = [filepath stringByAppendingPathComponent:path];
        BOOL isDirectory = NO;
        if ( [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory]) {
            if ( isDirectory ) {
                NSLog(@"cache data:%@", filepath);
                filepath = [filepath stringByAppendingFormat:@"/%@", filename];
                [self writeToFile:filepath atomically:YES];
                //NSLog(@"write cache file(%d)%@", bResult, filepath);
            }
        }
        else {
            [[NSFileManager defaultManager] createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error: nil];
            filepath = [filepath stringByAppendingFormat:@"/%@", filename];
            [self writeToFile:filepath atomically:YES];
        }
        
        
    }
    else {
        filepath = [filepath stringByAppendingPathComponent:filename];
        NSLog(@"cache data:%@", filepath);
        
        [self writeToFile:filepath atomically:YES];
    }
    
}


//删除一个磁盘缓存
+ (void)xm_removeCacheFile:(NSString *)filename path:(NSString *)path {
    if ( filename.length== 0 ) {
        return ;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filepath = [paths objectAtIndex:0];
    if ( path.length > 0 ) {
        filepath = [filepath stringByAppendingPathComponent:path];
        BOOL isDirectory = NO;
        if ( [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory]) {
            if ( isDirectory ) {
                NSLog(@"cache data:%@", filepath);
                filepath = [filepath stringByAppendingFormat:@"/%@", filename];
                
                if([[NSFileManager defaultManager] fileExistsAtPath:filepath]){
                    [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
                }
            }
        }
    }
}





@end




@implementation NSMutableArray (xm_OpenetExt)

-(void)xm_safe_addObject:(id)anObject {
    if ( anObject ) {
        [self addObject:anObject];
    }
}


- (void)xm_safe_removeObjectsInRange:(NSRange)range
{
    if (range.length <= 0) {
        return;
    }
    
    if (range.location > self.count) {
        return;
    }
    
    if (range.length > self.count) {
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        return;
    }
    
    return [self removeObjectsInRange:range];
}


- (void)xm_saveToCacheFile:(NSString *)filename path:(NSString *)path {
    if ( filename.length== 0 ) {
        return ;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filepath = [paths objectAtIndex:0];
    if ( path.length > 0 ) {
        filepath = [filepath stringByAppendingPathComponent:path];
        BOOL isDirectory = NO;
        if ( [[NSFileManager defaultManager] fileExistsAtPath:filepath isDirectory:&isDirectory]) {
            if ( isDirectory ) {
                //NSLog(@"cache dic:%@", filepath);
                filepath = [filepath stringByAppendingFormat:@"/%@", filename];
                [self writeToFile:filepath atomically:YES];
                //NSLog(@"write cache file(%d)%@", bResult, filepath);
            }
        }
        else {
            [[NSFileManager defaultManager] createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error: nil];
            filepath = [filepath stringByAppendingFormat:@"/%@", filename];
            [self writeToFile:filepath atomically:YES];
        }
        
        
    }
    else {
        filepath = [filepath stringByAppendingPathComponent:filename];
        [self writeToFile:filepath atomically:YES];
    }
    
}

- (void)xm_saveToCacheFile:(NSString *)filename {
    [self xm_saveToCacheFile:filename path:nil];
}

//Cache
+ (NSMutableArray *)xm_arrayWithCacheFile:(NSString *)filename path:(NSString *)path{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filepath = [paths objectAtIndex:0];
    if ( path.length > 0 ) {
        filepath = [filepath stringByAppendingPathComponent:path];
        filepath = [filepath stringByAppendingFormat:@"/%@", filename];
    }
    else {
        filepath = [filepath stringByAppendingPathComponent:filename];
    }
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        NSMutableArray *arrCache = [[NSMutableArray alloc]initWithContentsOfFile:filepath];
        return arrCache;
    }
    else {
        return nil;
    }
}

+ (NSMutableArray *)xm_arrayWithCacheFile:(NSString *)filename {
    return  [NSMutableArray xm_arrayWithCacheFile:filename path:nil];
}

@end
