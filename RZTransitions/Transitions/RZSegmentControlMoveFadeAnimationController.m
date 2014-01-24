//
//  RZSegmentControlMoveFadeAnimatedTransitioning.m
//  RZTransitions
//
//  Created by Alex Rouse on 11/5/13.
//

#import "RZSegmentControlMoveFadeAnimationController.h"
#import "UIImage+RZTransitionsFastImageBlur.h"

#define kRZSegAnimationTransitionTime   0.4f
#define kRZSegScaleAmount               0.3f
#define kRZSegXOffsetFactor             1.5f
#define kRZSegYOffsetFactor             0.25f

@implementation RZSegmentControlMoveFadeAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kRZSegScaleAmount, kRZSegScaleAmount);
    CGAffineTransform oldTranslateTransform;
    CGAffineTransform newTranslateTransform;

    // Animate to the right
    if (self.isPositiveAnimation)
    {
        oldTranslateTransform = CGAffineTransformMakeTranslation(container.bounds.size.width*kRZSegXOffsetFactor, -container.bounds.size.height*kRZSegYOffsetFactor);
        newTranslateTransform = CGAffineTransformMakeTranslation(-container.bounds.size.width*kRZSegXOffsetFactor, -container.bounds.size.height*kRZSegYOffsetFactor);
    }
    // Animate to the left
    else
    {
        oldTranslateTransform = CGAffineTransformMakeTranslation(-container.bounds.size.width*kRZSegXOffsetFactor, -container.bounds.size.height*kRZSegYOffsetFactor);
        newTranslateTransform = CGAffineTransformMakeTranslation(container.bounds.size.width*kRZSegXOffsetFactor, -container.bounds.size.height*kRZSegYOffsetFactor);
    }
    
    [container insertSubview:toViewController.view aboveSubview:fromViewController.view];
    toViewController.view.alpha = 0.1f;
    toViewController.view.transform = CGAffineTransformConcat(newTranslateTransform, scaleTransform);
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toViewController.view.transform = CGAffineTransformIdentity;
                         toViewController.view.alpha = 1.0f;
                         fromViewController.view.transform = CGAffineTransformConcat(oldTranslateTransform, scaleTransform);
                         fromViewController.view.alpha = 0.1f;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];

}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kRZSegAnimationTransitionTime;
}


@end
