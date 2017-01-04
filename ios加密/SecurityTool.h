//
//  SecurityTool.h
//  ios加密
//
//  Created by Candice on 17/1/4.
//  Copyright © 2017年 刘灵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityTool : NSObject

#define DESKEY   @"95880288"

/**
 *  @author 刘灵
 *
 *  将内容采用指定key用AES128加密
 *
 *  @param content 加密内容
 *
 *  @return 加密的结果
 */
+(NSString *)AESEncrypt:(NSString *)content;

/**
 *  @author 刘灵
 *
 *  AES128解密
 *
 *  @param content 加密内容
 *
 *  @return 解密后的内容
 */
+(NSString*)AESDecrypt:(NSString *)content;

/**
 *  @author 刘灵
 *
 *  DES base64加密
 *
 *  @param content 加密内容
 *
 *  @return DES加密后的内容
 */
+ (NSString *)DESEncryptString:(NSString *)content;

/**
 *  @author 刘灵
 *
 *  DES解密
 *
 *  @param content 加密的内容
 *
 *  @return 返回解密后的结果
 */
+ (NSString *)DESDecryptString:(NSString *)content;


/**
 *  @author 刘灵
 *
 *  进行盐值与MD5加密后的结果
 *
 *  @param pwd  加密的内容
 *  @param salt 后台返回的盐值
 *
 *  @return 加密后的结果
 */
+(NSString *)MD5WithPWD:(NSString *)pwd salt:(NSString *)salt;
@end
