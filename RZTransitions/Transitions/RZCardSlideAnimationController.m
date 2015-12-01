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
#import "NSObject+RZTransitionsViewHelpers.h"

#define kRZSlideTransitionTime 0.35
#define kRZSlideScaleChangePct 0.33

@implementation RZCardSlideAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        _transitionTime = kRZSlideTransitionTime;
        _horizontalOrientation = YES;
        _containerBackgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [(NSObject *)transitionContext rzt_fromView];
    UIView *toView = [(NSObject *)transitionContext rzt_toView];
    UIView *container = [transitionContext containerView];

    UIView *bgView = [[UIView alloc] initWithFrame:container.bounds];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bgView.backgroundColor = self.containerBackgroundColor;
    [container insertSubview:bgView atIndex:0];

    if ( self.isPositiveAnimation ) {
        [container insertSubview:toView belowSubview:fromView];
        toView.frame = container.frame;
        toView.transform = CGAffineTransformMakeScale(1.0 - kRZSlideScaleChangePct, 1.0 - kRZSlideScaleChangePct);
        toView.alpha = 0.1f;

        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toView.transform = CGAffineTransformIdentity;
                             toView.alpha = 1.0f;
                             if ( self.horizontalOrientation ) {
                                 fromView.transform = CGAffineTransformMakeTranslation(-container.bounds.size.width, 0);
                             }
                             else {
                                 fromView.transform = CGAffineTransformMakeTranslation(0, container.bounds.size.height);
                             }
                         }
                         completion:^(BOOL finished) {
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformIdentity;
                             [bgView removeFromSuperview];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    else {
        [container addSubview:toView];

        if ( self.horizontalOrientation ) {
            toView.transform = CGAffineTransformMakeTranslation(-container.bounds.size.width, 0);
        }
        else {
            toView.transform = CGAffineTransformMakeTranslation(0, container.bounds.size.height);
        }

        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformMakeScale(1.0 - kRZSlideScaleChangePct, 1.0 - kRZSlideScaleChangePct);
                             fromView.alpha = 0.1f;
                         }
                         completion:^(BOOL finished) {
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformIdentity;
                             fromView.alpha = 1.0f;
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
