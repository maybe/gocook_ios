#import "TopHotController.h"
#import "AccountController.h"
#import "ShoppingListController.h"
#import "AppDelegate.h"
#import "UINavigationController+Autorotate.h"
#import "RegisterController.h"

@interface TopHotController ()

@end

@implementation TopHotController
@synthesize tableView;
@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"今日热门";

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Images/NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.clipsToBounds = NO;

    
    [self setLeftButton];
    [self setRightButton];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
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
   // [self.navigationController pushViewController:[[RegisterController alloc]initWithNibName:@"RegisterView" bundle:nil] animated:YES];
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
