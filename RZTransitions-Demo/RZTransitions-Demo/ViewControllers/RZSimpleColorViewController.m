//
//  RZSimpleColorViewController.m
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/3/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZSimpleColorViewController.h"
#import "RZCardSlideAnimatedTransitioning.h"
#import "RZShrinkTransitioner.h"
#import "RZZoomBlurAnimatedTransitioning.h"
#import "RZZoomPushAnimatedTransitioning.h"
#import "RZHorizontalTransitionInteractor.h"
#import "RZSegmentControlMoveFadeAnimatedTransitioning.h"
#import "RZTransitionInteractorProtocol.h"

@interface RZSimpleColorViewController () //<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) id<RZTransitionInteractor> dismissInteractionController;
@property (nonatomic, strong) RZSegmentControlMoveFadeAnimatedTransitioning *dismissAnimationController;

@end

@implementation RZSimpleColorViewController

+ (UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[RZSimpleColorViewController randomColor]];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelfOnTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
//    self.dismissInteractionController = [[RZHorizontalTransitionInteractor alloc] init];
//    [self.dismissInteractionController attachViewController:self withAction:RZTransitionAction_Dismiss];
//    
//    self.dismissAnimationController = [[RZSegmentControlMoveFadeAnimatedTransitioning alloc] init];
//    self.dismissAnimationController.isLeft = YES;
}

#pragma mark - Handle Tap Genture Reconizer

- (void)dismissSelfOnTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom View Controller Animations

//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    RZZoomBlurAnimatedTransitioning* transition = [[RZZoomBlurAnimatedTransitioning alloc] init];
//    return transition;
//}

//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    return self.dismissAnimationController;
//}
//
//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
//{
//    return self.dismissInteractionController;
////    return nil;
//}

@end
