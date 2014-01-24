//
//  RZBaseSwipeInteractionController.h
//  RZTransitions
//
//  Created by Stephen Barnes on 12/4/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZTransitionInteractionControllerProtocol.h"

@interface RZBaseSwipeInteractionController : UIPercentDrivenInteractiveTransition
    <RZTransitionInteractionController, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic, assign) BOOL reverseGestureDirection;

- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer;
- (CGFloat)swipeCompletionPercent;
- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer;
- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer;

@end
