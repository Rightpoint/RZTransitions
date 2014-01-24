//
//  RZCardSlideAnimatedTransitioning.m
//  RZTransitions
//
//  Created by Nick Donaldson on 11/19/13.
//

#import "RZCardSlideAnimationController.h"

#define kRZSlideTransitionTime 0.35
#define kRZSlideScaleChangePct 0.33

@implementation RZCardSlideAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

// TODO: Create a horizontal and vertical card slide animation along with a base class -SB

- (id)init
{
    self = [super init];
    if (self)
    {
        _horizontalOrientation = TRUE;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:container.bounds];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bgView.backgroundColor = [UIColor blackColor];
    [container insertSubview:bgView atIndex:0];
    
    if (self.isPositiveAnimation)
    {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
        toViewController.view.transform = CGAffineTransformMakeScale(1.0 - kRZSlideScaleChangePct, 1.0 - kRZSlideScaleChangePct);
        toViewController.view.alpha = 0.1f;
        
        [UIView animateWithDuration:kRZSlideTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toViewController.view.transform = CGAffineTransformIdentity;
                             toViewController.view.alpha = 1.0f;
                             if (self.horizontalOrientation)
                             {
                                 fromViewController.view.transform = CGAffineTransformMakeTranslation(-container.bounds.size.width, 0);
                             }
                             else
                             {
                                 fromViewController.view.transform = CGAffineTransformMakeTranslation(0, container.bounds.size.height);
                             }
                         }
                         completion:^(BOOL finished) {
                             toViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.transform = CGAffineTransformIdentity;
                             [bgView removeFromSuperview];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    else
    {
        [container addSubview:toViewController.view];
        if (self.horizontalOrientation)
        {
            toViewController.view.transform = CGAffineTransformMakeTranslation(-container.bounds.size.width, 0);
        }
        else
        {
            toViewController.view.transform = CGAffineTransformMakeTranslation(0, container.bounds.size.height);
        }

        [UIView animateWithDuration:kRZSlideTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.transform = CGAffineTransformMakeScale(1.0 - kRZSlideScaleChangePct, 1.0 - kRZSlideScaleChangePct);
                             fromViewController.view.alpha = 0.1f;
                         }
                         completion:^(BOOL finished) {
                             toViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.alpha = 1.0f;
                             [bgView removeFromSuperview];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kRZSlideTransitionTime;
}

@end
