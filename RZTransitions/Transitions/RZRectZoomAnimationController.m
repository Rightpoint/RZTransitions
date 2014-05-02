//
//  RZRectZoomAnimationController.m
//  RZTransitions
//
//  Created by Stephen Barnes on 05/01/14.
//  Copyright 2014 Raizlabs and other contributors
//  http://raizlabs.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
