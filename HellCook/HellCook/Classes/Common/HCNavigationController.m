#import "HCNavigationController.h"
#import "UIViewController+MMDrawerController.h"
#import "RecipeDetailController.h"

@interface HCNavigationController ()

@end

@implementation HCNavigationController

-(UIStatusBarStyle)preferredStatusBarStyle{
    if(self.mm_drawerController.showsStatusBarBackgroundView){
        return UIStatusBarStyleLightContent;
    }
    else {
        return UIStatusBarStyleDefault;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[RecipeDetailController class]])
    {
        [navigationController setNavigationBarHidden:YES animated:animated];
    }
    else
    {
        [navigationController setNavigationBarHidden:NO animated:animated];
    }
}

@end
