//
//  RZTransitionsNavigationController.m
//
//  Created by Stephen Barnes on 3/7/14.
//

#import "RZTransitionsNavigationController.h"
#import "RZTransitionsManager.h"

@interface RZTransitionsNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation RZTransitionsNavigationController

- (void)viewDidLoad
{
    __weak RZTransitionsNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self.interactivePopGestureRecognizer setEnabled:YES];
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = [RZTransitionsManager shared];
    }
}

// Hijack the push method to disable the gesture
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    [super pushViewController:viewController animated:animated];
//}

#pragma mark - UINavigationControllerDelegate

// TODO: reenable the back gesture from the transitions manager

//- (void)navigationController:(UINavigationController *)navigationController
//       didShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animate
//{
//    // Enable the gesture again once the new controller is shown
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = YES;
//    }
//}

@end
