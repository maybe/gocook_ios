//
//  Common.h
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// define some macros
#ifndef __has_feature
#define __has_feature(x) 0
#endif
#ifndef __has_extension
#define __has_extension __has_feature // Compatibility with pre-3.0 compilers.
#endif

#if __has_feature(objc_arc) && __clang_major__ >= 3
#define HC_ARC_ENABLED 1
#endif // __has_feature(objc_arc)

#if HC_ARC_ENABLED
#define HC_RETAIN(xx) (xx)
#define HC_RELEASE(xx)  xx = nil
#define HC_AUTORELEASE(xx)  (xx)
#else
#define HC_RETAIN(xx)           [xx retain]
#define HC_RELEASE(xx)          [xx release], xx = nil
#define HC_AUTORELEASE(xx)      [xx autorelease]
#endif

#ifndef HCRSLog
#if DEBUG
# define HCRSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define HCRSLog(fmt, ...)
#endif
#endif

#define HCSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)

#define isRetina4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define _screenHeight [[UIScreen mainScreen] bounds].size.height
#define _screenWidth [[UIScreen mainScreen] bounds].size.width
#define _stateBarHeight 20
#define _navigationBarHeight 44
#define _tabBarHeight 49
#define _screenHeight_NoStBar (_screenHeight - _stateBarHeight)
#define _screenHeight_NoStBar_NoNavBar (_screenHeight - _stateBarHeight - _navigationBarHeight)
#define _screenHeight_NoStBar_NoNavBar_NoTabBar (_screenHeight - _stateBarHeight - _navigationBarHeight - _tabBarHeight)

#define _offset 40
#define _sideWindowWidth (_screenWidth - _offset)

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define _defaultHostName @"localhost"

#define APP_ID 1
#define APP_KEY @"DAB578EC-6C01-4180-939A-37E6BE8A81AF"
#define APP_IV @"117A5C0F"

typedef enum {
  ViewControllerCalledFromMyIndividual = 1,//个人登录成功后的功能首页
  ViewControllerCalledFromMyFollow = 2,
  ViewControllerCalledFromMyFan = 3,
  ViewControllerCalledFromRecipeComment
} ViewControllerCalledFrom;

typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *myasset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

typedef enum {
  Recipe140ImageUrl,
  Recipe526ImageUrl,
  RecipeStepImageUrl,
  AvatarImageUrl,
  ImageUrlNone,
} FullImageUrl;

@interface Common : NSObject

+ (NSString *)dataFilePath:(NSString*)filePath;
+(void)loadPhotoFromURL:(NSURL*)imgURL thumbnail:(BOOL)useThumbnail showIn:(UIImageView*)imView;
+ (NSString *) displayViews: (UIView *) aView;
+ (void)dumpView:(UIView *)aView atIndent:(int)indent into:(NSMutableString *)outString;

+ (NSString *)getUrl:(NSString *)url withType:(FullImageUrl) type;

@end
