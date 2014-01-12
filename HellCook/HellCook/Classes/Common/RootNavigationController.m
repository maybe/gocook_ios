#import "RootNavigationController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  [super navigationController:navigationController willShowViewController:viewController animated:animated];

  if (self.viewControllers.count == 1)
    {
        [navigationController setNavigationBarHidden:YES animated:animated];
    }
}

@end
