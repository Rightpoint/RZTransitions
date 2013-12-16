//
//  RZZoomBlurAnimatedTransitioning.h
//  RZTransitions
//
//  Created by Nick Donaldson on 10/17/13.
//

#import <Foundation/Foundation.h>
#import "RZAnimationControllerProtocol.h"

@interface RZZoomBlurAnimationController : NSObject <RZAnimationControllerProtocol>

@property (nonatomic, assign) CGFloat blurRadius;

@property (nonatomic, assign) CGFloat saturationDelta;

@property (nonatomic, strong) UIColor* blurTintColor;

@end
