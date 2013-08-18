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

+(NSString*)new3DESwithoperand:(NSString*)plaintext encryptOrDecrypt:(CCOperation)encryptorDecrypt key:(NSString*)key initVec:(NSString*)initVec;

@end
