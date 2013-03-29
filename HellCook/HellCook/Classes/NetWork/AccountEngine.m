//
//  AccountEngine.h
//  HellCook
//
//  Created by panda on 2/20/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "AccountEngine.h"


@implementation AccountEngine

- (MKNetworkOperation*)loginWithUser:(NSString*)username AndPass:(NSString*)pass
                   completionHandler:(LoginResponseBlock) completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock
{
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  [dic setValue:username forKey:@"login"];
  [dic setValue:pass forKey:@"password"];
  
  MKNetworkOperation *op = [self operationWithPath:@"user/login"
                                            params:dic
                                        httpMethod:@"POST"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
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
