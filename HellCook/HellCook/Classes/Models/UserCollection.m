//
//  UserCollection.m
//  HellCook
//
//  Created by panda on 3/31/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "UserCollection.h"

@implementation UserCollection
@synthesize collectCount;
@synthesize myCollectionArray;

-(id)init{
  if(self=[super init]){
    collectCount = 0;
    myCollectionArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void) SetMyCollectionArray:(NSArray*)newColletionArray
{
  [myCollectionArray removeAllObjects];
  [myCollectionArray addObjectsFromArray:newColletionArray];
  
  collectCount = [myCollectionArray count];
}

@end
