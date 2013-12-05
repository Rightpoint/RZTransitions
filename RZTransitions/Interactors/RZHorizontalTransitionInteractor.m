//
//  RZHorizontalTransitionInteractor.m
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/3/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZHorizontalTransitionInteractor.h"

#define kRZHorizontalTransitionCompletionPercentage 0.3f

@implementation RZHorizontalTransitionInteractor

- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer
{
    return [self translationWithPanGestureRecongizer:panGestureRecognizer] < 0;
}

- (CGFloat)swipeCompletionPercent
{
    return kRZHorizontalTransitionCompletionPercentage;
}

- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    return fabsf([self translationWithPanGestureRecongizer:panGestureRecognizer] / panGestureRecognizer.view.bounds.size.width);
}

- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    return [panGestureRecognizer translationInView:panGestureRecognizer.view].x;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer*)gestureRecognizer;
        CGFloat yTranslation = [panGestureRecognizer translationInView:panGestureRecognizer.view].y;
        return yTranslation == 0;
    }
    
    return YES;
}

@end
