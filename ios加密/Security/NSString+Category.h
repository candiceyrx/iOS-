//
//  NSString+Category.h
//  ios加密
//
//  Created by Candice on 17/1/4.
//  Copyright © 2017年 刘灵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
/**
 *  @author 刘灵
 *
 *  MD5加密
 *
 *  @return 返回MD5加密后的结果
 */
- (NSString *)md5;

/**
 *  @author 刘灵
 *
 *  UTF8编码后的URL
 *
 *  @return 返回编码后的值
 */
- (NSString*)encodedURLForUTF8;

/**
 *  @author 刘灵
 *
 *  字符串以UTF8编码方式执行base64解码
 *
 *  @return 返回解码后的结果
 */
- (NSString *)base64DecodeForUTF8;

/**
 *  @author 刘灵
 *
 *  字符串以UTF8编码方式转换base64
 *
 *  @return 返回编码后的结果
 */
- (NSString *)base64EncodedForUTF8;
@end
