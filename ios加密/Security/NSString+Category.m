//
//  NSString+Category.m
//  ios加密
//
//  Created by Candice on 17/1/4.
//  Copyright © 2017年 刘灵. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

@implementation NSString (Category)

#pragma mark - MD5加密
- (NSString *)md5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    int length = (int)strlen(value);
    CC_MD5(value, length, outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}



#pragma mark - UTF8编码后的URL
- (NSString*)encodedURLForUTF8{
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

//按照指定的编码转换URL
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("%[]￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding) ;
}

#pragma mark - 字符串以UTF8编码方式执行base64解码
- (NSString *)base64DecodeForUTF8{
    return [self base64DecodedWithEncoding:NSUTF8StringEncoding];
}

// 字符串以指定编码方式执行base64解码
- (NSString *)base64DecodedWithEncoding:(NSStringEncoding)encoding{
    NSData * data = [self dataUsingEncoding:encoding allowLossyConversion:YES];
    // 转换到base64
    data = [GTMBase64 decodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

#pragma mark - 字符串以UTF8编码方式转换base64
- (NSString *) base64EncodedForUTF8{
    return [self base64EncodedWithEncoding:NSUTF8StringEncoding];
}

// 字符串以指定编码方式转换base64
- (NSString *)base64EncodedWithEncoding:(NSStringEncoding)encoding
{
    
    NSData * data = [self dataUsingEncoding:encoding allowLossyConversion:YES];
    // 转换到base64
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

@end
