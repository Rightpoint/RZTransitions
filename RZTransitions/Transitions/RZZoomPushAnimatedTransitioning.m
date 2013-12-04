//
//  RZZoomPushAnimatedTransitioning.m
//  VirginPulse
//
//  Created by Nick Donaldson on 10/22/13.
//

#import "RZZoomPushAnimatedTransitioning.h"
#import "RZHorizontalTransitionInteractor.h"

#define kVIPushTransitionTime 0.35
#define kVIPushScaleChangePct 0.33

@implementation RZZoomPushAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    if (self.isForward)
    {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
        toViewController.view.transform = CGAffineTransformMakeScale(1.0 - kVIPushScaleChangePct, 1.0 - kVIPushScaleChangePct);
        
        [UIView animateWithDuration:kVIPushTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.transform = CGAffineTransformMakeScale(1.0 + kVIPushScaleChangePct, 1.0 + kVIPushScaleChangePct);
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
        toViewController.view.transform = CGAffineTransformMakeScale(1.0 + kVIPushScaleChangePct, 1.0 + kVIPushScaleChangePct);
        toViewController.view.alpha = 0.0f;
        
        [UIView animateWithDuration:kVIPushTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toViewController.view.transform = CGAffineTransformIdentity;
                             toViewController.view.alpha = 1.0f;
                             fromViewController.view.transform = CGAffineTransformMakeScale(1.0 - kVIPushScaleChangePct, 1.0 - kVIPushScaleChangePct);
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
    return kVIPushTransitionTime;
}

@end
