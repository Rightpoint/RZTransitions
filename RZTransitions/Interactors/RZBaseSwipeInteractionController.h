//
//  RZBaseSwipeInteractionTransition.h
//  RZTransitions
//
//  Created by Stephen Barnes on 12/4/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZTransitionInteractorProtocol.h"

@interface RZBaseSwipeInteractionController : UIPercentDrivenInteractiveTransition
    <RZTransitionInteractor, UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIViewController *fromViewController;
@property(nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;

- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer;
- (CGFloat)swipeCompletionPercent;
- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer;
- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer;

@end
