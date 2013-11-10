//
//  LoginController.m
//  HellCook
//
//  Created by panda on 3/28/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "LoginController.h"
#import "RegexKitLite.h"
#import "NetManager.h"

@interface LoginController ()

@end

@implementation LoginController
@synthesize webView;
@synthesize callerClassName;
@synthesize rndValue;

- (void)viewDidLoad
{
  CGRect viewFrame = self.view.frame;
  viewFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.view setFrame:viewFrame];

  CGRect webFrame = self.webView.frame;
  webFrame.size.height = _screenHeight_NoStBar_NoNavBar;
  [self.webView setFrame:webFrame];
  [self.webView setDelegate:self];
  [self.webView setBackgroundColor:[UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1]];

  self.title = @"登录";
  
  [self setLeftButton];
  
  HUD = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:HUD];
  HUD.mode = MBProgressHUDModeText;
  HUD.delegate = self;

  [self autoLayout];
  [super viewDidLoad];

  srand((unsigned)time(0));
  rndValue = rand() % 100;

  NSURL* url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"http://o.m6fresh.com/ws/mobile_reg.aspx?sid=%d", rndValue]];
  [webView loadRequest:[NSURLRequest requestWithURL: url]];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  if (self.loginOperation) {
    [self.loginOperation cancel];
  }
}

- (BOOL)shouldAutorotate {
  
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
  
  return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Text Return

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  
  return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)sender
{
  
}

#pragma mark - Nav Button

- (void)setLeftButton
{
  UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 29)];
  [leftBarButtonView addTarget:self action:@selector(returnToPrev) forControlEvents:UIControlEventTouchUpInside];
  [leftBarButtonView setBackgroundImage:
      [UIImage imageNamed:@"Images/BackButtonNormal.png"]
                               forState:UIControlStateNormal];
  [leftBarButtonView setBackgroundImage:
      [UIImage imageNamed:@"Images/BackButtonHighLight.png"]
                               forState:UIControlStateHighlighted];
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
  [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

-(void)returnToPrev
{
  [self.navigationController popViewControllerAnimated:YES];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


#pragma mark –
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
}
- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
  NSString *currentURL = [aWebView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
  if ([currentURL isEqualToString:@"http://o.m6fresh.com/ws/appcallback.aspx"]) {
    NSString *content = [aWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSString* inputString = [content stringByMatching:@"<input name=\"tb_data\" type=\"hidden\" id=\"tb_data\" value=\"(.+?)\">"];
    if (inputString) {
      NSString* loginData = [content stringByMatching:@"<input name=\"tb_data\" type=\"hidden\" id=\"tb_data\" value=\"(.+?)\">" capture:1L];
      // send to our server
      [self onLogin:loginData];
    }
  }

}
- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
}

#pragma mark - Net

-(void)onLogin:(NSString*)data
{
  HUD.labelText = @"登录中...";
  [HUD show:YES];

  NSString *rndString = [NSString stringWithFormat:@"%d", rndValue];
  self.loginOperation = [[[NetManager sharedInstance] hellEngine]
                         authWithData:data AndRnd:rndString
                         completionHandler:^(NSMutableDictionary *resultDic) {
                            [self LoginCallBack:resultDic];}
                          errorHandler:^(NSError *error) {}
                         ];
}

- (void)LoginCallBack:(NSMutableDictionary*) resultDic
{
  NSInteger result = [[resultDic valueForKey:@"result"] intValue];
  if (result == 0) {
    [HUD hide:NO];
    [self.navigationController popViewControllerAnimated:YES];
    // 广播登陆成功的消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EVT_OnLoginSuccess" object:callerClassName];
  }
  else
  {
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"登录失败";
        
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
  }
}

@end
