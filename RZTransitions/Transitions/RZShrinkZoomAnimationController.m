//
//  RZShrinkTransitioner.m
//  RZTransitions
//
//  Created by Nick Donaldson on 10/11/13.
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

#import "RZShrinkZoomAnimationController.h"
#import "NSObject+RZTransitionsViewHelpers.h"
#import <UIKit/UIKit.h>

@implementation RZShrinkZoomAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [(NSObject *)transitionContext rzt_fromView];
    UIView *toView = [(NSObject *)transitionContext rzt_toView];
    UIView *container = [transitionContext containerView];
 
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        [fromView setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
    } completion:^(BOOL finished) {
        
        [fromView removeFromSuperview];
        [toView setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
        [container addSubview:toView];
        
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [fromView setTransform:CGAffineTransformIdentity];
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
