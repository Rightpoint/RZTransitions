//
//  RZSimpleViewController.m
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/3/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZSimpleViewController.h"
#import "RZSimpleColorViewController.h"
#import "RZSimpleCollectionViewController.h"
#import "RZCardSlideAnimationController.h"
#import "RZShrinkZoomAnimationController.h"
#import "RZZoomBlurAnimationController.h"
#import "RZZoomPushAnimationController.h"
#import "RZHorizontalTransitionInteractor.h"
#import "RZVerticalTransitionInteractor.h"
#import "RZTransitionInteractorProtocol.h"
#import "RZSegmentControlMoveFadeAnimationController.h"
#import "RZCirclePushAnimationController.h"

@interface RZSimpleViewController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, RZTransitionInteractorDelegate>

@property (nonatomic, strong) id<RZTransitionInteractor> pushPopInteractionController;
@property (nonatomic, strong) id<RZTransitionInteractor> presentInteractionController;
@property (nonatomic, strong) id<RZTransitionInteractor> dismissInteractionController;
@property (nonatomic, strong) RZCardSlideAnimationController *pushPopAnimationController;
@property (nonatomic, strong) RZCirclePushAnimationController *presentAnimationController;
@property (nonatomic, strong) RZCirclePushAnimationController *dismissAnimationController;

@end

// TODO: Protocol for Animations that has actions as well.  Can setup the interactor using the animation's action
// TODO ALSO: Better yet, reuse the same one but the opposite action

@implementation RZSimpleViewController

- (void)viewDidLoad
{
    // TODO: Protocol for animators that specifies a global forward/backward for the actions
    self.pushPopInteractionController = [[RZHorizontalTransitionInteractor alloc] init];
    [self.pushPopInteractionController setDelegate:self];
    [self.pushPopInteractionController attachViewController:self withAction:RZTransitionAction_Push|RZTransitionAction_Pop];

    // TODO: Need a single interaction controller for up/down/left/right
    self.presentInteractionController = [[RZVerticalTransitionInteractor alloc] init];
    [self.presentInteractionController setDelegate:self];
    [self.presentInteractionController attachViewController:self withAction:RZTransitionAction_Present];
    
    self.dismissInteractionController = [[RZVerticalTransitionInteractor alloc] init];
    
    self.pushPopAnimationController = [[RZCardSlideAnimationController alloc] init];
    
    self.presentAnimationController = [[RZCirclePushAnimationController alloc] init];
    self.presentAnimationController.isForward = YES;
    
    self.dismissAnimationController = [[RZCirclePushAnimationController alloc] init];
    self.dismissAnimationController.isForward = NO;
    
    [self.navigationController setDelegate:self];
}

#pragma mark - Button Actions

- (IBAction)pushNewViewController:(id)sender
{
    [[self navigationController] pushViewController:[self nextSimpleViewController] animated:YES];
}

- (IBAction)popViewController:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)showModal:(id)sender
{
    [[self navigationController] presentViewController:[self nextSimpleColorViewController] animated:YES completion:nil];
}

- (IBAction)showCollectionView:(id)sender
{
    [[self navigationController] pushViewController:[[RZSimpleCollectionViewController alloc] init] animated:YES];
}

#pragma mark - Next View Controller Logic

- (UIViewController *)nextSimpleViewController
{
    RZSimpleViewController* newVC = [[RZSimpleViewController alloc] init];
    [newVC setTransitioningDelegate:self];
    return newVC;
}

- (UIViewController *)nextSimpleColorViewController
{
    RZSimpleColorViewController* newColorVC = [[RZSimpleColorViewController alloc] init];
    [newColorVC setTransitioningDelegate:self];
    [self.dismissInteractionController attachViewController:newColorVC withAction:RZTransitionAction_Dismiss];
    return newColorVC;
}

#pragma mark - Custom View Controller Animations - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentAnimationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimationController;
}

 - (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return (self.presentInteractionController && [self.presentInteractionController isInteractive]) ? self.presentInteractionController : nil;
}

 - (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return (self.dismissInteractionController && [self.dismissInteractionController isInteractive]) ? self.dismissInteractionController : nil;
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return (self.pushPopInteractionController && [self.pushPopInteractionController isInteractive]) ? self.pushPopInteractionController : nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        self.pushPopAnimationController.isForward = YES;
    } else if (operation == UINavigationControllerOperationPop) {
        self.pushPopAnimationController.isForward = NO;
    }
    return self.pushPopAnimationController;
}


#pragma mark - RZTransitionInteractorDelegate

- (UIViewController *)nextViewControllerForInteractor:(id<RZTransitionInteractor>)interactor
{
    // TODO: Check if it is a vertical or a horizontal and return the appropriate VC for the interactor
    if ([interactor isKindOfClass:[RZVerticalTransitionInteractor class]]) {
        return [self nextSimpleColorViewController];
    } else {
        return [self nextSimpleViewController];
    }
}


@end
