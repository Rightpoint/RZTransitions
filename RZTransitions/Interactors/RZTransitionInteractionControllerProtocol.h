//
//  RZTransitionInteractionControllerProtocol.h
//  RZTransitions
//
//  Created by Stephen Barnes on 12/4/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZTransitionAction.h"

#ifndef RZTransitions_RZTransitionInteractorProtocol_h
#define RZTransitions_RZTransitionInteractorProtocol_h

@protocol RZTransitionInteractionController;
@protocol RZTransitionInteractionControllerDelegate;

@protocol RZTransitionInteractionControllerDelegate <NSObject>

@optional
- (UIViewController *)nextViewControllerForInteractor:(id<RZTransitionInteractionController>)interactor;

@end

@protocol RZTransitionInteractionController <UIViewControllerInteractiveTransitioning>

@required

@property (nonatomic, assign, readwrite) BOOL isInteractive;
@property (nonatomic, assign, readwrite) BOOL shouldCompleteTransition;
@property (nonatomic, assign, readwrite) RZTransitionAction action;
@property (nonatomic, weak) id<RZTransitionInteractionControllerDelegate> nextViewControllerDelegate;

- (void)attachViewController:(UIViewController *)viewController withAction:(RZTransitionAction)action;

@end

#endif
