//
//  TopHotController.h
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "AccountController.h"
#import "QuartzCore/QuartzCore.h"


@interface AccountController ()

@end

@implementation AccountController
@synthesize tableView;
@synthesize bannerImageView;


- (void)viewDidLoad
{
    UIImageView* titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Images/leftPageTitle.png" ]];
    self.title = @"111";
    [titleImageView setFrame:CGRectMake(0, 0, 59, 27)];
    self.navigationController.navigationItem.titleView = titleImageView;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar.superview setAutoresizesSubviews:NO];
    [self.navigationController.navigationBar setTranslucent:YES];

    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar.superview setCenter:CGPointMake(_sideWindowWidth/2, _navigationBarHeight/2)];
    [self.navigationController.navigationBar.superview setBounds:CGRectMake(0, 0, _sideWindowWidth, _navigationBarHeight)];

    [self.navigationController.navigationBar setCenter:CGPointMake(_sideWindowWidth/2, _navigationBarHeight/2)];
    [self.navigationController.navigationBar setBounds:CGRectMake(0, 0, _sideWindowWidth, _navigationBarHeight)];
    
    [super viewWillAppear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Main %d", indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
