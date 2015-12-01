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
#import <UIKit/UIKit.h>
#import "RZTransitionAction.h"

@protocol RZAnimationControllerProtocol;
@protocol RZTransitionInteractionController;
@class RZUniqueTransition;

@interface RZTransitionsManager : NSObject < UINavigationControllerDelegate,
                                             UIViewControllerTransitioningDelegate,
                                             UITabBarControllerDelegate >

/**
 *  The default animation to use when pushing or popping a @c UIViewController on a @c UINavigationController.  Uses nothing if nil.
 */
@property (strong, nonatomic) id<RZAnimationControllerProtocol> _Nullable defaultPushPopAnimationController;

/**
 *  The default animation to use when presenting or dismissing a @c UIViewController on a @c UIViewController.  Uses nothing if nil.
 */
@property (strong, nonatomic) id<RZAnimationControllerProtocol> _Nullable defaultPresentDismissAnimationController;

/**
 *  The default animation to use when moving between tabs on a @c UITabBarController.  Uses nothing if nil.
 */
@property (strong, nonatomic) id<RZAnimationControllerProtocol> _Nullable defaultTabBarAnimationController;

#pragma mark - Shared Instance

+ (RZTransitionsManager *_Nonnull)shared;

#pragma mark - Public API Set Animations and Interactions

/**
 *  Set the animation to use when transitioning from one @c UIViewController class to any other @c UIViewController class.  The @c RZTransitionAction is the set of actions that this animation will be used for.  For example, if @c RZTransitionAction_Push is specified, the @c animationController specified will be used to animate from the @fromViewController to any other @UIViewController when pushing another view controller on top.
 *
 *  @param animationController The animation to use when transitioning.
 *  @param fromViewController  The @c UIViewController class that is being transitioned from.
 *  @param action              The bitmask of possible actions to use the @c animationController.  For example, specifying RZTransitionAction_Push|RZTransitionAction_Present will use this @c animationController for pushing and presenting from @c fromViewController.
 *
 *  @return A unique key object that can be used to reference this animation pairing.
 */
- (RZUniqueTransition * _Nonnull)setAnimationController:(id<RZAnimationControllerProtocol> _Nullable)animationController
                            fromViewController:(Class  _Nonnull )fromViewController
                                     forAction:(RZTransitionAction)action;

/**
 *  Set the animation to use when moving from one @c UIViewController class to another, specific @c UIViewController class.  The @c RZTransitionAction is the set of actions that this animation will be used for.  For example, if @c RZTransitionAction_Push is specified, the @c animationController specified will be used to animate from the @fromViewController to the @toViewController when pushing a @toViewController on top of a @fromViewController.
 *
 *  @param animationController The animation to use when transitioning.
 *  @param fromViewController  The @c UIViewController class that is being transitioned from.
 *  @param toViewController    The @c UIViewController class that is being transitioned to.
 *  @param action              The bitmask of possible actions to use the @c animationController.  For example, specifying RZTransitionAction_Push|RZTransitionAction_Present will use this @c animationController for pushing and presenting from @c fromViewController to @c toViewController.
 *
 *  @return A unique key object that can be used to reference this animation pairing.
 */
- (RZUniqueTransition * _Nonnull )setAnimationController:(id<RZAnimationControllerProtocol> _Nullable)animationController
                            fromViewController:(Class _Nullable )fromViewController
                              toViewController:(Class _Nullable )toViewController
                                     forAction:(RZTransitionAction)action;

/**
 *  Set the interactor to use when transitioning from one @c UIViewController class to another, specific @c UIViewController class.  The @c RZTransitionAction is the set of actions that this animation will be used for.  For example, if @c RZTransitionAction_Push is specified, the @c interactionController specified will be used to control the current animation controller if the current animation controller is animating from the @fromViewController to the @toViewController when pushing a @toViewController on top of a @fromViewController.
 *
 *  @param interactionController The interaction controller to use when transitioning.
 *  @param fromViewController    The @c UIViewController class that is being transitioned from.
 *  @param toViewController      The @c UIViewController class that is being transitioned to.
 *  @param action                The bitmask of possible actions to use the @c interactionController.  For example, specifying RZTransitionAction_Push|RZTransitionAction_Present will use this @c interactionController for pushing and presenting from @c fromViewController to @c toViewController.
 *
 *  @return A unique key object that can be used to reference this interaction pairing.
 */
- (RZUniqueTransition * _Nonnull )setInteractionController:(id<RZTransitionInteractionController> _Nullable)interactionController
                              fromViewController:(Class _Nullable )fromViewController
                                toViewController:(Class _Nullable )toViewController
                                       forAction:(RZTransitionAction)action;

/**
 *  Override the automatic transition direction (positive/negative) for a specific animation / view controller pairing.
 *
 *  @param override      Override if @c YES, ignore if @c NO.
 *  @param transitionKey The unique key for the animation / view controller pairing to override.
 */
- (void)overrideAnimationDirection:(BOOL)override withTransition:(RZUniqueTransition * _Nonnull)transitionKey;

@end
