//
//  RZRectZoomAnimationController.h
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
#import <CoreGraphics/CGGeometry.h>

#import "RZAnimationControllerProtocol.h"

@protocol RZRectZoomAnimationDelegate;

@interface RZRectZoomAnimationController : NSObject <RZAnimationControllerProtocol>

/**
 *  The delegate for information about the positioning of the views.
 */
@property (weak, nonatomic) id<RZRectZoomAnimationDelegate> rectZoomDelegate;

/**
 *  Flag to allow the From View controller to fade its alpha.
 *  Default to YES;
 */
@property (assign, nonatomic) BOOL shouldFadeBackgroundViewController;

/**
 *  Physics animation spring dampening.
 *  Default is 0.6f.
 */
@property (assign, nonatomic) CGFloat animationSpringDampening;

/**
 *  Physics animation spring velocity.
 *  Default is 15.0f.
 */
@property (assign, nonatomic) CGFloat animationSpringVelocity;

@end

@protocol RZRectZoomAnimationDelegate <NSObject>

/**
 *  The rect that the ToView will go to. This should be relative to the view controller.
 *
 *  @return The rect to insert the ToView into.
 */
- (CGRect)rectZoomPosition;

@end
