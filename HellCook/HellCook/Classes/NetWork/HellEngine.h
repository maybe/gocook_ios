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
typedef void (^getGoodsResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^buyGoodsResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^getHistoryDealResponseBlock)(NSMutableDictionary* resultDic);

typedef void (^uploadCoverTmpImageResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^uploadStepTmpImageResponseBlock)(NSMutableDictionary* resultDic, NSInteger index);
typedef void (^createRecipeResponseBlock)(NSMutableDictionary* resultDic);
typedef void (^modifyRecipeRespondBlock)(NSMutableDictionary* resultDic);
typedef void (^deleteRecipeRespondBlock)(NSMutableDictionary* resultDic);

typedef void (^allMyCouponsResponseBlock)(NSMutableDictionary* resultDic);

// 设置cookie
- (void) setCookie:(NSString*)cookie;
- (void) removeCookie;

// 登录
- (MKNetworkOperation*)loginWithUser:(NSString*)username AndPass:(NSString*)pass
                   completionHandler:(LoginResponseBlock) completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock;

// 注册
- (MKNetworkOperation*)registerWithTel:(NSString *)username AndNick:(NSString *)nick
                               AndPass:(NSString *)pass AndRePass:(NSString *)repass
                         AndAvatarPath:(NSString *)avatar
                     completionHandler:(RegResponseBlock)completionBlock
                          errorHandler:(MKNKErrorBlock) errorBlock;

// 获取主界面
- (MKNetworkOperation*)getIOSMainDataWithCompletionHandler:(iosMainResponseBlock) completionBlock
                                              errorHandler:(MKNKErrorBlock) errorBlock;

// 获取最新
- (MKNetworkOperation*)getTopNewDataWithPage:(NSInteger)page
                           completionHandler:(topNewResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock;

// 获取最热
- (MKNetworkOperation*)getTopHotDataWithPage:(NSInteger)page
                           completionHandler:(topHotResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock;

// 搜索
- (MKNetworkOperation*)searchWithKey:(NSString *)key AndPage:(NSInteger)page
                   completionHandler:(searchResponseBlock)completionBlock
                        errorHandler:(MKNKErrorBlock) errorBlock;

// 获取菜谱详细信息
- (MKNetworkOperation*)getRecipeDetailData:(NSInteger)recipeId
                         completionHandler:(recipeDetailDataResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock;

//获取我的收藏
- (MKNetworkOperation*)getMyCollectionDataByPage:(NSInteger)page
                               completionHandler:(myCollectionResponseBlock)completionBlock
                                    errorHandler:(MKNKErrorBlock) errorBlock;

//获取我的菜谱
- (MKNetworkOperation*)getMyRecipesDataByPage:(NSInteger)page
                            completionHandler:(myRecipesResponseBlock)completionBlock
                                 errorHandler:(MKNKErrorBlock) errorBlock;

//获取个人信息
- (MKNetworkOperation*)getMyIntroductionDataWithCompletionHandler:(myRecipesResponseBlock)completionBlock
                                                errorHandler:(MKNKErrorBlock) errorBlock;

//获取我的关注
- (MKNetworkOperation*)getMyFollowDataByPage:(NSInteger)page
                           completionHandler:(myFollowResponseBlock)completionBlock
                                errorHandler:(MKNKErrorBlock) errorBlock;

//获取我的粉丝
- (MKNetworkOperation*)getMyFansDataByPage:(NSInteger)page
                         completionHandler:(myFansResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock;

// 上传个人基本信息
- (MKNetworkOperation*)uploadBasicInfoWithDict:(NSMutableDictionary*)dict
                       completionHandler:(uploadBasicInfoResponseBlock)completionBlock
                            errorHandler:(MKNKErrorBlock)errorBlock;

//上传头像
- (MKNetworkOperation*)uploadAvatarByPath:(NSString *)path
                        completionHandler:(uploadAvatarResponseBlock)completionBlock
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

//新建菜谱
- (MKNetworkOperation*)createRecipe:(NSDictionary*)uploadDic
                  completionHandler:(createRecipeResponseBlock)completionBlock
                       errorHandler:(MKNKErrorBlock) errorBlock;

//修改菜谱
- (MKNetworkOperation*)modifyRecipe:(NSDictionary*)uploadDic
                  completionHandler:(modifyRecipeRespondBlock)completionBlock
                       errorHandler:(MKNKErrorBlock) errorBlock;

//删除菜谱
- (MKNetworkOperation*)deleteRecipe:(NSInteger)recipeId
                  completionHandler:(deleteRecipeRespondBlock)completionBlock
                       errorHandler:(MKNKErrorBlock) errorBlock;

//获取其他人的个人信息
- (MKNetworkOperation*)getOtherIntroWithUserID:(NSInteger)userid
                             completionHandler:(getOtherIntroResponseBlock)completionBlock
                                  errorHandler:(MKNKErrorBlock) errorBlock;

//关注
- (MKNetworkOperation*)watchWithUserID:(NSInteger)userid
                     completionHandler:(watchResponseBlock)completionBlock
                          errorHandler:(MKNKErrorBlock) errorBlock;

//取消关注
- (MKNetworkOperation*)unwatchWithUserID:(NSInteger)userid
                       completionHandler:(unwatchResponseBlock)completionBlock
                            errorHandler:(MKNKErrorBlock) errorBlock;

//获取菜谱评论
- (MKNetworkOperation*)getCommentsWithRecipeID:(NSInteger)recipeid
                             completionHandler:(getCommentsResponseBlock)completionBlock
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

//商品信息
- (MKNetworkOperation*)getGoodsWithKeyword:(NSString*)keyword
                                  withPage:(NSInteger)page
                             completionHandler:(getGoodsResponseBlock)completionBlock
                                  errorHandler:(MKNKErrorBlock)errorBlock;

//买商品
- (MKNetworkOperation*)buyGoodsWithDict:(NSMutableDictionary*)dict
                         completionHandler:(buyGoodsResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock)errorBlock;

//获取历史订单
- (MKNetworkOperation*)getHistoryDealWithDict:(NSMutableDictionary*)dict
                      completionHandler:(getHistoryDealResponseBlock)completionBlock
                           errorHandler:(MKNKErrorBlock)errorBlock;

//获取用户所有的优惠券
- (MKNetworkOperation*)getAllMyCouponsByPage:(NSInteger)page
                         completionHandler:(allMyCouponsResponseBlock)completionBlock
                              errorHandler:(MKNKErrorBlock) errorBlock;

@end
