//
//  RZZoomPushAnimatedTransitioning.m
//  RZTransitions
//
//  Created by Nick Donaldson on 10/22/13.
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

#import "RZZoomPushAnimationController.h"
#import "NSObject+RZTransitionsViewHelpers.h"
#import <UIKit/UIKit.h>

#define kRZPushTransitionTime 0.35
#define kRZPushScaleChangePct 0.33

@implementation RZZoomPushAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{    
    UIView *toView = [(NSObject *)transitionContext rzt_toView];
    UIView *fromView = [(NSObject *)transitionContext rzt_fromView];
    UIView *container = [transitionContext containerView];
    
    if ( self.isPositiveAnimation ) {
        toView.frame = container.frame;
        [container insertSubview:toView belowSubview:fromView];
        toView.transform = CGAffineTransformMakeScale(1.0 - kRZPushScaleChangePct, 1.0 - kRZPushScaleChangePct);

        [UIView animateWithDuration:kRZPushTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformMakeScale(1.0 + kRZPushScaleChangePct, 1.0 + kRZPushScaleChangePct);
                             fromView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformIdentity;
                             fromView.alpha = 1.0f;
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    else {
        if (transitionContext.presentationStyle == UIModalPresentationNone || transitionContext.presentationStyle == UIModalPresentationFullScreen) {
            [container insertSubview:toView belowSubview:fromView];
        }
        toView.transform = CGAffineTransformMakeScale(1.0 + kRZPushScaleChangePct, 1.0 + kRZPushScaleChangePct);
        toView.alpha = 0.0f;
        
        [UIView animateWithDuration:kRZPushTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toView.transform = CGAffineTransformIdentity;
                             toView.alpha = 1.0f;
                             fromView.alpha = 0.0f;
                             fromView.transform = CGAffineTransformMakeScale(1.0 - kRZPushScaleChangePct, 1.0 - kRZPushScaleChangePct);
                         }
                         completion:^(BOOL finished) {
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformIdentity;
                             toView.alpha = 1.0f;
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kRZPushTransitionTime;
}

@end
