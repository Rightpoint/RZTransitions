//
//  RZTransitionInteractionControllerProtocol.h
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

#import "RZTransitionAction.h"
#import <UIKit/UIKit.h>

#ifndef RZTransitions_RZTransitionInteractorProtocol_h
#define RZTransitions_RZTransitionInteractorProtocol_h

@protocol RZTransitionInteractionController;

@protocol RZTransitionInteractionControllerDelegate <NSObject>

@optional

/**
 *  Used to specify the next @c UIViewController that is shown when an interactor is ready to present, push, or move to a new tab.
 *
 *  @param interactor The interactor that is requesting a new @c UIViewController.
 *
 *  @return the @c UIViewController to be shown.
 */
- (UIViewController *)nextViewControllerForInteractor:(id<RZTransitionInteractionController>)interactor;

@end

@protocol RZTransitionInteractionController <UIViewControllerInteractiveTransitioning>

@required

/**
 *  Is the transition interaction controller currently in a user interaction state.
 */
@property (assign, nonatomic, readwrite) BOOL isInteractive;

/**
 *  Should the transition interaction controller complete the transaction if it is released in its current state.  Ex: a swipe interactor should not complete until it has passed a threshold percentage.
 */
@property (assign ,nonatomic, readwrite) BOOL shouldCompleteTransition;

/**
 *  The bitmap of actions that a transition interaction controller will complete for.
 */
@property (assign, nonatomic, readwrite) RZTransitionAction action;

/**
 *  The delegate that allows the interaction controller to receive a @UIViewController to display for positive actions such as push and present.
 */
@property (weak, nonatomic) id<RZTransitionInteractionControllerDelegate> nextViewControllerDelegate;

/**
 *  Initialize the Interaction Controller in the supplied @c UIViewController.  Typically adds a gesture recognizer to the @c UIViewController's view.
 *
 *  @param viewController the @c UIViewController that has interactions to transition with.
 *  @param action         the bitmap of action the interaction controller should respond to.
 */
- (void)attachViewController:(UIViewController *)viewController withAction:(RZTransitionAction)action;

@end

#endif
