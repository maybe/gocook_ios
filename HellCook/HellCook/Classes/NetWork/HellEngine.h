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
typedef void (^myCollectionResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^myRecipesResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^myIntroductionResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^myFollowResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^myFansResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^uploadBasicInfoResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^uploadAvatarResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^getOtherIntroResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^watchResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^unwatchResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^getCommentsResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^commentResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^addCollectionResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^delCollectionResponseBlock)(NSMutableDictionary* resultDic);

typedef void (^uploadCoverTmpImageResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^uploadStepTmpImageResponseBlock)(NSMutableDictionary* resultDic, NSInteger index);
typedef void (^createRecipeResponseBlock)(NSMutableDictionary* resultDic);

// 登录
- (MKNetworkOperation*)loginWithUser:(NSString*)username AndPass:(NSString*)pass
                   completionHandler:(LoginResponseBlock) completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock;

// 注册
- (MKNetworkOperation*)registerWithEmail:(NSString*)username AndNick:(NSString*)nick  AndTel:(NSString*)tel
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

//获取我的收藏
- (MKNetworkOperation*)getMyCollectionDataByPage:(NSInteger)page
                   CompletionHandler:(myCollectionResponseBlock)completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock;

//获取我的菜谱
- (MKNetworkOperation*)getMyRecipesDataByPage:(NSInteger)page
                               CompletionHandler:(myRecipesResponseBlock)completionBlock
                                    errorHandler:(MKNKErrorBlock) errorBlock;

//获取个人信息
- (MKNetworkOperation*)getMyIntroductionDataWithCompletionHandler:(myRecipesResponseBlock)completionBlock
                                                errorHandler:(MKNKErrorBlock) errorBlock;

//获取我的关注
- (MKNetworkOperation*)getMyFollowDataByPage:(NSInteger)page
                           CompletionHandler:(myFollowResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock;

//获取我的粉丝
- (MKNetworkOperation*)getMyFansDataByPage:(NSInteger)page
                           CompletionHandler:(myFansResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock;

// 上传个人基本信息
- (MKNetworkOperation*)uploadBasicInfoWithDict:(NSMutableDictionary*)dict
                       completionHandler:(uploadBasicInfoResponseBlock)completionBlock
                            errorHandler:(MKNKErrorBlock)errorBlock;

//上传头像
- (MKNetworkOperation*)uploadAvatarByPath:(NSString*)path
                         CompletionHandler:(uploadAvatarResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock;
//上传临时封面
- (MKNetworkOperation*)uploadCoverTmpImage:(NSString*)imagePath
                        completionHandler:(uploadCoverTmpImageResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock) errorBlock;

//上传临时图片
- (MKNetworkOperation*)uploadStepTmpImage:(NSString*)imagePath
                                withIndex:(NSInteger)index
                        completionHandler:(uploadStepTmpImageResponseBlock)completionBlock
                             errorHandler:(MKNKErrorBlock) errorBlock;

//上传临时封面
- (MKNetworkOperation*)createRecipe:(NSDictionary*)uploadDic
                  completionHandler:(createRecipeResponseBlock)completionBlock
                       errorHandler:(MKNKErrorBlock) errorBlock;

//获取其他人的个人信息
- (MKNetworkOperation*)getOtherIntroWithUserID:(NSInteger)userid
                           CompletionHandler:(getOtherIntroResponseBlock) completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock;

//关注
- (MKNetworkOperation*)watchWithUserID:(NSInteger)userid
                             CompletionHandler:(watchResponseBlock) completionBlock
                                  errorHandler:(MKNKErrorBlock) errorBlock;

//取消关注
- (MKNetworkOperation*)unwatchWithUserID:(NSInteger)userid
                             CompletionHandler:(unwatchResponseBlock) completionBlock
                                  errorHandler:(MKNKErrorBlock) errorBlock;

//获取菜谱评论
- (MKNetworkOperation*)getCommentsWithRecipeID:(NSInteger)recipeid
                       CompletionHandler:(getCommentsResponseBlock) completionBlock
                            errorHandler:(MKNKErrorBlock) errorBlock;

//评论菜谱
- (MKNetworkOperation*)commentWithDict:(NSMutableDictionary*)dict
                             completionHandler:(commentResponseBlock)completionBlock
                                  errorHandler:(MKNKErrorBlock)errorBlock;

//添加收藏
- (MKNetworkOperation*)addCollectionWithCollID:(NSInteger)collID
                     completionHandler:(addCollectionResponseBlock)completionBlock
                          errorHandler:(MKNKErrorBlock)errorBlock;

//删除收藏
- (MKNetworkOperation*)delCollectionWithCollID:(NSInteger)collID
                             completionHandler:(delCollectionResponseBlock)completionBlock
                                  errorHandler:(MKNKErrorBlock)errorBlock;

@end
