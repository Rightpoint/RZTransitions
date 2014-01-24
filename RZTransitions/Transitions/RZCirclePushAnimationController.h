//
//  RZCirclePushAnimationController.h
//  RZTransitions
//
//  Created by Stephen Barnes on 12/13/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZZoomPushAnimationController.h"

@protocol RZCirclePushAnimationDelegate <NSObject>

@optional
// Return the center point, in the from view controller's coordinate space, where the circle
// transition should be centered.  If not used, the center defaults to the center of the
// from view controller.
- (CGPoint)circleCenter;

// Return the radius that the circle transition should start from.  If not used, the radius
// defaults to the minimum of the from view controller's bounds width or height.
- (CGFloat)circleStartingRadius;

@end

@interface RZCirclePushAnimationController : RZZoomPushAnimationController
<RZAnimationControllerProtocol>

@property (nonatomic, weak)     id<RZCirclePushAnimationDelegate> circleDelegate;
@property (nonatomic, assign)   CGFloat maximumCircleScale;
@property (nonatomic, assign)   CGFloat minimumCircleScale;

@end
