//
//  RZZoomAlphaAnimationController.m
//
//  Created by Stephen Barnes on 2/12/14.
//

#import "RZZoomAlphaAnimationController.h"

#define kRZZoomAlphaTransitionTime 0.3
#define kRZZoomAlphaMaxScale       1.333

@implementation RZZoomAlphaAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

#pragma mark - Animated transitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    toViewController.view.userInteractionEnabled = YES;
    
    if (!self.isPositiveAnimation)
    {
        fromViewController.view.opaque = NO;
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        [UIView animateWithDuration:kRZZoomAlphaTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             fromViewController.view.alpha = 0.f;
                             fromViewController.view.transform =  CGAffineTransformMakeScale(kRZZoomAlphaMaxScale, kRZZoomAlphaMaxScale);
                         }
                         completion:^(BOOL finished) {
                             fromViewController.view.alpha = 1.f;
                             fromViewController.view.transform = CGAffineTransformIdentity;
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    else
    {
        toViewController.view.opaque = NO;
        toViewController.view.alpha = 0.f;
        toViewController.view.transform = CGAffineTransformMakeScale(kRZZoomAlphaMaxScale, kRZZoomAlphaMaxScale);
        [container addSubview:toViewController.view];
        
        [UIView animateWithDuration:kRZZoomAlphaTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             toViewController.view.alpha = 1.f;
                             toViewController.view.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             toViewController.view.opaque = YES;
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kRZZoomAlphaTransitionTime;
}

@end
