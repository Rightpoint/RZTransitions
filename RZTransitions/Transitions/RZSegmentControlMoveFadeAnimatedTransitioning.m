//
//  RZSegmentControlMoveFadeAnimatedTransitioning.m
//
//  Created by Alex Rouse on 11/5/13.
//

#import "RZSegmentControlMoveFadeAnimatedTransitioning.h"
#import "UIImage+RZFastImageBlur.h"

#define kVISegAnimationTransitionTime   0.4f
#define kVISegScaleAmount               0.3f
#define kVISegXOffsetFactor             1.5f
#define kVISegYOffsetFactor             0.25f

@implementation RZSegmentControlMoveFadeAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kVISegScaleAmount, kVISegScaleAmount);
    CGAffineTransform oldTranslateTransform;
    CGAffineTransform newTranslateTransform;

    if (self.isLeft)
    {
        oldTranslateTransform = CGAffineTransformMakeTranslation(container.bounds.size.width*kVISegXOffsetFactor, -container.bounds.size.height*kVISegYOffsetFactor);
        newTranslateTransform = CGAffineTransformMakeTranslation(-container.bounds.size.width*kVISegXOffsetFactor, -container.bounds.size.height*kVISegYOffsetFactor);
    }
    else
    {
        oldTranslateTransform = CGAffineTransformMakeTranslation(-container.bounds.size.width*kVISegXOffsetFactor, -container.bounds.size.height*kVISegYOffsetFactor);
        newTranslateTransform = CGAffineTransformMakeTranslation(container.bounds.size.width*kVISegXOffsetFactor, -container.bounds.size.height*kVISegYOffsetFactor);
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
    return kVISegAnimationTransitionTime;
}


@end
