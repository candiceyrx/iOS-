//
//  ViewController.m
//  ios加密
//
//  Created by Candice on 17/1/4.
//  Copyright © 2017年 刘灵. All rights reserved.
//

#import "ViewController.h"
#import "SecurityTool.h"
#import "CRSA.h"
#import "Base64.h"

#define PriKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAJ2msiGRbzJDoOVJIbDEauZKuiAfpkqzkzOzCCi/6D0k6jR0qm/xFEXQH14LpWwCOkDhhPO8RC2CBx049kWSQd2t76Nk9tsKY4+nA/JZUIj7x/XauNd+D3oWdJILBEXB3SxP4oZ8eQJxYpaUN6nDiCi5W+Q4GrjpYDbNKgEHzSZZAgMBAAECgYBctOktekOkkEZubuoD9A1U7X60Y0g7x4v5q/9RT0D3q9yaCj0r5N3iC/hWKo0Vjd3Jx5SSbBS/miYq1hNkaBSYn9aegxmIunIbK6o6IsyvRCwI45VJsfGINyJsTqjYYUo4qgAVuhcM63pPc9uXsVDV9vGQLY7gkqc2OsfjQd5dzQJBAP4v2HENJ0BFDxFFjoF9y5ryCughpXUY5Kz7iiF5Yhb00vnEaOttyCW8O21tM+CCrfxAX/2RCaZno/p1dVHJRwMCQQCexpKUJw4Ay7D29LHcSBZ/IyNJRpDB2+z9lD4nxrgaubs6LH3vwzHvgiyV6++G8BhRAjNftaa46YP2rJ08YMBzAkEAx4Xg/OSZQd6zdBhIQybuUmLZ4tq+WMtAfPQ5ugrgzypADSR6Qwr6h3xYnY2RohKR5abWcmCN1ZwW4Dug6qD25wJBAIYN+FI4Cz2mvRo1DTqEbuIXI8LJXo0fB6AuGrBwup5t9GMwj3/w2Wd0C/rkwk62xoEXD5Mehs6W8oFBylvhAHsCQQD8CRmctR/XOq7I+kwysmLAx9RC6HYp8xwECp6C7v9wQe7sFZmkNUjG43R1PMUH2EPl/vT+p/W0Xksou/AFFh9L"

#define PubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCdprIhkW8yQ6DlSSGwxGrmSrogH6ZKs5Mzswgov+g9JOo0dKpv8RRF0B9eC6VsAjpA4YTzvEQtggcdOPZFkkHdre+jZPbbCmOPpwPyWVCI+8f12rjXfg96FnSSCwRFwd0sT+KGfHkCcWKWlDepw4gouVvkOBq46WA2zSoBB80mWQIDAQAB"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString *string = @"我们在一起工作";
    NSString *aesEncrypt = [SecurityTool AESEncrypt:string];
    NSLog(@"=========AES加密后的结果:%@",aesEncrypt);
    
    NSString *aesDecrypt = [SecurityTool AESDecrypt:aesEncrypt];
    NSLog(@"=========AES解码后的结果:%@",aesDecrypt);
    
    NSString *desEncrypt = [SecurityTool DESEncryptString:string];
    NSLog(@"=========DES加密后的内容:%@",desEncrypt);
    
    NSString *desDecrypt = [SecurityTool DESDecryptString:desEncrypt];
    NSLog(@"=========DES解密后的内容:%@",desDecrypt);
    
    CRSA *cc = [CRSA shareInstance];
    //写入公匙
    [cc writePukWithKey:PubKey];
    //写入私匙
    [cc writePrkWithKey:PriKey];
    NSString *rsaEncrypt = [cc encryptByRsaWithCutData:[string base64EncodedString] keyType:(KeyTypePrivate)];
    NSLog(@"=======RSA加密后的内容:%@",rsaEncrypt);
    NSString *rsaDecrypt = [[cc decryptByRsaWithCutData:rsaEncrypt keyType:(KeyTypePublic)] base64DecodedString];
    NSLog(@"=======RSA解密后的内容:%@",rsaDecrypt);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
