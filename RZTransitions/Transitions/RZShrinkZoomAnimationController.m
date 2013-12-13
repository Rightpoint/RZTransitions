//
//  RZShrinkTransitioner.m
//
//  Created by Nick Donaldson on 10/11/13.
//

#import "RZShrinkZoomAnimationController.h"

@implementation RZShrinkZoomAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
 
    
    //if (self.is)
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        [fromViewController.view setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
    } completion:^(BOOL finished) {
        
        [fromViewController.view removeFromSuperview];
        [toViewController.view setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
        [container addSubview:toViewController.view];
        
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [toViewController.view setTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

@end
