//
//  RZTransitionsManager.h
//
//  Created by Stephen Barnes on 3/12/14.
//

#import <Foundation/Foundation.h>
#import "RZTransitionAction.h"

@protocol RZAnimationControllerProtocol;

@interface RZTransitionsManager : NSObject < UINavigationControllerDelegate,
                                             UIViewControllerTransitioningDelegate,
                                             UITabBarControllerDelegate >

@property (strong, nonatomic) id<RZAnimationControllerProtocol> defaultPushPopAnimationController;
@property (strong, nonatomic) id<RZAnimationControllerProtocol> defaultPresentDismissAnimationController;
@property (strong, nonatomic) id<RZAnimationControllerProtocol> defaultTabBarAnimationController;

+ (RZTransitionsManager *)shared;
+ (NSString *)keyToAnyViewControllerFromViewController:(UIViewController *)fromViewController;
+ (NSString *)keyToAnyViewControllerFromViewControllerClass:(Class)fromViewController;
+ (NSString *)keyFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;
+ (NSString *)keyFromViewControllerClass:(Class)fromViewController toViewControllerClass:(Class)toViewController;
+ (NSString *)keyForDismissedViewController:(UIViewController *)dismissedViewController;

- (void)setAnimationController:(id<RZAnimationControllerProtocol>)animationController
            fromViewController:(Class)fromViewController
                     forAction:(RZTransitionAction)action;

- (void)setAnimationController:(id<RZAnimationControllerProtocol>)animationController
            fromViewController:(Class)fromViewController
              toViewController:(Class)toViewController
                     forAction:(RZTransitionAction)action;

@end
