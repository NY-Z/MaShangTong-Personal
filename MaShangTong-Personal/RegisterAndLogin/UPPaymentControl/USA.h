//
//  USA.h
//  MaShangTong-Personal
//
//  Created by q on 16/2/24.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USA : NSObject

// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;


+ (NSString *)encryptBCDString:(NSString *)str publicKey:(NSString *)pubKey;

+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;


+ (OSStatus)verifyData:(NSData *)data sig:(NSData *)sig  publicKey:(NSString*) pubKey;

@end
