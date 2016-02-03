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
#import "NSObject+RZTransitionsViewHelpers.h"
#import <UIKit/UIKit.h>

#define kRZCircleDefaultMaxScale    2.5f
#define kRZCircleDefaultMinScale    0.25f
#define kRZCircleAnimationTime      0.5f
#define kRZCircleMaskAnimation      @"kRZCircleMaskAnimation"

@interface RZCirclePushAnimationController ()

@property (weak, nonatomic) UIView *maskedView;

- (CGPoint)circleCenterPointWithFromView:(UIView *)fromView;
- (CGFloat)circleStartingRadiusWithFromView:(UIView *)fromView toView:(UIView *)toView;

@end

@implementation RZCirclePushAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

#pragma mark - Animation Transition

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        _minimumCircleScale = kRZCircleDefaultMinScale;
        _maximumCircleScale = kRZCircleDefaultMaxScale;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [super animateTransition:transitionContext];

    UIView *fromView = [(NSObject *)transitionContext rzt_fromView];
    UIView *toView = [(NSObject *)transitionContext rzt_toView];

    CGRect bounds = fromView.bounds;
    CAShapeLayer *circleMaskLayer = [CAShapeLayer layer];
    circleMaskLayer.frame = bounds;
    
    // Calculate the size the circle should start at
    CGFloat radius = [self circleStartingRadiusWithFromView:fromView toView:toView];
    
    // Calculate the center point of the circle
    CGPoint circleCenter = [self circleCenterPointWithFromView:fromView];
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

    if ( self.isPositiveAnimation ) {
        [circleMaskAnimation setFillMode:kCAFillModeForwards];
        
        // Animate from small to large
        circleMaskAnimation.fromValue = @(self.minimumCircleScale);
        circleMaskAnimation.toValue   = @(self.maximumCircleScale);
        
        // Add to the view and start the animation
        toView.layer.mask = circleMaskLayer;
        toView.layer.masksToBounds = YES;
        [circleMaskLayer addAnimation:circleMaskAnimation forKey:kRZCircleMaskAnimation];
        self.maskedView = toView;
    }
    else {
        [circleMaskAnimation setFillMode:kCAFillModeForwards];
        
        // Animate from large to small
        circleMaskAnimation.fromValue = @(1.0f);
        circleMaskAnimation.toValue   = @(self.minimumCircleScale);

        // Add to the view and start the animation
        fromView.layer.mask = circleMaskLayer;
        fromView.layer.masksToBounds = YES;
        [circleMaskLayer addAnimation:circleMaskAnimation forKey:kRZCircleMaskAnimation];
        self.maskedView = fromView;
    }
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    // animationEnded: is a optional method of the UIViewControllerAnimatedTransitioning protocol.
    // RZZoomPushAnimationController does not currently implement this method, but might at some point,
    //  so make sure we are doing something sane here.
    if ([[[self class] superclass] respondsToSelector:@selector(animationEnded:)]) {
        [super animationEnded:transitionCompleted];
    }

    self.maskedView.layer.mask = nil;
    self.maskedView = nil;
}

#pragma mark - Helper Methods

// Calculate the center point of the circle
- (CGPoint)circleCenterPointWithFromView:(UIView *)fromView
{
    CGPoint center = CGPointZero;
    if ( self.circleDelegate && [self.circleDelegate respondsToSelector:@selector(circleCenter)] ) {
        center = [self.circleDelegate circleCenter];
    }
    else {
        center = CGPointMake(fromView.bounds.origin.x + fromView.bounds.size.width / 2,
                             fromView.bounds.origin.y + fromView.bounds.size.height / 2);
    }
    return center;
}

// Calculate the size the circle should start at
- (CGFloat)circleStartingRadiusWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    CGFloat radius = 0.0f;
    if ( self.circleDelegate && [self.circleDelegate respondsToSelector:@selector(circleStartingRadius)] ) {
        radius = [self.circleDelegate circleStartingRadius];
        CGRect bounds = toView.bounds;
        self.maximumCircleScale = ((MAX(bounds.size.height, bounds.size.width) / (radius)) * 1.25);
    }
    else {
        CGRect bounds = fromView.bounds;
        CGFloat diameter = MIN(bounds.size.height, bounds.size.width);
        radius = diameter / 2;
    }
    return radius;
}

@end
