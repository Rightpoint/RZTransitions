//
//  RZZoomPushAnimatedTransitioning.m
//  RZTransitions
//
//  Created by Nick Donaldson on 10/22/13.
//

#import "RZZoomPushAnimationController.h"
#import "RZHorizontalInteractionController.h"

#define kRZPushTransitionTime 0.35
#define kRZPushScaleChangePct 0.33

@implementation RZZoomPushAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    if (self.isForward)
    {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
        toViewController.view.transform = CGAffineTransformMakeScale(1.0 - kRZPushScaleChangePct, 1.0 - kRZPushScaleChangePct);
        
        [UIView animateWithDuration:kRZPushTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.transform = CGAffineTransformMakeScale(1.0 + kRZPushScaleChangePct, 1.0 + kRZPushScaleChangePct);
                             fromViewController.view.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             toViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.alpha = 1.0f;
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    else
    {
        [container addSubview:toViewController.view];
        toViewController.view.transform = CGAffineTransformMakeScale(1.0 + kRZPushScaleChangePct, 1.0 + kRZPushScaleChangePct);
        toViewController.view.alpha = 0.0f;
        
        [UIView animateWithDuration:kRZPushTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toViewController.view.transform = CGAffineTransformIdentity;
                             toViewController.view.alpha = 1.0f;
                             fromViewController.view.transform = CGAffineTransformMakeScale(1.0 - kRZPushScaleChangePct, 1.0 - kRZPushScaleChangePct);
                         }
                         completion:^(BOOL finished) {
                             toViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.transform = CGAffineTransformIdentity;
                             toViewController.view.alpha = 1.0f;
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kRZPushTransitionTime;
}

@end
