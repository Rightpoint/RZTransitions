//
//  RZCardSlideAnimatedTransitioning.m
//  RZTransitions
//
//  Created by Nick Donaldson on 11/19/13.
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

#import "RZCardSlideAnimationController.h"

#define kRZSlideTransitionTime 0.35
#define kRZSlideScaleChangePct 0.33

@implementation RZCardSlideAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

- (id)init
{
    self = [super init];
    if (self)
    {
        _transitionTime = kRZSlideTransitionTime;
        _horizontalOrientation = TRUE;
        _containerBackgroundColor = [UIColor blackColor];
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
    bgView.backgroundColor = self.containerBackgroundColor;
    [container insertSubview:bgView atIndex:0];
    
    if (self.isPositiveAnimation)
    {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
        toViewController.view.transform = CGAffineTransformMakeScale(1.0 - kRZSlideScaleChangePct, 1.0 - kRZSlideScaleChangePct);
        toViewController.view.alpha = 0.1f;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
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

        [UIView animateWithDuration:[self transitionDuration:transitionContext]
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
    return self.transitionTime;
}

@end
