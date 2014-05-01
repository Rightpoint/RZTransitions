//
//  RZTransitionsManager.h
//
//  Created by Stephen Barnes on 3/12/14.
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
