//
//  RZZoomAlphaAnimationController.m
//  RZTransitions
//
//  Created by Stephen Barnes on 2/12/14.
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
