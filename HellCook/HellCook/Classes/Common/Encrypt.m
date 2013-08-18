//
//  Encrypt.m
//  HellCook
//
//  Created by panda on 8/18/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "Encrypt.h"
#import "Base64.h"
#import "Math.h"

@implementation Encrypt

+(NSString*)new3DESwithoperand:(NSString*)plaintext encryptOrDecrypt:(CCOperation)encryptorDecrypt key:(NSString*)key initVec:(NSString*)initVec
{
  
  NSData* data = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
  const void *vplainText = [data bytes];;
  size_t plainTextBufferSize = [data length];
  
  size_t bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);

  size_t movedBytes = 0;
  uint8_t *bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
  memset((void*)bufferPtr, 0x0, bufferPtrSize);
  const void * vkey = [[key dataUsingEncoding: NSUTF8StringEncoding] bytes];
  const void *vinitVec = [[initVec dataUsingEncoding: NSUTF8StringEncoding] bytes];
  
  //
  const char *keyStr = [key UTF8String];
  unsigned char keyDigest[16];
  CC_MD5(keyStr, strlen(keyStr), keyDigest);
  
  unsigned char realKeys[24];
  for (int i = 0; i < sizeof(realKeys); i++) realKeys[i] = 0;
  memcpy(realKeys, keyDigest, sizeof(keyDigest));
  
  vkey = realKeys;
  
  //
  const char *ivStr = [initVec UTF8String];
  unsigned char ivDigest[16];
  CC_MD5(ivStr, strlen(ivStr), ivDigest);
  
  unsigned char bIVs[8];
  for (int i = 0; i < 8; i++)
  {
    bIVs[i] = (char)(ABS(ivDigest[i] - ivDigest[i + 1]));
  }
  
  vinitVec = bIVs;
  
  //
  CCCryptorStatus ccStatus;
  ccStatus = CCCrypt(encryptorDecrypt,
                     kCCAlgorithm3DES,
                     kCCOptionPKCS7Padding,
                     vkey,
                     kCCKeySize3DES,
                     vinitVec,
                     vplainText,
                     plainTextBufferSize,
                     (void*)bufferPtr,
                     bufferPtrSize,
                     &movedBytes);
  
  NSData* result = [NSData dataWithBytes:(const void*)bufferPtr length:(NSUInteger)movedBytes];
  NSString* str = [result base64EncodedString];
  
  return str;
}

@end
