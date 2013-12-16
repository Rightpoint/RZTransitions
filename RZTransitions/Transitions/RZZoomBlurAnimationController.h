//
//  RZZoomBlurAnimatedTransitioning.h
//  RZTransitions
//
//  Created by Nick Donaldson on 10/17/13.
//

#import <Foundation/Foundation.h>
#import "RZTransitionInteractorProtocol.h"

@interface RZZoomBlurAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isDismissal;

@property (nonatomic, assign) CGFloat blurRadius;

@property (nonatomic, assign) CGFloat saturationDelta;

@property (nonatomic, strong) UIColor* blurTintColor;

@property (nonatomic, weak) id<RZTransitionInteractor> transitionInteractor;

@end
