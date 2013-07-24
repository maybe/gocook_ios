//
//  AccountEngine.h
//  HellCook
//
//  Created by panda on 2/20/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

@interface HellEngine : MKNetworkEngine

typedef void (^LoginResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^RegResponseBlock)(NSMutableDictionary* resultDic);

typedef void (^iosMainResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^topNewResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^topHotResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^searchResponseBlock)(NSMutableDictionary* resultDic);

typedef void (^recipeDetailDataResponseBlock)(NSMutableDictionary* resultDic);

// 登录
- (MKNetworkOperation*)loginWithUser:(NSString*)username AndPass:(NSString*)pass
                   completionHandler:(LoginResponseBlock) completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock;

// 注册
- (MKNetworkOperation*)registerWithEmail:(NSString*)username AndNick:(NSString*)nick
                                 AndPass:(NSString*)pass AndRePass:(NSString*)repass
                           AndAvatarPath:(NSString*)avatar
                       completionHandler:(RegResponseBlock) completionBlock
                            errorHandler:(MKNKErrorBlock) errorBlock;

// 获取主界面
- (MKNetworkOperation*)getIOSMainDataWithCompletionHandler:(iosMainResponseBlock) completionBlock
                                              errorHandler:(MKNKErrorBlock) errorBlock;

// 获取最新
- (MKNetworkOperation*)getTopNewDataWithPage:(NSInteger)page
                           CompletionHandler:(topNewResponseBlock) completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock;

// 获取最热
- (MKNetworkOperation*)getTopHotDataWithPage:(NSInteger)page
                           CompletionHandler:(topHotResponseBlock) completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock;

// 搜索
- (MKNetworkOperation*)searchWithKey:(NSString*)key AndPage:(NSInteger)page
                   CompletionHandler:(searchResponseBlock) completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock;

// 获取菜谱详细信息
- (MKNetworkOperation*)getRecipeDetailData:(NSInteger)recipeId
                   CompletionHandler:(recipeDetailDataResponseBlock) completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock;

@end