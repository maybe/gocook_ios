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
#import "DBHandler.h"

@implementation HellEngine

- (void)setCookie:(NSString *)cookie {
  NSMutableDictionary *newHeadersDict = [self.customHeaders mutableCopy];
  newHeadersDict[@"Cookie"] = [NSString stringWithString:cookie];
  self.customHeaders = newHeadersDict;
}

- (void)removeCookie {
  NSMutableDictionary *newHeadersDict = [self.customHeaders mutableCopy];
  newHeadersDict[@"Cookie"] = @"";
  self.customHeaders = newHeadersDict;
}

- (MKNetworkOperation*)authWithData:(NSString*)data AndRnd:(NSString*)rnd
                  completionHandler:(AuthResponseBlock) completionBlock
                       errorHandler:(MKNKErrorBlock) errorBlock
{
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  [dic setValue:data forKey:@"data"];
  [dic setValue:rnd forKey:@"rnd"];

  MKNetworkOperation *op = [self operationWithPath:@"user/login_ex"
                                            params:dic
                                        httpMethod:@"POST"];
  [op useCookie:NO];
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      //NSLog(@"%@",completedOperation.responseString);
      // save login info
      if (jsonObject!=nil && [[jsonObject objectForKey:@"result"] intValue] == 0) {

        NSString* session = completedOperation.readonlyResponse.allHeaderFields[@"Set-Cookie"];
        NSArray* session_array = [session componentsSeparatedByString:@"path=/, "];
        NSString* real_session = @"";
        NSUInteger session_array_count = [session_array count];
        if (session_array_count > 0) {
          real_session = session_array[session_array_count - 1];
        }
        [self setCookie:real_session];

        UserAccount* userAccount = [[User sharedInstance] account];
        userAccount.username = jsonObject[@"username"];
        userAccount.avatar = jsonObject[@"icon"];

        NSMutableDictionary* login_dic = nil;
        login_dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
            jsonObject[@"user_id"], @"user_id",
            jsonObject[@"username"], @"username",
            real_session, @"session",
            jsonObject[@"icon"], @"avatar", nil];

        [userAccount login:login_dic];

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

- (MKNetworkOperation*)getIOSMainDataWithCompletionHandler:(iosMainResponseBlock) completionBlock
                                              errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:@"index/ios_main"
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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
                           completionHandler:(topNewResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"recipe/topnew?page=%d",page]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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
                           completionHandler:(topHotResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"recipe/tophot?page=%d",page]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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

- (MKNetworkOperation*)searchWithKey:(NSString *)key AndPage:(NSInteger)page
                   completionHandler:(searchResponseBlock)completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock
{
  
  NSString* encodingKey = [[NSString alloc] initWithString: [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"index/search?keyword=%@&page=%d",encodingKey,page]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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
                         completionHandler:(recipeDetailDataResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock
{
  
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:
                                                    @"recipe/index?id=%d",recipeId]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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
                               completionHandler:(myCollectionResponseBlock)completionBlock
                                    errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/mycoll?page=%d",page]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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


- (MKNetworkOperation*)getUserRecipesDataByPage:(NSInteger)page
                                     WithUserID:(NSInteger)userID
                              completionHandler:(userRecipesResponseBlock)completionBlock
                                   errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/usersrecipes?userid=%d&page=%d",userID,page]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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

- (MKNetworkOperation*)getMyIntroductionDataWithCompletionHandler:(myIntroductionResponseBlock)completionBlock
                                                     errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"user/basicinfo"]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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


- (MKNetworkOperation*)getUserFollowDataByPage:(NSInteger)page
                                    WithUserID:(NSInteger)userID
                             completionHandler:(userFollowResponseBlock)completionBlock
                                  errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/user_watch?page=%d&userid=%d",page,userID]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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
                                WithUserID:(NSInteger)userID
                         completionHandler:(userFansResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/user_fans?page=%d&userid=%d",page,userID]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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


- (MKNetworkOperation*)uploadBasicInfoWithDict:(NSMutableDictionary*)dict
                             completionHandler:(uploadBasicInfoResponseBlock)completionBlock
                                  errorHandler:(MKNKErrorBlock)errorBlock
{
  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
  
  MKNetworkOperation *op = [self operationWithPath:@"user/changebasicinfo"
                                            params:dic
                                        httpMethod:@"POST"];
  [op useCookie:NO];

  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      if (jsonObject!=nil && [[jsonObject objectForKey:@"result"] intValue] == 0) {
        UserAccount* userAccount = [[User sharedInstance] account];
        if ([[dict allKeys] containsObject:@"nickname"]) {
          userAccount.username = dict[@"nickname"];
          DBHandler* dbHandler = [DBHandler sharedInstance];
          [dbHandler changeName:dict[@"nickname"]];
          [[[User sharedInstance] account] setShouldResetLogin:YES];
        }
      }
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
  [op useCookie:NO];
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

- (MKNetworkOperation*)uploadAvatarByPath:(NSString *)path
                        completionHandler:(uploadAvatarResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:@"user/changeavatar"
                                            params:nil
                                        httpMethod:@"POST"];
  [op useCookie:NO];
  if (path && ![path isEqualToString:@""]) {
    [op addFile:path forKey:@"avatar"];
  }
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      if (jsonObject!=nil && [[jsonObject objectForKey:@"result"] intValue] == 0) {
        UserAccount* userAccount = [[User sharedInstance] account];
        userAccount.avatar = jsonObject[@"avatar"];
        DBHandler* dbHandler = [DBHandler sharedInstance];
        [dbHandler changeAvatar:jsonObject[@"avatar"]];
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


- (MKNetworkOperation*)uploadStepTmpImage:(NSString*)imagePath
                                withIndex:(NSInteger)index
                        completionHandler:(uploadStepTmpImageResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:@"recipe/upload_step_photo"
                                            params:nil
                                        httpMethod:@"POST"];
  [op useCookie:NO];
  if (imagePath&&![imagePath isEqualToString:@""]) {
    [op addFile:imagePath forKey:@"step"];
  }
    
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
      //NSLog(@"%@",completedOperation.responseString);

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
  [op useCookie:NO];
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

- (MKNetworkOperation *)modifyRecipe:(NSDictionary *)uploadDic completionHandler:(modifyRecipeRespondBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock {
  MKNetworkOperation *op = [self operationWithPath:@"recipe/modify"
                                            params:uploadDic
                                        httpMethod:@"POST"];
  [op useCookie:NO];
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

- (MKNetworkOperation *)deleteRecipe:(NSInteger)recipeId completionHandler:(deleteRecipeRespondBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock {
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"recipe/delete?recipe_id=%d",recipeId]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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
                             completionHandler:(getOtherIntroResponseBlock)completionBlock
                                  errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/kitchen?userid=%d",userid]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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
                     completionHandler:(watchResponseBlock)completionBlock
                          errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/watch?watchid=%d",userid]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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
                       completionHandler:(unwatchResponseBlock)completionBlock
                            errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/unwatch?watchid=%d",userid]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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
                             completionHandler:(getCommentsResponseBlock)completionBlock
                                  errorHandler:(MKNKErrorBlock) errorBlock;
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"recipe/comments?recipe_id=%d",recipeid] params:nil httpMethod:@"GET"];
  [op useCookie:NO];
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    // NSLog(@"%@",completedOperation.responseString);
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
  [op useCookie:NO];
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    // NSLog(@"%@",completedOperation.responseString);
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
  [op useCookie:NO];
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    // NSLog(@"%@",completedOperation.responseString);
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
  [op useCookie:NO];
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
  NSString* encodingKey = [[NSString alloc] initWithString: [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/search_wares?keyword=%@&page=%d",encodingKey,page] params:nil httpMethod:@"GET"];
  
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    // NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)buyGoodsWithDict:(NSMutableDictionary*)dict
                      completionHandler:(buyGoodsResponseBlock)completionBlock
                           errorHandler:(MKNKErrorBlock)errorBlock
{
  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
  // NSLog(@"%@",dic);
  
  MKNetworkOperation *op = [self operationWithPath:@"cook/order"
                                            params:dic
                                        httpMethod:@"POST"];
  [op useCookie:NO];
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

- (MKNetworkOperation*)getHistoryDealWithDict:(NSMutableDictionary*)dict
                            completionHandler:(getHistoryDealResponseBlock)completionBlock
                                 errorHandler:(MKNKErrorBlock)errorBlock
{
  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
//  NSLog(@"%@",dic);
  
  MKNetworkOperation *op = [self operationWithPath:@"cook/his_orders"
                                            params:dic
                                        httpMethod:@"POST"];
  
  [op useCookie:NO];
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
   // NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)getAllMyCouponsByPage:(NSInteger)page
                           completionHandler:(allMyCouponsResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/my_coupons?page=%d",page]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
  // NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)getSalesOfTodayWithCompletionHandler:(getSalesOfTodayResponseBlock)completionBlock
                                               errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/day_sales"]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
//   NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)getCouponsById:(NSString*)couponId
                    completionHandler:(getCouponsResponseBlock)completionBlock
                         errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/get_coupon?id=%@",couponId]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
     // NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation*)delayLotteryById:(NSString*)couponId
                      completionHandler:(delayLotteryResponseBlock)completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/delay_coupon?id=%@",couponId]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    // NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];
  
  [self enqueueOperation:op];
  
  return op;
}

- (MKNetworkOperation *)getKitchenInfoById:(NSString *)userId
                         completionHandler:(kitchenInfoResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock)errorBlock
{
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/kitchen_info?userid=%@",userId]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
  [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
    // NSLog(@"%@",completedOperation.responseString);
    [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
      completionBlock(jsonObject);
    }];
  }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
    errorBlock(error);
  }];

  [self enqueueOperation:op];

  return op;
}

- (MKNetworkOperation *)likeRecipe:(NSInteger)recipeId completionHandler:(likeResponseBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock {
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/like?likeid=%d",recipeId]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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

- (MKNetworkOperation *)unlikeRecipe:(NSInteger)recipeId completionHandler:(unlikeResponseBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock {
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/unlike?likeid=%d",recipeId]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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

- (MKNetworkOperation *)getM6AuthInfoWithCompletionHandler:(getM6AuthResponseBlock)completionBlock errorHandler:(MKNKErrorBlock)errorBlock {
  MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"cook/my_auth"]
                                            params:nil
                                        httpMethod:@"GET"];
  [op useCookie:NO];
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
