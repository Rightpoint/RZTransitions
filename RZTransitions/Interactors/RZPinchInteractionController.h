//
//  RZPinchInteration.h
//  RZTransitions
//
//  Created by Stephen Barnes on 12/11/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZTransitionInteractorProtocol.h"

@interface RZPinchInteractionController : UIPercentDrivenInteractiveTransition
<RZTransitionInteractor, UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIViewController *fromViewController;
@property(nonatomic, strong) UIPinchGestureRecognizer *gestureRecognizer;

- (CGFloat)translationPercentageWithPinchGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer;

@end
