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
#import "NSObject+RZTransitionsViewHelpers.h"
#import <UIKit/UIKit.h>

#define kRZZoomAlphaTransitionTime 0.3
#define kRZZoomAlphaMaxScale       1.333

@implementation RZZoomAlphaAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

#pragma mark - Animated transitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [(NSObject *)transitionContext rzt_fromView];
    UIView *toView = [(NSObject *)transitionContext rzt_toView];
    UIView *container = [transitionContext containerView];
    
    toView.userInteractionEnabled = YES;
    
    if ( !self.isPositiveAnimation ) {
        fromView.opaque = NO;
        [container insertSubview:toView belowSubview:fromView];
        
        [UIView animateWithDuration:kRZZoomAlphaTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             fromView.alpha = 0.0f;
                             fromView.transform =  CGAffineTransformMakeScale(kRZZoomAlphaMaxScale, kRZZoomAlphaMaxScale);
                         }
                         completion:^(BOOL finished) {
                             fromView.alpha = 1.0f;
                             fromView.transform = CGAffineTransformIdentity;
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    else {
        toView.opaque = NO;
        toView.alpha = 0.0f;
        toView.transform = CGAffineTransformMakeScale(kRZZoomAlphaMaxScale, kRZZoomAlphaMaxScale);
        [container addSubview:toView];
        
        [UIView animateWithDuration:kRZZoomAlphaTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             toView.alpha = 1.0f;
                             toView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             toView.opaque = YES;
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kRZZoomAlphaTransitionTime;
}

@end
