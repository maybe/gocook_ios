#import "TopHotController.h"
#import "AccountController.h"
#import "ShoppingListController.h"
#import "CustomNavigationBar.h"
#import "CustomNavigationController.h"

@interface TopHotController ()
{
    AccountController *m_AccountController;
    ShoppingListController* m_SlController;
}
@end

@implementation TopHotController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"今日热门";
    
    [self setLeftButton];
    [self setRightButton];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    m_AccountController = [[AccountController alloc] initWithNibName:@"AccountView" bundle:nil];
    m_SlController = [[ShoppingListController alloc] initWithNibName:@"ShoppingListView" bundle:nil];
    
}

- (void) showLeft:(id)sender
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft withOffset:_offset animated:YES];
}

- (void) showRight:(id)sender
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionRight withOffset:_offset animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CustomNavigationController *nl = [[CustomNavigationController alloc] initWithRootViewController:m_AccountController];    
    [self.revealSideViewController preloadViewController:nl forSide:PPRevealSideDirectionLeft withOffset:_offset];

    
    CustomNavigationController* nr = [[CustomNavigationController alloc]initWithRootViewController:m_SlController];
    [self.revealSideViewController preloadViewController:nr forSide:PPRevealSideDirectionRight withOffset:_offset];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Main %d", indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    LeftViewController *left = [[LeftViewController alloc] initWithStyle:UITableViewStylePlain];
//
//    // We don't want to be able to pan on nav bar to see the left side when we pushed a controller
//    [self.revealSideViewController unloadViewControllerForSide:PPRevealSideDirectionLeft];
//    
//    [self.navigationController pushViewController:left animated:YES];
//    
//    HC_RELEASE(left);
}

- (void)setLeftButton
{
    UIButton *leftBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    [leftBarButtonView addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/leftPageButtonBackgroundNormal.png"]
                                 forState:UIControlStateNormal];
    
    [leftBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/leftPageButtonBackgroundHighlighted.png"]
                                 forState:UIControlStateHighlighted];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonView];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}


-(void)setRightButton
{
    UIButton *rightBarButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
    [rightBarButtonView addTarget:self action:@selector(showRight:) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/rightPageButtonBackgroundNormal.png"]
                                  forState:UIControlStateNormal];
    
    [rightBarButtonView setBackgroundImage:
     [UIImage imageNamed:@"Images/rightPageButtonBackgroundHighlighted.png"]
                                  forState:UIControlStateHighlighted];
    
    UILabel* rightNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 3, 27, 22)];
    [rightNumLabel setBackgroundColor:[UIColor clearColor]];
    [rightNumLabel setTextColor:[UIColor whiteColor]];
    [rightNumLabel setAdjustsFontSizeToFitWidth:YES];
    [rightNumLabel setTextAlignment:NSTextAlignmentCenter];
    [rightNumLabel setText:@"1"];
    [rightBarButtonView addSubview:rightNumLabel];
    
    UIImage* rightBLImage = [UIImage imageNamed:@"Images/buylistButtonImage.png"];
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 22, 19)];
    [rightImageView setImage:rightBLImage];
    [rightBarButtonView addSubview:rightImageView];
    
    [rightBarButtonView bringSubviewToFront:rightNumLabel];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonView];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

@end
