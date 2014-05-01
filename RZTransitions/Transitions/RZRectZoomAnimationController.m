//
//  RZRectZoomAnimationController.m
//  RZTransitions
//
//  Created by Stephen Barnes on 05/01/14.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZRectZoomAnimationController.h"

static const CGFloat kRZRectZoomAnimationTime             = 0.7f;
static const CGFloat kRZRectZoomDefaultFadeAnimationTime  = 0.2f;
static const CGFloat kRZRectZoomDefaultSpringDampening    = 0.6f;
static const CGFloat kRZRectZoomDefaultSpringVelocity     = 15.0f;

@interface RZRectZoomAnimationController ()

@end

@implementation RZRectZoomAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

#pragma mark - Animation Transition

- (id)init
{
    self = [super init];
    if (self) {
        _shouldFadeBackgroundViewController = YES;
        _animationSpringDampening = kRZRectZoomDefaultSpringDampening;
        _animationSpringVelocity = kRZRectZoomDefaultSpringVelocity;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];

    __block CGRect originalFrame = toViewController.view.frame;
    __block CGRect cellFrame = CGRectZero;
    if ( (self.rectZoomDelegate != nil) && [self.rectZoomDelegate respondsToSelector:@selector(rectZoomPosition)] ) {
        cellFrame = [self.rectZoomDelegate rectZoomPosition];
    }
    
    if ( self.isPositiveAnimation ) {
        UIView *resizableSnapshotView = [toViewController.view resizableSnapshotViewFromRect:toViewController.view.bounds afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        resizableSnapshotView.frame = cellFrame;
        [container addSubview:resizableSnapshotView];
        
        [UIView animateWithDuration:kRZRectZoomDefaultFadeAnimationTime animations:^{
            if (self.shouldFadeBackgroundViewController) {
                fromViewController.view.alpha = 0.0f;
            }
        }];
        
        [UIView animateWithDuration:kRZRectZoomAnimationTime
                              delay:0
             usingSpringWithDamping:self.animationSpringDampening
              initialSpringVelocity:self.animationSpringVelocity
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             resizableSnapshotView.frame = originalFrame;
                         } completion:^(BOOL finished) {
                             [container addSubview:toViewController.view];
                             [resizableSnapshotView removeFromSuperview];
                            if (self.shouldFadeBackgroundViewController) {
                                fromViewController.view.alpha = 1.0f;
                            }
                            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
    else {
        UIView *resizableSnapshotView = [fromViewController.view resizableSnapshotViewFromRect:fromViewController.view.bounds afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        resizableSnapshotView.frame = fromViewController.view.frame;
        
        [container insertSubview:resizableSnapshotView aboveSubview:fromViewController.view];
        [container insertSubview:toViewController.view belowSubview:resizableSnapshotView];

        toViewController.view.alpha = 0.0f;
        [toViewController viewWillAppear:YES];
        
        [UIView animateWithDuration:kRZRectZoomDefaultFadeAnimationTime animations:^{
            toViewController.view.alpha = 1.0f;
        }];
        
        [UIView animateWithDuration:kRZRectZoomAnimationTime
                              delay:0
             usingSpringWithDamping:self.animationSpringDampening
              initialSpringVelocity:self.animationSpringVelocity
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             resizableSnapshotView.frame = cellFrame;
                       } completion:^(BOOL finished) {
                             [UIView animateWithDuration:kRZRectZoomDefaultFadeAnimationTime animations:^{
                                 resizableSnapshotView.alpha = 0.0f;
                             } completion:^(BOOL finished) {
                                 [resizableSnapshotView removeFromSuperview];
                                 [container addSubview:fromViewController.view];
                                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             }];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kRZRectZoomAnimationTime;
}

@end
