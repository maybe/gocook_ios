//
//  RecipeEngine
//  HellCook
//
//  Created by panda on 4/16/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "CookEngine.h"


@implementation CookEngine

- (MKNetworkOperation*)getIOSMainDataWithCompletionHandler:(iosMainResponseBlock) completionBlock
                                              errorHandler:(MKNKErrorBlock) errorBlock
{  
  MKNetworkOperation *op = [self operationWithPath:@"index/ios_main"
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    //NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)getTopNewDataWithPage:(NSInteger)page
                           CompletionHandler:(topNewResponseBlock) completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock
{  
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"recipe/topnew?page=%d",page]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    //NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)getTopHotDataWithPage:(NSInteger)page
                           CompletionHandler:(topHotResponseBlock) completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock
{  
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"recipe/tophot?page=%d",page]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    //NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)searchWithKey:(NSString*)key AndPage:(NSInteger)page
                   CompletionHandler:(searchResponseBlock) completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock
{
  
  NSString* encodingKey = [[NSString alloc] initWithString: [key  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"index/search?keyword=%@&page=%d",encodingKey,page]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    //NSLog(@"%@",completedOperation.responseString);
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
