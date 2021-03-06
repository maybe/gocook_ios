//
//  ShareController.h
//  HellCook
//
//  Created by panda on 12/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface ShareController : UIViewController<WXApiDelegate,WeiboSDKDelegate>
{
  UIView* backView;
  UIView* maskView;
  
  UIButton* weixinButton;
  UIButton* weixinFriendButton;
  UIButton* weiboButton;
  UILabel* wxLabel;
  UILabel* wxfLabel;
  UILabel* wbLabel;

  enum WXScene _scene;

  NSInteger recipeId;
  NSString* recipeTitle;
  NSString* recipeMaterial;
  UIImage* recipeCover;
  UIImage* recipeCoverOrigin;
}

@property (nonatomic,retain) UIView* backView;
@property (nonatomic,retain) UIView* maskView;
@property (nonatomic,retain) UIButton* weixinButton;
@property (nonatomic,retain) UIButton* weixinFriendButton;
@property (nonatomic,retain) UIButton* weiboButton;

- (void)InitLayout;
- (void)setShareRecipe:(NSInteger)id withTitle:(NSString *)title withMaterial:(NSString *)material withCover:(UIImage *)cover;
- (void)showView:(UIView*)superview;
- (void)hideView;

@end
