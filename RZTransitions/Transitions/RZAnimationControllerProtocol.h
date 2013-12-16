//
//  RZAnimationControllerProtocol.h
//  RZTransitions
//
//  Created by Stephen Barnes on 12/16/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#ifndef RZTransitions_RZAnimationControllerProtocol_h
#define RZTransitions_RZAnimationControllerProtocol_h

@protocol RZAnimationControllerProtocol <UIViewControllerAnimatedTransitioning>

@required

// If the animation should be positive or negative.
// Positive: push / present / fromTop / toRight
// Negative: pop / dismiss / fromBottom / toLeft
@property (nonatomic, assign) BOOL isPositiveAnimation;

@end

#endif
