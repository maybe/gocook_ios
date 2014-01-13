//
//  ShareController.m
//  HellCook
//
//  Created by panda on 12/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "ShareController.h"
#import "UIImage+Resize.h"
#import "UIImage+Resizing.h"

@interface ShareController ()

@end

@implementation ShareController
@synthesize maskView, backView, weiboButton, weixinButton, weixinFriendButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self InitLayout];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
  [self.view addGestureRecognizer:gestureRecognizer];
  self.view.userInteractionEnabled = YES;
}

- (void)tapGestureRecognizer
{
  [self hideView];
}

- (void)InitLayout
{
  [self.view setBackgroundColor:[UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:29.0f/255.0f alpha:0.5f]];
  backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _screenWidth, 96)];
  [backView setBackgroundColor:[UIColor colorWithRed:222.0f/255.0f green:222.0f/255.0f blue:222.0f/255.0f alpha:1.0f]];
  [self.view addSubview:backView];
  
  weixinButton = [[UIButton alloc]init];
  [weixinButton setFrame:CGRectMake(40, 20, 40, 40)];
  UIImage *wxBgImage = [UIImage imageNamed:@"Images/share_weixin.png"];
  [weixinButton setBackgroundImage:wxBgImage forState:UIControlStateNormal];
  [weixinButton addTarget:self action:@selector(sendShareMessageToWeiXin) forControlEvents:UIControlEventTouchUpInside];
  wxLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 80, 20)];
  [wxLabel setTextAlignment:NSTextAlignmentCenter];
  [wxLabel setFont:[UIFont systemFontOfSize:14]];
  [wxLabel setText:@"微信好友"];
  
  weixinFriendButton = [[UIButton alloc]init];
  [weixinFriendButton setFrame:CGRectMake(140, 20, 40, 40)];
  UIImage *wxFriendBgImage = [UIImage imageNamed:@"Images/share_weixin_friends.png"];
  [weixinFriendButton setBackgroundImage:wxFriendBgImage forState:UIControlStateNormal];
  [weixinFriendButton addTarget:self action:@selector(sendShareMessageToWeiXinCircle) forControlEvents:UIControlEventTouchUpInside];
  wxfLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 60, 80, 20)];
  [wxfLabel setTextAlignment:NSTextAlignmentCenter];
  [wxfLabel setFont:[UIFont systemFontOfSize:14]];
  [wxfLabel setText:@"微信朋友圈"];
  
  weiboButton = [[UIButton alloc]init];
  [weiboButton setFrame:CGRectMake(240, 20, 40, 40)];
  UIImage *wbBgImage = [UIImage imageNamed:@"Images/share_weibo.png"];
  [weiboButton addTarget:self action:@selector(sendShareMessageToWeiBo) forControlEvents:UIControlEventTouchUpInside];
  [weiboButton setBackgroundImage:wbBgImage forState:UIControlStateNormal];
  wbLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 60, 80, 20)];
  [wbLabel setTextAlignment:NSTextAlignmentCenter];
  [wbLabel setFont:[UIFont systemFontOfSize:14]];
  [wbLabel setText:@"新浪微博"];
  
  [self.view addSubview:weixinButton];
  [self.view addSubview:weixinFriendButton];
  [self.view addSubview:weiboButton];
  
  [self.view addSubview:wxLabel];
  [self.view addSubview:wxfLabel];
  [self.view addSubview:wbLabel];
}

- (void)setShareRecipe:(NSInteger)id withTitle:(NSString *)title withMaterial:(NSString *)material withCover:(UIImage *)cover {
  recipeId = id;
  recipeTitle = [[NSString alloc] initWithString:title];
  recipeMaterial = [[NSString alloc] initWithString:material];
  if (cover) {
    recipeCover = [cover resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(100, 100) interpolationQuality:kCGInterpolationHigh];

    recipeCoverOrigin = [cover resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(500, 500) interpolationQuality:kCGInterpolationHigh];
    recipeCoverOrigin = [recipeCoverOrigin cropToSize:CGSizeMake(500, 360) usingMode:NYXCropModeCenter];
  } else {
    recipeCover = [UIImage imageNamed:@"Icon.png"];
    recipeCoverOrigin = recipeCover;
  }
}

- (void)hideView
{
  if ([self.view superview]==nil)
    return;
  
  [UIView animateWithDuration:0.3 animations:^{
    self.view.alpha = 0.0;
  } completion:^(BOOL finished) {
    [self.view removeFromSuperview];
  }];
}

- (void)showView:(UIView*)superview
{
  if ([self.view superview]!=nil)
    return;

  if (![WXApi isWXAppInstalled]) {
    weixinButton.enabled = NO;
    wxLabel.enabled = NO;

    weixinFriendButton.enabled = NO;
    wxfLabel.enabled = NO;
  } else {
    weixinButton.enabled = YES;
    wxLabel.enabled = YES;

    weixinFriendButton.enabled = YES;
    wxfLabel.enabled = YES;
  }

  if (![WeiboSDK isWeiboAppInstalled]) {
    weiboButton.enabled = NO;
    wbLabel.enabled = NO;
  } else {
    weiboButton.enabled = YES;
    wbLabel.enabled = YES;
  }

  [superview addSubview:self.view];
  [superview bringSubviewToFront:self.view];
  self.view.alpha = 0.0;
  [self.view.superview bringSubviewToFront:self.view];
  [UIView animateWithDuration:0.2 animations:^{
    self.view.alpha = 1;
  } completion:^(BOOL finished) {
    
  }];
}

- (void)sendShareMessageToWeiXin
{
  _scene = WXSceneSession;

  WXMediaMessage *message = [WXMediaMessage message];
  message.title = recipeTitle;
  message.description = recipeMaterial;
  [message setThumbImage:recipeCover];
  WXWebpageObject *ext = [WXWebpageObject object];
  ext.webpageUrl = [NSString stringWithFormat:@"http://%@/index/share?id=%d", _defaultHostName, recipeId];

  message.mediaObject = ext;

  SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
  req.bText = NO;
  req.message = message;
  req.scene = _scene;

  [WXApi sendReq:req];
}

- (void)sendShareMessageToWeiXinCircle
{
  _scene = WXSceneTimeline;

  WXMediaMessage *message = [WXMediaMessage message];
  message.title = recipeTitle;
  message.description = recipeMaterial;
  [message setThumbImage:recipeCover];
  WXWebpageObject *ext = [WXWebpageObject object];
  ext.webpageUrl = [NSString stringWithFormat:@"http://%@/index/share?id=%d", _defaultHostName, recipeId];

  message.mediaObject = ext;

  SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
  req.bText = NO;
  req.message = message;
  req.scene = _scene;

  [WXApi sendReq:req];
}

- (void)sendShareMessageToWeiBo
{
  WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self weiboMessageToShare]];
  [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)weiboMessageToShare
{
  WBMessageObject *message = [WBMessageObject message];

  message.text = [NSString stringWithFormat:@"『%@』我喜欢这个菜谱 http://%@/index/share?id=%d (分享自 @M6分享厨房 )", recipeTitle, _defaultHostName, recipeId];
  WBImageObject *image = [WBImageObject object];

  image.imageData = UIImagePNGRepresentation(recipeCoverOrigin);
  message.imageObject = image;

  return message;
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{

}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
  [self hideView];
}

-(void) onReq:(BaseReq*)req
{
}

-(void) onResp:(BaseResp*)resp
{
  [self hideView];
}

@end
