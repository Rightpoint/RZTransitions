//
//  RZZoomBlurAnimatedTransitioning.m
//
//  Created by Nick Donaldson on 10/17/13.
//

#import "RZZoomBlurAnimationController.h"
#import "UIImage+RZFastImageBlur.h"
#import <objc/runtime.h>

#define kVIZBAnimationTransitionTime 0.3
#define kVIZBZoomScale 1.2

#define kVIZBDefaultBlurRadius      12.0f
#define kVIZBDefaultSaturationDelta 1.0f
#define kVIZBDefaultTintColor       [UIColor colorWithWhite:1.0f alpha:0.15f]
static char kVIZoomBlurImageAssocKey;

@implementation RZZoomBlurAnimationController

- (CGFloat)blurRadius
{
    if (_blurRadius == 0)
    {
        _blurRadius = kVIZBDefaultBlurRadius;
    }
    return _blurRadius;
}

- (CGFloat)saturationDelta
{
    if (_saturationDelta == 0)
    {
        _saturationDelta = kVIZBDefaultSaturationDelta;
    }
    return _saturationDelta;
}

- (UIColor *)blurTintColor
{
    if (!_blurTintColor)
    {
        _blurTintColor = kVIZBDefaultTintColor;
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
    
    if (self.isDismissal)
    {
        // This may not exist if we didn't present with this guy originally. If not, it will just do an alpha fade, no blur.
        UIImageView *blurImageView = objc_getAssociatedObject(fromViewController, &kVIZoomBlurImageAssocKey);
        
        fromViewController.view.backgroundColor = [UIColor clearColor];
        fromViewController.view.opaque = NO;
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        if (blurImageView)
        {
            [container insertSubview:blurImageView aboveSubview:toViewController.view];
        }

        [UIView animateWithDuration:kVIZBAnimationTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             blurImageView.alpha = 0.f;
                             fromViewController.view.alpha = 0.f;
                             fromViewController.view.transform =  CGAffineTransformMakeScale(kVIZBZoomScale, kVIZBZoomScale);
                         }
                         completion:^(BOOL finished) {
                             fromViewController.view.alpha = 1.f;
                             fromViewController.view.transform = CGAffineTransformIdentity;
                             [blurImageView removeFromSuperview];
                             objc_setAssociatedObject(fromViewController, &kVIZoomBlurImageAssocKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    else
    {
        UIImage *blurImage = [UIImage blurredImageByCapturingView:fromViewController.view withRadius:self.blurRadius tintColor:self.blurTintColor saturationDeltaFactor:self.saturationDelta];
        UIImageView *blurImageView = [[UIImageView alloc] initWithImage:blurImage];
        objc_setAssociatedObject(toViewController, &kVIZoomBlurImageAssocKey, blurImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [container addSubview:blurImageView];
        blurImageView.alpha = 0.f;
        
        UIColor *originalBGColor = [toViewController.view backgroundColor];
        
        toViewController.view.backgroundColor = [UIColor clearColor];
        toViewController.view.opaque = NO;
        toViewController.view.alpha = 0.f;
        toViewController.view.transform = CGAffineTransformMakeScale(kVIZBZoomScale, kVIZBZoomScale);
        [container addSubview:toViewController.view];
        
        [UIView animateWithDuration:kVIZBAnimationTransitionTime
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
    return kVIZBAnimationTransitionTime;
}

@end
