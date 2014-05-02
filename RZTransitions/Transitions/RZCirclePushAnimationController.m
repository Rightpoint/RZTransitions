//
//  RZCirclePushAnimationController.m
//  RZTransitions
//
//  Created by Stephen Barnes on 12/13/13.
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

#import "RZCirclePushAnimationController.h"

#define kRZCircleDefaultMaxScale    2.5f
#define kRZCircleDefaultMinScale    0.25f
#define kRZCircleAnimationTime      0.5f
#define kRZCircleMaskAnimation      @"kRZCircleMaskAnimation"

@interface RZCirclePushAnimationController ()

- (CGPoint)circleCenterPointWithFromViewController:(UIViewController *)fromViewController;
- (CGFloat)circleStartingRadiusWithFromViewController:(UIViewController *)fromViewController
                                 withToViewController:(UIViewController *)toViewController;

@end

@implementation RZCirclePushAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

#pragma mark - Animation Transition

- (id)init
{
    self = [super init];
    if (self) {
        _minimumCircleScale = kRZCircleDefaultMinScale;
        _maximumCircleScale = kRZCircleDefaultMaxScale;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect bounds = toViewController.view.bounds;
    CAShapeLayer *circleMaskLayer = [CAShapeLayer layer];
    circleMaskLayer.frame = bounds;
    
    // Caclulate the size the circle should start at
    CGFloat radius = [self circleStartingRadiusWithFromViewController:fromViewController withToViewController:toViewController];
    
    // Caclulate the center point of the circle
    CGPoint circleCenter = [self circleCenterPointWithFromViewController:fromViewController];
    circleMaskLayer.position = circleCenter;
    CGRect circleBoundingRect = CGRectMake(circleCenter.x - radius, circleCenter.y - radius, 2.0*radius, 2.0*radius);
    circleMaskLayer.path = [UIBezierPath bezierPathWithOvalInRect:circleBoundingRect].CGPath;
    circleMaskLayer.bounds = circleBoundingRect;
    
    CABasicAnimation *circleMaskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    circleMaskAnimation.duration            = kRZCircleAnimationTime;
    circleMaskAnimation.repeatCount         = 1.0;    // Animate only once
    circleMaskAnimation.removedOnCompletion = NO;     // Remain after the animation

    // Set manual easing on the animation.  Tweak for fun!
    [circleMaskAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.34 :.01 :.69 :1.37]];

    if (self.isPositiveAnimation)
    {
        [circleMaskAnimation setFillMode:kCAFillModeForwards];
        
        // Animate from small to large
        circleMaskAnimation.fromValue = [NSNumber numberWithFloat:self.minimumCircleScale];
        circleMaskAnimation.toValue   = [NSNumber numberWithFloat:self.maximumCircleScale];
        
        // Add to the view and start the animation
        [toViewController.view.layer setMask:circleMaskLayer];
        toViewController.view.layer.masksToBounds = YES;
        [circleMaskLayer addAnimation:circleMaskAnimation forKey:kRZCircleMaskAnimation];
    }
    else
    {
        [circleMaskAnimation setFillMode:kCAFillModeForwards];
        
        // Animate from large to small
        circleMaskAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        circleMaskAnimation.toValue   = [NSNumber numberWithFloat:self.minimumCircleScale];

        // Add to the view and start the animation
        [fromViewController.view.layer setMask:circleMaskLayer];
        fromViewController.view.layer.masksToBounds = YES;
        [circleMaskLayer addAnimation:circleMaskAnimation forKey:kRZCircleMaskAnimation];
    }
    
    [super animateTransition:transitionContext];
}

#pragma mark - Helper Methods

// Caclulate the center point of the circle
- (CGPoint)circleCenterPointWithFromViewController:(UIViewController *)fromViewController
{
    CGPoint center = CGPointZero;
    if (self.circleDelegate && [self.circleDelegate respondsToSelector:@selector(circleCenter)])
    {
        center = [self.circleDelegate circleCenter];
    }
    else
    {
        center = CGPointMake(fromViewController.view.bounds.origin.x + fromViewController.view.bounds.size.width / 2,
                             fromViewController.view.bounds.origin.y + fromViewController.view.bounds.size.height / 2);
    }
    return center;
}

// Caclulate the size the circle should start at
- (CGFloat)circleStartingRadiusWithFromViewController:(UIViewController *)fromViewController
                                 withToViewController:(UIViewController *)toViewController
{
    CGFloat radius = 0.0f;
    if (self.circleDelegate && [self.circleDelegate respondsToSelector:@selector(circleStartingRadius)])
    {
        radius = [self.circleDelegate circleStartingRadius];
        CGRect bounds = toViewController.view.bounds;
        self.maximumCircleScale = ((MAX(bounds.size.height, bounds.size.width) / (radius)) * 1.25);
    }
    else
    {
        CGRect bounds = fromViewController.view.bounds;
        CGFloat diameter = MIN(bounds.size.height, bounds.size.width);
        radius = diameter / 2;
    }
    return radius;
}

@end
