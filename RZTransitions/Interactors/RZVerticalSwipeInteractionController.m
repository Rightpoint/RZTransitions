//
//  RZVerticalTransitionInteractor.m
//  RZTransitions
//
//  Created by Stephen Barnes on 12/4/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZVerticalSwipeInteractionController.h"

#define kRZVerticalTransitionCompletionPercentage 0.3f

@implementation RZVerticalSwipeInteractionController

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

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer*)gestureRecognizer;
        CGFloat xTranslation = [panGestureRecognizer translationInView:panGestureRecognizer.view].x;
        return xTranslation == 0;
    }
    
    return YES;
}

@end
