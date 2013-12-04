//
//  RZCardSlideAnimatedTransitioning.m
//
//  Created by Nick Donaldson on 11/19/13.
//

#import "RZCardSlideAnimatedTransitioning.h"

#define kVISlideTransitionTime 0.35
#define kVISlideScaleChangePct 0.33

@implementation RZCardSlideAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:container.bounds];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bgView.backgroundColor = [UIColor blackColor];
    [container insertSubview:bgView atIndex:0];
    
    if (self.isForward)
    {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
        toViewController.view.transform = CGAffineTransformMakeScale(1.0 - kVISlideScaleChangePct, 1.0 - kVISlideScaleChangePct);
        toViewController.view.alpha = 0.1f;
        
        [UIView animateWithDuration:kVISlideTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toViewController.view.transform = CGAffineTransformIdentity;
                             toViewController.view.alpha = 1.0f;
                             fromViewController.view.transform = CGAffineTransformMakeTranslation(-container.bounds.size.width, 0);
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
        toViewController.view.transform = CGAffineTransformMakeTranslation(-container.bounds.size.width, 0);

        [UIView animateWithDuration:kVISlideTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.transform = CGAffineTransformMakeScale(1.0 - kVISlideScaleChangePct, 1.0 - kVISlideScaleChangePct);
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
    return kVISlideTransitionTime;
}


@end
