//
//  FileHandler.h
//  HC
//
//  Created by panda on 11-12-11.
//  Copyright (c) 2013 panda. All rights reserved.
//
//  Setting存放host


#import <Foundation/Foundation.h>
#import "GCDSingleton.h"

@interface ConfigHandler : NSObject{
  NSString* settingPath;
  NSMutableDictionary* settingDictionary;
}

@property (nonatomic, retain) NSMutableDictionary* settingDictionary;
@property (nonatomic, retain) NSString* settingPath;

+ (id)sharedInstance;

- (id)init;

- (void)initSettings;
- (NSMutableDictionary*)loadSettings;
- (void)saveSettings;

@end
