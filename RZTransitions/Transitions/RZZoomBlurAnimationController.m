//
//  RZZoomBlurAnimatedTransitioning.m
//  RZTransitions
//
//  Created by Nick Donaldson on 10/17/13.
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

#import "RZZoomBlurAnimationController.h"
#import "UIImage+RZTransitionsFastImageBlur.h"
#import <objc/runtime.h>

#define kRZZBAnimationTransitionTime 0.3
#define kRZZBZoomScale 1.2

#define kRZZBDefaultBlurRadius      12.0f
#define kRZZBDefaultSaturationDelta 1.0f
#define kRZZBDefaultTintColor       [UIColor colorWithWhite:1.0f alpha:0.15f]
static char kRZZoomBlurImageAssocKey;

@implementation RZZoomBlurAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

- (CGFloat)blurRadius
{
    if (_blurRadius == 0)
    {
        _blurRadius = kRZZBDefaultBlurRadius;
    }
    return _blurRadius;
}

- (CGFloat)saturationDelta
{
    if (_saturationDelta == 0)
    {
        _saturationDelta = kRZZBDefaultSaturationDelta;
    }
    return _saturationDelta;
}

- (UIColor *)blurTintColor
{
    if (!_blurTintColor)
    {
        _blurTintColor = kRZZBDefaultTintColor;
    }
    return _blurTintColor;
}

#pragma mark - Animated transitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    toViewController.view.userInteractionEnabled = YES;
    
    if (!self.isPositiveAnimation)
    {
        // This may not exist if we didn't present with this guy originally. If not, it will just do an alpha fade, no blur.
        UIImageView *blurImageView = objc_getAssociatedObject(fromViewController, &kRZZoomBlurImageAssocKey);
        
        fromViewController.view.backgroundColor = [UIColor clearColor];
        fromViewController.view.opaque = NO;
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        if (blurImageView)
        {
            [container insertSubview:blurImageView aboveSubview:toViewController.view];
        }

        [UIView animateWithDuration:kRZZBAnimationTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             blurImageView.alpha = 0.f;
                             fromViewController.view.alpha = 0.f;
                             fromViewController.view.transform =  CGAffineTransformMakeScale(kRZZBZoomScale, kRZZBZoomScale);
                         }
                         completion:^(BOOL finished) {
                             fromViewController.view.alpha = 1.f;
                             fromViewController.view.transform = CGAffineTransformIdentity;
                             [blurImageView removeFromSuperview];
                             objc_setAssociatedObject(fromViewController, &kRZZoomBlurImageAssocKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    else
    {
        UIImage *blurImage = [UIImage blurredImageByCapturingView:fromViewController.view withRadius:self.blurRadius tintColor:self.blurTintColor saturationDeltaFactor:self.saturationDelta];
        UIImageView *blurImageView = [[UIImageView alloc] initWithImage:blurImage];
        objc_setAssociatedObject(toViewController, &kRZZoomBlurImageAssocKey, blurImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [container addSubview:blurImageView];
        blurImageView.alpha = 0.f;
        
        UIColor *originalBGColor = [toViewController.view backgroundColor];
        toViewController.view.frame = fromViewController.view.frame;
        toViewController.view.backgroundColor = [UIColor clearColor];
        toViewController.view.opaque = NO;
        toViewController.view.alpha = 0.f;
        toViewController.view.transform = CGAffineTransformMakeScale(kRZZBZoomScale, kRZZBZoomScale);
        [container addSubview:toViewController.view];
        
        [UIView animateWithDuration:kRZZBAnimationTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             blurImageView.alpha = 1.f;
                             toViewController.view.alpha = 1.f;
                             toViewController.view.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             toViewController.view.backgroundColor = originalBGColor;
                             toViewController.view.opaque = YES;
                             [toViewController.view insertSubview:blurImageView atIndex:0];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kRZZBAnimationTransitionTime;
}

@end
