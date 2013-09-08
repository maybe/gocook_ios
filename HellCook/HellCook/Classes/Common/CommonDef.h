//
//  CommonDef.h
//  HellCook
//
//  Created by panda on 9/8/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  E_IsMyWatch = 0,                      // 是我的关注
  E_NotMyWatch = 1                      // 不是我的关注
} GCWatchStatus;

typedef enum {
  E_IsCollected = 0,                    // 已经收藏
  E_NotCollected = 1                    // 未收藏
} GCCollectStatus;

typedef enum {
  GC_Success = 0,                       // 成功
  GC_Failed = 1,                        // 失败
} GCResult;

typedef enum {
  GC_NoErrorCode = 0,                   // 无错误码
  GC_CommonError = 100,                 // 一般错误(正常情况是不应该出现的错误)

  GC_NoMobileDevice = 101,              // 非移动设备
  GC_AuthAccountInvalid = 102,          // 未授权用户
  GC_NoPost = 103,                      // 不是post上传
  GC_PostInvalid = 104,                 // 上传post不合法
  GC_KeywordNull = 105,                 // 查询的keyword为空
  GC_GetParamInvalid = 106,             // get参数不正确

  GC_TelExist = 201,                    // 电话号码重复
  GC_NickNameExist = 202,               // 昵称重复
  GC_M6ServerConnError = 203,           // 甲方服务器错误(连接错误)
  GC_M6ServerError = 204,               // 甲方服务器错误(逻辑错误，go_cook校验服务器返回结果错误)
  GC_RegError = 205,                    // 注册失败
  GC_AccountExist = 206,                // 206: 账号已存在
  GC_AccountNotExist = 207,             // 账号不存在
  GC_PasswordInvalid = 208,             // 密码错误
  GC_ChangeAvatarError = 209,           // 修改头像失败（保存时出错）
  GC_AvatarSizeTooSmall = 210,          // 头像文件小于1k
  GC_NoPostAvatarFile = 211,            // 上传的post中不包含avatar

  GC_ProductInvalid = 301,              // 商品不存在或无效错误
  GC_OrderAccountInvalid = 302,         // 订购失败,客户不存在或无效
  GC_OrderInvalid = 303,                // 订购失败,订单已经存在且订单状态错误

  GC_RecipeNotExist = 401,              // 不存在该菜谱
  GC_RecipeNotBelong2U = 402,           // 此菜谱不属于当前用户
  GC_AddRecipeCollectionError = 403,    // 加入收藏失败
  GC_AlreadyCollectRecipe = 404,        // 已经收藏该菜谱
  GC_NotMyCollectRecipe = 405,          // 该菜谱本人未收藏
  GC_CommentOnRecipeFailed = 406,       // 评论失败

  GC_AlreadyWatchUser = 501,            // 已经关注过此用户
  GC_NotMyWatchUser = 502,              // 并未关注此用户
} GCErrorCode;