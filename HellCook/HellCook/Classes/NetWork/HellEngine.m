//
//  AccountEngine.h
//  HellCook
//
//  Created by panda on 2/20/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "HellEngine.h"
#import "UserAccount.h"
#import "User.h"
#import "Encrypt.h"

@implementation HellEngine

- (MKNetworkOperation*)loginWithUser:(NSString*)tel AndPass:(NSString*)pass
                   completionHandler:(LoginResponseBlock) completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock
{
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  [dic setValue:tel forKey:@"login"];
  NSString* password = [Encrypt tripleDES:pass encryptOrDecrypt:kCCEncrypt key:APP_KEY  initVec:APP_IV];
  [dic setValue:password forKey:@"password"];
  
  MKNetworkOperation *op = [self operationWithPath:@"user/login"
                                            params:dic
                                        httpMethod:@"POST"];

  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {

      // save login info
      if (jsonObject!=nil && [[jsonObject objectForKey:@"result"] intValue] == 0) {
        
        UserAccount* userAccount = [[User sharedInstance] account];
        
        userAccount.username = jsonObject[@"username"];
        userAccount.avatar = jsonObject[@"icon"];
        
        NSString* session = completedOperation.readonlyResponse.allHeaderFields[@"Set-Cookie"];
        
        NSMutableDictionary* dic = nil;
        dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
               jsonObject[@"user_id"], @"user_id",
               jsonObject[@"username"], @"username",
               tel, @"tel",
               pass, @"password",
               session, @"session",
               jsonObject[@"icon"], @"avatar", nil];
        
        [userAccount login:dic];
        
        [[[User sharedInstance] account] setShouldResetLogin:YES];
      }
      
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}


- (MKNetworkOperation*)registerWithTel:(NSString *)tel AndNick:(NSString *)nick
                               AndPass:(NSString *)pass AndRePass:(NSString *)repass
                         AndAvatarPath:(NSString *)avatar
                     completionHandler:(RegResponseBlock)completionBlock
                          errorHandler:(MKNKErrorBlock) errorBlock
{
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  [dic setValue:nick forKey:@"nickname"];
  NSString* password = [Encrypt tripleDES:pass encryptOrDecrypt:kCCEncrypt key:APP_KEY  initVec:APP_IV];
  NSString* rePassword = [Encrypt tripleDES:pass encryptOrDecrypt:kCCEncrypt key:APP_KEY  initVec:APP_IV];
  [dic setValue:password forKey:@"password"];
  [dic setValue:tel forKey:@"tel"];
  [dic setValue:rePassword forKey:@"repassword"];

  MKNetworkOperation *op = [self operationWithPath:@"user/register"
                                            params:dic
                                        httpMethod:@"POST"];
  
  if (avatar&&![avatar isEqualToString:@""]) {
    [op addFile:avatar forKey:@"avatar"];
  }

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


- (MKNetworkOperation*)getIOSMainDataWithCompletionHandler:(iosMainResponseBlock) completionBlock
                                              errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:@"index/ios_main"
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
//    NSLog(@"%@",completedOperation.responseString);
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
  
  NSString* encodingKey = [[NSString alloc] initWithString: [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  
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


- (MKNetworkOperation*)getRecipeDetailData:(NSInteger)recipeId
                         CompletionHandler:(recipeDetailDataResponseBlock) completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock
{
  
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:
                                                    @"recipe/index?id=%d",recipeId]
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


- (MKNetworkOperation*)getMyCollectionDataByPage:(NSInteger)page
                         CompletionHandler:(myCollectionResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/mycoll?page=%d",page]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
//    NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}


- (MKNetworkOperation*)getMyRecipesDataByPage:(NSInteger)page
                            CompletionHandler:(myRecipesResponseBlock)completionBlock
                                 errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/myrecipes?page=%d",page]
                                            params:nil
                                        httpMethod:@"GET"];
  
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

- (MKNetworkOperation*)getMyIntroductionDataWithCompletionHandler:(myRecipesResponseBlock)completionBlock
                                                     errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"user/basicinfo"]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
//    NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}


- (MKNetworkOperation*)getMyFollowDataByPage:(NSInteger)page
                           CompletionHandler:(myFollowResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/mywatch?page=%d",page]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
//    NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}


- (MKNetworkOperation*)getMyFansDataByPage:(NSInteger)page
                         CompletionHandler:(myFansResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/myfans?page=%d",page]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
//    NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}


- (MKNetworkOperation*)uploadBasicInfoWithDict:(NSMutableDictionary*)dict
                             completionHandler:(uploadBasicInfoResponseBlock)completionBlock
                                  errorHandler:(MKNKErrorBlock)errorBlock
{
  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
  
  MKNetworkOperation *op = [self operationWithPath:@"user/changebasicinfo"
                                            params:dic
                                        httpMethod:@"POST"];
  
//  NSString* aStr;
//  aStr = [[NSString alloc] initWithData:[[op readonlyRequest] HTTPBody] encoding:NSASCIIStringEncoding];
//  NSLog(@"%@",  aStr);
  
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

- (MKNetworkOperation*)uploadCoverTmpImage:(NSString*)imagePath
                         completionHandler:(uploadCoverTmpImageResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:@"recipe/upload_cover_photo"
                                            params:nil
                                        httpMethod:@"POST"];
  
  if (imagePath&&![imagePath isEqualToString:@""]) {
    [op addFile:imagePath forKey:@"cover"];
  }
  
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

- (MKNetworkOperation*)uploadAvatarByPath:(NSString*)path
                        CompletionHandler:(uploadAvatarResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:@"user/changeavatar"
                                            params:nil
                                        httpMethod:@"POST"];
  if (path && ![path isEqualToString:@""]) {
    [op addFile:path forKey:@"avatar"];
  }
  
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


- (MKNetworkOperation*)uploadStepTmpImage:(NSString*)imagePath
                                withIndex:(NSInteger)index
                        completionHandler:(uploadStepTmpImageResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:@"recipe/upload_step_photo"
                                            params:nil
                                        httpMethod:@"POST"];
  
  if (imagePath&&![imagePath isEqualToString:@""]) {
    [op addFile:imagePath forKey:@"step"];
  }
    
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){    
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject, index);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}


- (MKNetworkOperation*)createRecipe:(NSDictionary*)uploadDic
                  completionHandler:(createRecipeResponseBlock)completionBlock
                       errorHandler:(MKNKErrorBlock) errorBlock
{
  
  MKNetworkOperation *op = [self operationWithPath:@"recipe/create"
                                            params:uploadDic
                                        httpMethod:@"POST"];
  
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


- (MKNetworkOperation*)getOtherIntroWithUserID:(NSInteger)userid
                             CompletionHandler:(getOtherIntroResponseBlock) completionBlock
                                  errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/kitchen?userid=%d",userid]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    //    NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)watchWithUserID:(NSInteger)userid
                     CompletionHandler:(watchResponseBlock) completionBlock
                          errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/watch?watchid=%d",userid]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    //    NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)unwatchWithUserID:(NSInteger)userid
                       CompletionHandler:(unwatchResponseBlock) completionBlock
                            errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/unwatch?watchid=%d",userid]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
//    NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)getCommentsWithRecipeID:(NSInteger)recipeid
                             CompletionHandler:(getCommentsResponseBlock) completionBlock
                                  errorHandler:(MKNKErrorBlock) errorBlock;
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"recipe/comments?recipe_id=%d",recipeid] params:nil httpMethod:@"GET"];
  
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

- (MKNetworkOperation*)commentWithDict:(NSMutableDictionary*)dict
                     completionHandler:(commentResponseBlock)completionBlock
                          errorHandler:(MKNKErrorBlock)errorBlock
{
  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
  
  MKNetworkOperation *op = [self operationWithPath:@"recipe/comment"
                                            params:dic
                                        httpMethod:@"POST"];
  
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

- (MKNetworkOperation*)addCollectionWithCollID:(NSInteger)collID
                             completionHandler:(addCollectionResponseBlock)completionBlock
                                  errorHandler:(MKNKErrorBlock)errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/addmycoll?collid=%d",collID]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    //    NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)delCollectionWithCollID:(NSInteger)collID
                             completionHandler:(delCollectionResponseBlock)completionBlock
                                  errorHandler:(MKNKErrorBlock)errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/delmycoll?collid=%d",collID]
                                            params:nil
                                        httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    //    NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)getGoodsWithKeyword:(NSString*)keyword
                                  withPage:(NSInteger)page
                         completionHandler:(getGoodsResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock)errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/search_wares?keyword=%@&page=%d",keyword,page] params:nil httpMethod:@"GET"];
  
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
