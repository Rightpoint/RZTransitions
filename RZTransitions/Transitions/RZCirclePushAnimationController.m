//
//  RZCirclePushAnimationController.m
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/13/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZCirclePushAnimationController.h"

#define kRZCircleMaxScale           2.5f
#define kRZCircleMinScale           0.25f
#define kRZCircleAnimationTime      0.5f
#define kRZCircleMaskAnimation      @"kRZCircleMaskAnimation"

@implementation RZCirclePushAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect bounds = toViewController.view.bounds;
    CGFloat diameter = MIN(bounds.size.height, bounds.size.width);
    CGFloat radius = diameter / 2;
    
    CAShapeLayer *circleMaskLayer = [CAShapeLayer layer];
    circleMaskLayer.frame = bounds;
    
    // Make a circular shape
    CGPoint center = CGPointMake(fromViewController.view.frame.origin.x + fromViewController.view.frame.size.width / 2,
                                           fromViewController.view.frame.origin.y + fromViewController.view.frame.size.height / 2);
    circleMaskLayer.position = center;

    // TODO: work on centering this path correctly -SB
    circleMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(fromViewController.view.frame.origin.x,
                                                                              fromViewController.view.frame.origin.y + fromViewController.view.frame.size.height / 5,
                                                                              2.0*radius,
                                                                              2.0*radius)
                                                      cornerRadius:radius].CGPath;
    
    CABasicAnimation *circleMaskAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    circleMaskAnimation.duration            = kRZCircleAnimationTime;
    circleMaskAnimation.repeatCount         = 1.0;    // Animate only once
    circleMaskAnimation.removedOnCompletion = NO;     // Remain after the animation
    
    [circleMaskAnimation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.34 :.01 :.69 :1.37]];

    if (self.isForward)
    {
        [circleMaskAnimation setFillMode:kCAFillModeForwards];
        
        // Animate from small to large
        circleMaskAnimation.fromValue = [NSNumber numberWithFloat:kRZCircleMinScale];
        circleMaskAnimation.toValue   = [NSNumber numberWithFloat:kRZCircleMaxScale];
        
        // Add to the view and start the animation
        [toViewController.view.layer setMask:circleMaskLayer];
        toViewController.view.layer.masksToBounds = YES;
        [circleMaskLayer addAnimation:circleMaskAnimation forKey:kRZCircleMaskAnimation];
    } else {
        [circleMaskAnimation setFillMode:kCAFillModeForwards];
        
        // Animate from large to small
        circleMaskAnimation.fromValue = [NSNumber numberWithFloat:kRZCircleMaxScale];
        circleMaskAnimation.toValue   = [NSNumber numberWithFloat:kRZCircleMinScale];

        // Add to the view and start the animation
        [fromViewController.view.layer setMask:circleMaskLayer];
        fromViewController.view.layer.masksToBounds = YES;
        [circleMaskLayer addAnimation:circleMaskAnimation forKey:kRZCircleMaskAnimation];
    }
    
    [super animateTransition:transitionContext];
}

@end
