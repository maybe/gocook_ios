//
//  ShareController.m
//  HellCook
//
//  Created by panda on 12/29/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "ShareController.h"

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
  WXMediaMessage *message = [WXMediaMessage message];
  message.title = @"M6分享厨房";
  message.description = @"试试看嘛";
  [message setThumbImage:[UIImage imageNamed:@"Icon.png"]];
  WXWebpageObject *ext = [WXWebpageObject object];
  ext.webpageUrl = @"http://o2o.m6fresh.com:8081/index/share?id=2";

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
  request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
      @"Other_Info_1": [NSNumber numberWithInt:123],
      @"Other_Info_2": @[@"obj1", @"obj2"],
      @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
  //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;

  [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)weiboMessageToShare
{
  WBMessageObject *message = [WBMessageObject message];

  message.text = @"测试通过WeiboSDK发送文字到微博!http://o2o.m6fresh.com:8081/index/share?id=2";
  WBImageObject *image = [WBImageObject object];
  image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"]];
  message.imageObject = image;

//  WBWebpageObject *webpage = [WBWebpageObject object];
//  webpage.objectID = @"id2";
//  webpage.title = @"分享厨房";
//  webpage.description = [NSString stringWithFormat:@"分享网页内容简介"];
//  webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"]];
//  webpage.webpageUrl = @"http://o2o.m6fresh.com:8081/index/share?id=2";
//  message.mediaObject = webpage;

  return message;
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{

}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{

}

-(void) onReq:(BaseReq*)req
{

}

-(void) onResp:(BaseResp*)resp
{

}

@end
