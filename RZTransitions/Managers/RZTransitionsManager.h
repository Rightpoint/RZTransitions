//
//  RZTransitionsManager.h
//  RZTransitions
//
//  Created by Stephen Barnes on 3/12/14.
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
#import "RZTransitionAction.h"

@protocol RZAnimationControllerProtocol;
@protocol RZTransitionInteractionController;
@class RZUniqueTransition;

@interface RZTransitionsManager : NSObject < UINavigationControllerDelegate,
                                             UIViewControllerTransitioningDelegate,
                                             UITabBarControllerDelegate >

@property (strong, nonatomic) id<RZAnimationControllerProtocol> defaultPushPopAnimationController;
@property (strong, nonatomic) id<RZAnimationControllerProtocol> defaultPresentDismissAnimationController;
@property (strong, nonatomic) id<RZAnimationControllerProtocol> defaultTabBarAnimationController;

+ (RZTransitionsManager *)shared;

#pragma mark - Public API Set Animations and Interactions

- (RZUniqueTransition *)setAnimationController:(id<RZAnimationControllerProtocol>)animationController
                            fromViewController:(Class)fromViewController
                                     forAction:(RZTransitionAction)action;

- (RZUniqueTransition *)setAnimationController:(id<RZAnimationControllerProtocol>)animationController
                            fromViewController:(Class)fromViewController
                              toViewController:(Class)toViewController
                                     forAction:(RZTransitionAction)action;

- (RZUniqueTransition *)setInteractionController:(id<RZTransitionInteractionController>)interactionController
                              fromViewController:(Class)fromViewController
                                toViewController:(Class)toViewController
                                       forAction:(RZTransitionAction)action;

- (void)overrideAnimationDirection:(BOOL)override withTransition:(RZUniqueTransition *)transitionKey;

@end
