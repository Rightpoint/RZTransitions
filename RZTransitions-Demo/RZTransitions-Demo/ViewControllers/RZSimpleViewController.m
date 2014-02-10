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
#import "RZHorizontalInteractionController.h"
#import "RZVerticalTransitionInteractionController.h"
#import "RZTransitionInteractionControllerProtocol.h"
#import "RZSegmentControlMoveFadeAnimationController.h"
#import "RZCirclePushAnimationController.h"

@interface RZSimpleViewController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, RZTransitionInteractionControllerDelegate>

@property (nonatomic, strong) id<RZTransitionInteractionController> pushPopInteractionController;
@property (nonatomic, strong) id<RZTransitionInteractionController> presentInteractionController;
@property (nonatomic, strong) id<RZTransitionInteractionController> dismissInteractionController;
@property (nonatomic, strong) RZZoomPushAnimationController   *specialPushPopAnimationController;
@property (nonatomic, strong) RZCardSlideAnimationController  *pushPopAnimationController;
@property (nonatomic, strong) RZCirclePushAnimationController *presentAnimationController;
@property (nonatomic, strong) RZCirclePushAnimationController *dismissAnimationController;

@end

@implementation RZSimpleViewController

- (void)viewDidLoad
{
	// Create the push and pop interaction controller that allows a custom gesture
	// to control pushing and popping from the navigation controller
    self.pushPopInteractionController = [[RZHorizontalInteractionController alloc] init];
    [self.pushPopInteractionController setDelegate:self];
    [self.pushPopInteractionController attachViewController:self withAction:RZTransitionAction_Push|RZTransitionAction_Pop];

	// Create the presentation interaction controller that allows a custom gesture
	// to control presenting a new VC via a presentViewController
    self.presentInteractionController = [[RZVerticalTransitionInteractionController alloc] init];
    [self.presentInteractionController setDelegate:self];
    [self.presentInteractionController attachViewController:self withAction:RZTransitionAction_Present];
    
	// Create a dismiss interaction controller that will be attached to the presented
	// view controller to allow for a custom dismissal
    self.dismissInteractionController = [[RZVerticalTransitionInteractionController alloc] init];
    
	// Setup the push & pop animations as well as a special animation for pushing a
	// RZSimpleCollectionViewController
    self.pushPopAnimationController = [[RZCardSlideAnimationController alloc] init];
	self.specialPushPopAnimationController = [[RZZoomPushAnimationController alloc] init];
    
	// Setup the animations for presenting and dismissing a new VC
    self.presentAnimationController = [[RZCirclePushAnimationController alloc] init];
    self.presentAnimationController.isPositiveAnimation = YES;
    self.dismissAnimationController = [[RZCirclePushAnimationController alloc] init];
    self.dismissAnimationController.isPositiveAnimation = NO;
    
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
	id<RZAnimationControllerProtocol> animationController = nil;
	
	if (([fromVC isKindOfClass:[RZSimpleViewController class]] && [toVC isKindOfClass:[RZSimpleCollectionViewController class]] ) ||
		([fromVC isKindOfClass:[RZSimpleCollectionViewController class]] && [toVC isKindOfClass:[RZSimpleViewController class]] ) )
	{
		animationController = self.specialPushPopAnimationController;
	}
	else
	{
		animationController = self.pushPopAnimationController;
	}
	
    if (operation == UINavigationControllerOperationPush)
	{
        animationController.isPositiveAnimation = YES;
    }
	else if (operation == UINavigationControllerOperationPop)
	{
        animationController.isPositiveAnimation = NO;
    }
    return animationController;
}


#pragma mark - RZTransitionInteractorDelegate

- (UIViewController *)nextViewControllerForInteractor:(id<RZTransitionInteractionController>)interactor
{
    // TODO: Check if it is a vertical or a horizontal and return the appropriate VC for the interactor
    if ([interactor isKindOfClass:[RZVerticalTransitionInteractionController class]])
	{
        return [self nextSimpleColorViewController];
    }
	else
	{
        return [self nextSimpleViewController];
    }
}


@end
