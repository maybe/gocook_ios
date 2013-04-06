//
//  Recipe.h
//  HellCook
//
//  Created by panda on 3/31/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject
{
  NSMutableDictionary* mainTopDic;//最受欢迎和最新
  NSMutableDictionary* mainCatDic;//分类
}

@property (nonatomic, retain) NSDictionary* mainTopDic;
@property (nonatomic, retain) NSDictionary* mainCatDic;

@end
