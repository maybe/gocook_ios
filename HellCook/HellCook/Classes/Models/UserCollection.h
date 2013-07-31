//
//  UserCollection.h
//  HellCook
//
//  Created by panda on 3/31/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCollection : NSObject
{
  NSInteger collectCount;
  NSMutableArray *myCollectionArray;
}

@property NSInteger collectCount;
@property (nonatomic, retain) NSMutableArray* myCollectionArray;

- (NSInteger) collectCount;
- (void) SetMyCollectionArray:(NSArray*)newColletionArray;

@end
