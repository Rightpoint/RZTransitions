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
