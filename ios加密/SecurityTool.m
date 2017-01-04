//
//  SecurityTool.m
//  ios加密
//
//  Created by Candice on 17/1/4.
//  Copyright © 2017年 刘灵. All rights reserved.
//

#import "SecurityTool.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSDataAdditions.h"
#import "GTMBase64.h"
#import "NSString+Category.h"

@implementation SecurityTool

#pragma mark - AES加密
+ (NSString *)AESEncrypt:(NSString *)content {
    NSData *encryptData = [self AES128Encrypt:content];
    NSString *encryptResult = [encryptData base64Encoding];
    
    return encryptResult;
}

#pragma AES解密
+ (NSString *)AESDecrypt:(NSString *)content {
    NSData *decryptData = [self AES128Decrypt:content];
    NSString *decryptResult = [[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
    
    return decryptResult;
}

#pragma mark - DES加密
+ (NSString *)DESEncryptString:(NSString *)content {
    
    NSString *string = [self DESEncrypt:content key:DESKEY];
    return string;
}

const Byte iv[] = {1,2,3,4,5,6,7,8};
+ (NSString *)DESEncrypt:(NSString *)plainText key:(NSString *)key {
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding,[key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [GTMBase64 encodeBase64Data:data];
    }
    return ciphertext;
}

#pragma mark - DES解密
+ (NSString *)DESDecryptString:(NSString *)content {
    NSString *result = [self DESDecrypt:content key:DESKEY];
    
    return result ;
}

+ (NSString *)DESDecrypt:(NSString *)cipherText key:(NSString *)key {
    NSString *plaintext = nil;
    NSData *cipherdata = [GTMBase64 decodeString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

#pragma mark - MD5盐值加密
+ (NSString *)MD5WithPWD:(NSString *)pwd salt:(NSString *)salt {
    NSMutableString *pwdStr = [[NSMutableString alloc]initWithFormat:@"%@",[pwd md5]];
    [pwdStr appendString:[salt base64DecodeForUTF8]?[salt base64DecodeForUTF8]:@""];
    
    return [pwdStr md5];
}


#pragma mark - Private

+(NSData *)AES128Encrypt:(NSString *)content
{
    //偏移量
    NSString *AES_IV = @"ji213jfaljf98w4w";
    //加密key
    NSString *AES_KEY = @"ret78935jgdsu2l0";
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [AES_KEY getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char iv[kCCKeySizeAES128+1];
    bzero(iv, sizeof(iv));
    [AES_IV getCString:iv maxLength:sizeof(iv) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [contentData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          iv,
                                          [contentData bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

+(NSData*)AES128Decrypt:(NSString *)content
{
    //偏移量
    NSString *AES_IV = @"ji213jfaljf98w4w";
    //加密key
    NSString *AES_KEY = @"ret78935jgdsu2l0";
    
    NSData *contentData = [NSData base64Decode:content];
    
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [AES_KEY getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char iv[kCCKeySizeAES128+1];
    bzero(iv, sizeof(iv));
    [AES_IV getCString:iv maxLength:sizeof(iv) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [contentData length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          iv,
                                          [contentData bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

@end
