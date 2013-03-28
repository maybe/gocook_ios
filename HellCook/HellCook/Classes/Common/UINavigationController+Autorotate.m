#import "UINavigationController+Autorotate.h"

@implementation UINavigationController (MyTransition)

-(BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

//for iOS5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.viewControllers.lastObject shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
