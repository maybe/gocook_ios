//
//  RegisterController.m
//  HellCook
//
//  Created by panda on 3/27/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController ()

@end

@implementation RegisterController
@synthesize navgationItem;
@synthesize button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftButton];
    
    [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setLeftButton
{
    UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    [leftBarButtonView addTarget:self action:@selector(returnTo) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/commonBackBackgroundNormal.png"]
                                 forState:UIControlStateNormal];
    
    [leftBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/commonBackBackgroundHighlighted.png"]
                                 forState:UIControlStateHighlighted];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
    [leftBarButtonView setTitle:@"返回" forState:UIControlStateNormal];
    
    [self.navgationItem setLeftBarButtonItem:leftBarButtonItem];

}

- (BOOL)shouldAutorotate {
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

-(void)returnTo
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
