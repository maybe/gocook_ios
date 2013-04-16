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


- (MKNetworkOperation*)RegisterWithEmail:(NSString*)email AndNick:(NSString*)nick
                                AndPass:(NSString*)pass AndRePass:(NSString*)repass
                          AndAvatarPath:(NSString*)avatar
                      completionHandler:(RegResponseBlock) completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock
{
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  [dic setValue:email forKey:@"email"];
  [dic setValue:nick forKey:@"nickname"];
  [dic setValue:pass forKey:@"password"];
  [dic setValue:repass forKey:@"repassword"];
  
  MKNetworkOperation *op = [self operationWithPath:@"user/register"
                                            params:dic
                                        httpMethod:@"POST"];
  
  if (avatar&&![avatar isEqualToString:@""]) {
    [op addFile:avatar forKey:@"avatar"];
  }
  
  NSString* aStr;
  
  aStr = [[NSString alloc] initWithData:[[op readonlyRequest] HTTPBody] encoding:NSASCIIStringEncoding];

   NSLog(@"%@",  aStr);
    
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
