//
//  Encrypt.m
//  HellCook
//
//  Created by panda on 8/18/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

//  How To Use:
//  NSString* decrypt = [Encrypt tripleDES:@"111111" encryptOrDecrypt:kCCEncrypt key:@"DAB578EC-6C01-4180-939A-37E6BE8A81AF" initVec:@"117A5C0F"];
//  NSString* encr = [Encrypt EncryptAppReqCMD:1 WithData:@"{\"Account\":\"15000021036\",\"Password\":\"rmHSyDSm1Dk=\"}"];

#import "Encrypt.h"
#import "Base64.h"

@implementation Encrypt

+(NSString*)tripleDES:(NSString*)plaintext encryptOrDecrypt:(CCOperation)encryptorDecrypt key:(NSString*)key initVec:(NSString*)initVec
{
  NSData* data = NULL;
  if (encryptorDecrypt == kCCEncrypt) {
    data = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
  } else {
    data = [plaintext base64DecodedData];
  }
  
  const void *vPlainText = [data bytes];
  size_t plainTextBufferSize = [data length];
  
  size_t bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);

  size_t movedBytes = 0;
  uint8_t *bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
  memset((void*)bufferPtr, 0x0, bufferPtrSize);
  const void *vKey = NULL;
  const void *vInitVec = NULL;
  
  //
  const char *keyStr = [key UTF8String];
  unsigned char keyDigest[16];
  CC_MD5(keyStr, strlen(keyStr), keyDigest);
  
  unsigned char realKeys[24];
  for (int i = 0; i < sizeof(realKeys); i++) realKeys[i] = 0;
  memcpy(realKeys, keyDigest, sizeof(keyDigest));
  
  vKey = realKeys;
  
  //
  const char *ivStr = [initVec UTF8String];
  unsigned char ivDigest[16];
  CC_MD5(ivStr, strlen(ivStr), ivDigest);
  
  unsigned char bIVs[8];
  for (int i = 0; i < 8; i++)
  {
    bIVs[i] = (unsigned char)(ABS(ivDigest[i] - ivDigest[i + 1]));
  }
  
  vInitVec = bIVs;
  
  //
  CCCryptorStatus ccStatus;
  ccStatus = CCCrypt(encryptorDecrypt,
                     kCCAlgorithm3DES,
                     kCCOptionPKCS7Padding,
                     vKey,
                     kCCKeySize3DES,
                     vInitVec,
                     vPlainText,
                     plainTextBufferSize,
                     (void*)bufferPtr,
                     bufferPtrSize,
                     &movedBytes);

  if (kCCSuccess == ccStatus)
  {
    NSData* result = [NSData dataWithBytes:(const void*)bufferPtr length:(NSUInteger)movedBytes];
    NSString* str = NULL;

    if (encryptorDecrypt == kCCEncrypt) {
      str = [result base64EncodedString];
    } else {
      str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return str;
  } else {
    return @"";
  }
}

+(NSString*)EncryptAppReqCMD:(NSInteger)cmd WithData:(NSString*)data
{
  NSString* raw_data = [NSString stringWithFormat:@"%@%d%d%@%@", APP_KEY, cmd, APP_ID, data, APP_IV];

  const char *keyStr = [raw_data UTF8String];
  unsigned char keyDigest[16];
  CC_MD5(keyStr, strlen(keyStr), keyDigest);

  NSData* md5_data = [NSData dataWithBytes:(const void*)keyDigest length:16];

  NSString * base64_data_str = [md5_data base64EncodedString];
  return base64_data_str;
}

+(NSString*) md5:(NSString*) str
{
  const char *cStr = [str UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5( cStr, strlen(cStr), result );

  NSMutableString *hash = [NSMutableString string];
  for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
  {
    [hash appendFormat:@"%02X",result[i]];
  }
  return [hash lowercaseString];
}


+(NSString *)file_md5:(NSString*) path
{
  NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
  if(handle == nil)
    return nil;

  CC_MD5_CTX md5_ctx;
  CC_MD5_Init(&md5_ctx);

  NSData*fileData;
  do {
    fileData = [handle readDataOfLength:CHUNK_SIZE];
    CC_MD5_Update(&md5_ctx, [fileData bytes], [fileData length]);
  }
  while([fileData length]);

  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5_Final(result, &md5_ctx);

  [handle closeFile];

  NSMutableString *hash = [NSMutableString string];
  for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
  {
    [hash appendFormat:@"%02x",result[i]];
  }
  return [hash lowercaseString];
}


@end
