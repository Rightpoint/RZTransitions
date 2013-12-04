//
//  RZVerticalTransitionInteractor.m
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/4/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZVerticalTransitionInteractor.h"

#define kRZVerticalTransitionCompletionPercentage 0.3f

@implementation RZVerticalTransitionInteractor

- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer
{
    return [self translationWithPanGestureRecongizer:panGestureRecognizer] < 0;
}

- (CGFloat)swipeCompletionPercent
{
    return kRZVerticalTransitionCompletionPercentage;
}

- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    return fabsf([self translationWithPanGestureRecongizer:panGestureRecognizer] / panGestureRecognizer.view.bounds.size.height);
}

- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    return [panGestureRecognizer translationInView:panGestureRecognizer.view].y;
}

@end
