//
//  Encrypt.h
//  HellCook
//
//  Created by panda on 8/18/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface Encrypt : NSObject

#define CHUNK_SIZE 1024

+(NSString*)tripleDES:(NSString*)plaintext encryptOrDecrypt:(CCOperation)encryptorDecrypt key:(NSString*)key initVec:(NSString*)initVec;
+(NSString*)EncryptAppReqCMD:(NSInteger)cmd WithData:(NSString*)data;
+(NSString*) md5:(NSString*) str;
+(NSString *)file_md5:(NSString*) path;

@end
