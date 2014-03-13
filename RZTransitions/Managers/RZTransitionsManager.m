//
//  RZTransitionsManager.m
//
//  Created by Stephen Barnes on 3/12/14.
//

#import "RZTransitionsManager.h"
#import "RZAnimationControllerProtocol.h"
#import "RZUniqueTransition.h"

@interface RZTransitionsManager ()

@property (strong, nonatomic) NSMutableDictionary *pushPopTransitions;
@property (strong, nonatomic) NSMutableDictionary *presentDismissTransitions;
@property (strong, nonatomic) NSMutableDictionary *tabBarTransitions;

@end

@implementation RZTransitionsManager

+ (RZTransitionsManager *)shared
{
    static RZTransitionsManager *_defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[[self class] alloc] init];
    });
    
    return _defaultManager;
}

+ (NSString *)keyToAnyViewControllerFromViewController:(UIViewController *)fromViewController
{
    return [RZTransitionsManager keyToAnyViewControllerFromViewControllerClass:[fromViewController class]];
}

+ (NSString *)keyToAnyViewControllerFromViewControllerClass:(Class)fromViewController
{
    NSMutableString *key = [NSStringFromClass(fromViewController) mutableCopy];
    [key appendString:@"_AnyViewController"];
    return key;
}

+ (NSString *)keyFromAnyViewController:(UIViewController *)fromViewController
{
    return [RZTransitionsManager keyFromAnyViewControllerClass:[fromViewController class]];
}

+ (NSString *)keyFromAnyViewControllerClass:(Class)fromViewController
{
    NSMutableString *key = [@"AnyViewController_" mutableCopy];
    [key appendString:[NSStringFromClass(fromViewController) mutableCopy]];
    return key;
}

+ (NSString *)keyFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    return [RZTransitionsManager keyFromViewControllerClass:[fromViewController class] toViewControllerClass:[toViewController class]];
}

+ (NSString *)keyFromViewControllerClass:(Class)fromViewController toViewControllerClass:(Class)toViewController
{
    NSMutableString *key = [NSStringFromClass(fromViewController) mutableCopy];
    [key appendString:@"_"];
    [key appendString:[NSStringFromClass(toViewController) mutableCopy]];
    return key;
}

+ (NSString *)keyForDismissedViewController:(UIViewController *)dismissedViewController
{
    NSMutableString *key = [NSStringFromClass([dismissedViewController class]) mutableCopy];
    [key appendString:@"_Dismissed"];
    return key;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.pushPopTransitions = [[NSMutableDictionary alloc] init];
        self.presentDismissTransitions = [[NSMutableDictionary alloc] init];
        self.tabBarTransitions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setAnimationController:(id<RZAnimationControllerProtocol>)animationController
            fromViewController:(Class)fromViewController
                     forAction:(RZTransitionAction)action
{
    // TODO: Push vs Present vs Tab
    if (action & RZTransitionAction_Push || action & RZTransitionAction_Pop) {
        [self.pushPopTransitions setObject:animationController forKey:[RZTransitionsManager keyToAnyViewControllerFromViewControllerClass:fromViewController]];
    }
    else if (action & RZTransitionAction_Present || action & RZTransitionAction_Dismiss) {
        [self.presentDismissTransitions setObject:animationController forKey:[RZTransitionsManager keyToAnyViewControllerFromViewControllerClass:fromViewController]];
    }
}

- (void)setAnimationController:(id<RZAnimationControllerProtocol>)animationController
            fromViewController:(Class)fromViewController
              toViewController:(Class)toViewController
                     forAction:(RZTransitionAction)action
{
    // TODO: breaking out push vs pop vs tab and reversing
    if (action & RZTransitionAction_Push || action & RZTransitionAction_Pop) {
        [self.pushPopTransitions setObject:animationController forKey:[RZTransitionsManager keyFromViewControllerClass:fromViewController toViewControllerClass:toViewController]];
        [self.pushPopTransitions setObject:animationController forKey:[RZTransitionsManager keyFromViewControllerClass:toViewController toViewControllerClass:fromViewController]];
    }
    else if (action & RZTransitionAction_Present || action & RZTransitionAction_Dismiss) {
        [self.presentDismissTransitions setObject:animationController forKey:[RZTransitionsManager keyFromViewControllerClass:fromViewController toViewControllerClass:toViewController]];
        [self.presentDismissTransitions setObject:animationController forKey:[RZTransitionsManager keyFromViewControllerClass:toViewController toViewControllerClass:fromViewController]];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    id<RZAnimationControllerProtocol> animationController = (id<RZAnimationControllerProtocol>)[self.presentDismissTransitions objectForKey:[RZTransitionsManager keyFromViewController:presenting toViewController:presented]];
    if (animationController == nil) {
        animationController = (id<RZAnimationControllerProtocol>)[self.presentDismissTransitions objectForKey:[RZTransitionsManager keyToAnyViewControllerFromViewController:source]];
    }
    if (animationController == nil) {
        animationController = self.defaultPresentDismissAnimationController;
    }
    
    if (animationController) {
        animationController.isPositiveAnimation = YES;
    }

    return animationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id<RZAnimationControllerProtocol> animationController = (id<RZAnimationControllerProtocol>)[self.presentDismissTransitions objectForKey:[RZTransitionsManager keyForDismissedViewController:dismissed]];
    if (animationController == nil) {
        UIViewController *presentingViewController = dismissed.presentingViewController;
        if ([presentingViewController isKindOfClass:[UINavigationController class]]) {
            UIViewController *childVC = (UIViewController *)[[presentingViewController childViewControllers] lastObject];
            if (childVC != nil) {
                animationController = (id<RZAnimationControllerProtocol>)[self.presentDismissTransitions objectForKey:[RZTransitionsManager keyFromViewController:dismissed toViewController:childVC]];
                if (animationController == nil) {
                    animationController = (id<RZAnimationControllerProtocol>)[self.presentDismissTransitions objectForKey:[RZTransitionsManager keyToAnyViewControllerFromViewController:childVC]];
                }
            }
        }
    }
    if (animationController == nil) {
        animationController = self.defaultPresentDismissAnimationController;
    }
    
    if (animationController != nil) {
        animationController.isPositiveAnimation = NO;
    }
    
    return animationController;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

#pragma mark - UINavigationControllerDelegate

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    // NSArray of interaction controllers
    // watch for shouldshow, didshow, etc for VCs
    // after showing a new vc, clean the current interactors
    
    // problem: have to re-setup the interactors from the vc on the viewdidappear?
    
    
//    return (self.pushPopInteractionController && [self.pushPopInteractionController isInteractive]) ? self.pushPopInteractionController : nil;
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
	id<RZAnimationControllerProtocol> animationController = (id<RZAnimationControllerProtocol>)[self.pushPopTransitions objectForKey:[RZTransitionsManager keyFromViewController:fromVC toViewController:toVC]];
    if (animationController == nil) {
        animationController = (id<RZAnimationControllerProtocol>)[self.pushPopTransitions objectForKey:[RZTransitionsManager keyToAnyViewControllerFromViewController:fromVC]];
    }
    if (animationController == nil) {
        animationController = self.defaultPushPopAnimationController;
    }
		
    if (operation == UINavigationControllerOperationPush) {
        animationController.isPositiveAnimation = YES;
    } else if (operation == UINavigationControllerOperationPop)	{
        animationController.isPositiveAnimation = NO;
    }
    
    return animationController;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    // keymapping: interaction controller for UIViewController with action
    // problem: can have multiple interaction controllers for a uiviewcontroller
    
    // keymap: array of interaction controllers for a UIViewController with action?
}

- (id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                      interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController
{
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC
{
    id<RZAnimationControllerProtocol> animationController = (id<RZAnimationControllerProtocol>)[self.tabBarTransitions objectForKey:[RZTransitionsManager keyFromViewController:fromVC toViewController:toVC]];
    if (animationController == nil) {
        animationController = (id<RZAnimationControllerProtocol>)[self.tabBarTransitions objectForKey:[RZTransitionsManager keyToAnyViewControllerFromViewController:fromVC]];
    }
    if (animationController == nil) {
        animationController = self.defaultTabBarAnimationController;
    }
    
    NSUInteger fromVCIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSUInteger toVCIndex = [tabBarController.viewControllers indexOfObject:toVC];
    
    if (animationController)
    {
        animationController.isPositiveAnimation = (fromVCIndex > toVCIndex);
    }

    return animationController;
}

@end
