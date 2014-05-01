//
//  RZRectZoomAnimationController.h
//  RZTransitions
//
//  Created by Stephen Barnes on 12/13/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZAnimationControllerProtocol.h"

@protocol RZRectZoomAnimationDelegate <NSObject>

// Return the rect to insert the next view into.  This should be relative to the view controller's view.
- (CGRect)rectZoomPosition;

@end

@interface RZRectZoomAnimationController : NSObject <RZAnimationControllerProtocol>

@property (nonatomic, weak)     id<RZRectZoomAnimationDelegate> rectZoomDelegate;
@property (nonatomic, assign)   BOOL shouldFadeBackgroundViewController;
@property (nonatomic, assign)   CGFloat animationSpringDampening;
@property (nonatomic, assign)   CGFloat animationSpringVelocity;

@end
