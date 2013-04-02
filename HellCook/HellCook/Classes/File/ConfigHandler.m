//
//  FileHandler.m
//  HC
//
//  Created by panda on 11-12-11.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "ConfigHandler.h"
#import "iconv.h"
#import "User.h"
#import "NetManager.h"

#define kSettingFileName @"setting.plist"

@implementation ConfigHandler
@synthesize settingDictionary,settingPath;

+ (id)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

-(id)init{
  if(self=[super init]){
    settingDictionary = [[NSMutableDictionary alloc]init];
    [self initSettings];
  }
  return self;
}

- (void)initSettings
{
  settingPath = [Common dataFilePath:kSettingFileName];
  //初始化
  if (![[NSFileManager defaultManager] fileExistsAtPath:settingPath]) {
    NSMutableDictionary *defDictionary = [[NSMutableDictionary alloc] init];
    [defDictionary setObject:@"1" forKey:@"imageOn"];
    [defDictionary setObject:@"0" forKey:@"autoMail"];
    [defDictionary setObject:@"1" forKey:@"historyOn"];
    [defDictionary setObject:@"0" forKey:@"font"];
    [defDictionary writeToFile:settingPath atomically:YES];
  }
}

- (NSMutableDictionary*)loadSettings
{
  [settingDictionary removeAllObjects];
  
  NSString *filePath = [Common dataFilePath:kSettingFileName];
  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    NSMutableDictionary* tmpDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if ([tmpDic objectForKey:@"imageOn"]==nil) {
      [tmpDic setObject:@"1" forKey:@"imageOn"];
    }
    if ([tmpDic objectForKey:@"autoMail"]==nil) {
      [tmpDic setObject:@"0" forKey:@"autoMail"];
    }
    if ([tmpDic objectForKey:@"historyOn"]==nil) {
      [tmpDic setObject:@"1" forKey:@"historyOn"];
    }
    if ([tmpDic objectForKey:@"font"]==nil) {
      [tmpDic setObject:@"0" forKey:@"font"];
    }
    
    [settingDictionary setDictionary:tmpDic];
  }
  return settingDictionary;
}

- (void)saveSettings
{  
  NSString *filePath = [Common dataFilePath:kSettingFileName];
  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    [settingDictionary writeToFile:filePath atomically:YES];
  }
}

@end
