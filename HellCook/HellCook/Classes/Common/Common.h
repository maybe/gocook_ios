//
//  Common.h
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

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

#define _offset 40

@interface Common : NSObject

@end
