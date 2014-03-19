//
//  RZUniqueTransition.m
//
//  Created by Stephen Barnes on 3/13/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZUniqueTransition.h"

@interface RZUniqueTransition ()

@end

@implementation RZUniqueTransition

#pragma mark - Equality overrides

- (instancetype)initWithAction:(RZTransitionAction)action
   withFromViewControllerClass:(Class)fromViewController
     withToViewControllerClass:(Class)toViewController
{
    self = [super init];
    if (self) {
        _transitionAction = action;
        _fromViewControllerClass = fromViewController;
        _toViewControllerClass = toViewController;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    RZUniqueTransition *copiedObject = [[[self class] allocWithZone:zone] init];
    
    copiedObject.transitionAction = self.transitionAction;
    copiedObject.toViewControllerClass = self.toViewControllerClass;
    copiedObject.fromViewControllerClass = self.fromViewControllerClass;
    
    return copiedObject;
}

- (NSUInteger)hash
{
    return [[self fromViewControllerClass] hash] ^ [[self toViewControllerClass] hash] ^ [self transitionAction];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[RZUniqueTransition class]]) {
        return NO;
    }
    
    RZUniqueTransition *otherObject = (RZUniqueTransition *)object;
    
    return (otherObject.transitionAction & self.transitionAction) &&
    (otherObject.fromViewControllerClass == self.fromViewControllerClass) &&
    (otherObject.toViewControllerClass == self.toViewControllerClass);
}

@end
