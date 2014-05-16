//
//  RZCardSlideAnimatedTransitioning.h
//  RZTransitions
//
//  Created by Nick Donaldson on 11/19/13.
//

#import <Foundation/Foundation.h>
#import "RZAnimationControllerProtocol.h"

@interface RZCardSlideAnimationController : NSObject <RZAnimationControllerProtocol>

@property (nonatomic, strong) UIColor *containerBackgroundColor;

@end
