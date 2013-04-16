//
//  RecipeEngine
//  HellCook
//
//  Created by panda on 4/16/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "RecipeEngine.h"


@implementation RecipeEngine

- (MKNetworkOperation*)getIOSMainDataWithCompletionHandler:(iosMainResponseBlock) completionBlock
                                              errorHandler:(MKNKErrorBlock) errorBlock;
{  
  MKNetworkOperation *op = [self operationWithPath:@"index/ios_main"
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}


@end
