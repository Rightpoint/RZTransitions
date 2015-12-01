//
//  RZSegmentControlMoveFadeAnimatedTransitioning.m
//  RZTransitions
//
//  Created by Alex Rouse on 11/5/13.
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

#import "RZSegmentControlMoveFadeAnimationController.h"
#import "NSObject+RZTransitionsViewHelpers.h"
#import <UIKit/UIKit.h>

#import "UIImage+RZTransitionsFastImageBlur.h"

#define kRZSegAnimationTransitionTime   0.4f
#define kRZSegScaleAmount               0.3f
#define kRZSegXOffsetFactor             1.5f
#define kRZSegYOffsetFactor             0.25f

@implementation RZSegmentControlMoveFadeAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [(NSObject *)transitionContext rzt_fromView];
    UIView *toView = [(NSObject *)transitionContext rzt_toView];
    UIView *container = [transitionContext containerView];
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kRZSegScaleAmount, kRZSegScaleAmount);
    CGAffineTransform oldTranslateTransform;
    CGAffineTransform newTranslateTransform;

    // Animate to the right
    if ( self.isPositiveAnimation ) {
        oldTranslateTransform = CGAffineTransformMakeTranslation(container.bounds.size.width*kRZSegXOffsetFactor, -container.bounds.size.height*kRZSegYOffsetFactor);
        newTranslateTransform = CGAffineTransformMakeTranslation(-container.bounds.size.width*kRZSegXOffsetFactor, -container.bounds.size.height*kRZSegYOffsetFactor);
    }
    else {     // Animate to the left
        oldTranslateTransform = CGAffineTransformMakeTranslation(-container.bounds.size.width*kRZSegXOffsetFactor, -container.bounds.size.height*kRZSegYOffsetFactor);
        newTranslateTransform = CGAffineTransformMakeTranslation(container.bounds.size.width*kRZSegXOffsetFactor, -container.bounds.size.height*kRZSegYOffsetFactor);
    }
    
    [container insertSubview:toView aboveSubview:fromView];
    toView.alpha = 0.1f;
    toView.transform = CGAffineTransformConcat(newTranslateTransform, scaleTransform);
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         fromView.transform = CGAffineTransformIdentity;
                         fromView.alpha = 1.0f;
                         fromView.transform = CGAffineTransformConcat(oldTranslateTransform, scaleTransform);
                         fromView.alpha = 0.1f;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];

}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kRZSegAnimationTransitionTime;
}

@end
