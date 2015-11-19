//
//  RZBaseSwipeInteractionController.h
//  RZTransitions
//
//  Created by Stephen Barnes on 12/4/13.
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

#import <UIKit/UIKit.h>
#import <CoreGraphics/CGGeometry.h>

#import "RZTransitionInteractionControllerProtocol.h"

@interface RZBaseSwipeInteractionController : UIPercentDrivenInteractiveTransition
    <RZTransitionInteractionController, UIGestureRecognizerDelegate>

/**
 *  The ViewController that is doing the presenting.
 */
@property (weak, nonatomic) UIViewController *fromViewController;

/**
 *  The GestureRecognizer to get information about the swipe.
 */
@property (strong, nonatomic) UIPanGestureRecognizer *gestureRecognizer;

/**
 *  flag to know if the gesture is happening in the reverse direction.
 */
@property (assign, nonatomic) BOOL reverseGestureDirection;

/**
 *  Subclasses must overide this.
 *
 *  @param panGestureRecognizer Pan gesture to check if the movement is positive.
 *
 *  @return Flag if the gesture is in the positive or negative direction.
 */
- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer;

/**
 *  Subclass should overide this.
 *  The value that needs to be hit by the gesture recognizer to consider the transition happening.
 *
 *  @return The percentage of the full amount that needs to be reached to complete the transition.
 */
- (CGFloat)swipeCompletionPercent;

/**
 *  Subclass must overide this.
 *  The translation percentage of the passed gesture recognizer
 *
 *  @param panGestureRecognizer The Gesture recognizer being tested
 *
 *  @return The percentage of the translation that is complete
 */
- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer;

/**
 *  Subclasses must override this.
 *  The physical translation that is on the the view due to the panGestureRecognizer
 *
 *  @param panGestureRecognizer the gesture recognizer being tested
 *
 *  @return the translation that is currently on the view.
 */
- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer;

@end
