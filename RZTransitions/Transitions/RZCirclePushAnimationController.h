//
//  RZCirclePushAnimationController.h
//  RZTransitions
//
//  Created by Stephen Barnes on 12/13/13.
//  Copyright 2014 Raizlabs and other contributors
//  http://raizlabs.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "RZZoomPushAnimationController.h"

@protocol RZCirclePushAnimationDelegate <NSObject>

@optional

/**
 *  Calculate the center point, in the from view controller's coordinate space, where the circle transition should be centered.  If not used, the center defaults to the center of the from view controller.
 *
 *  @return the circle transition's center point.
 */
- (CGPoint)circleCenter;

/**
 *  Calculate the radius that the circle transition should start from.  If not used, the radius defaults to the minimum of the from view controller's bounds width or height.
 *
 *  @return the circle transition's starting radius.
 */
- (CGFloat)circleStartingRadius;

@end

@interface RZCirclePushAnimationController : RZZoomPushAnimationController
<RZAnimationControllerProtocol>

@property (nonatomic, weak)     id<RZCirclePushAnimationDelegate> circleDelegate;
@property (nonatomic, assign)   CGFloat maximumCircleScale;
@property (nonatomic, assign)   CGFloat minimumCircleScale;

@end
