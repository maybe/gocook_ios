//
//  TopHotController.h
//  HellCook
//
//  Created by panda on 2/22/13.
//  Copyright (c) 2013 panda. All rights reserved.
//

#import "ShoppingListController.h"

@interface ShoppingListController ()

@end

@implementation ShoppingListController
@synthesize tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRightButton];

    UIImageView* titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Images/leftPageTitle.png" ]];
    [titleImageView setFrame:CGRectMake(0, 0, 59, 27)];
    self.navigationController.navigationItem.titleView = titleImageView;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];            

    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.title = @"购买清单";
    

}

- (void) emptyShoppingList:(id)sender
{
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBounds:CGRectMake(-20, 0, _sideWindowWidth, _navigationBarHeight)];
    [self.navigationController.navigationBar setFrame:CGRectMake(-20, 0, _sideWindowWidth, _navigationBarHeight)];
    [self.navigationController.navigationBar setCenter:CGPointMake(20+_sideWindowWidth/2, _navigationBarHeight/2)];
     
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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


- (void)setRightButton
{
    UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    [rightBarButtonView addTarget:self action:@selector(emptyShoppingList:) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/rightPageButtonBackgroundNormal.png"]
                                  forState:UIControlStateNormal];
    
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/rightPageButtonBackgroundHighlighted.png"]
                                  forState:UIControlStateHighlighted];
    
    UIImage* rightBLImage = [UIImage imageNamed:@"Images/buylistPageclear.png"];
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 15, 18)];
    [rightImageView setImage:rightBLImage];
    [rightBarButtonView addSubview:rightImageView];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

@end
