//
//  NSObject+RZTransitionsViewHelpers_h.m
//  RZTransitions-Demo
//
//  Created by Eric Slosser on 11/20/15.
//  Copyright © 2015 Raizlabs. All rights reserved.
//

#import "NSObject+RZTransitionsViewHelpers.h"

@implementation NSObject (RZTransitionsViewHelpers)

- (UIView *)rzt_toView
{
    return [self _RZTViewHelper:YES];
}

- (UIView *)rzt_fromView
{
    return [self _RZTViewHelper:NO];
}

- (UIView *)_RZTViewHelper:(BOOL)isTo
{
    NSAssert([self conformsToProtocol:@protocol(UIViewControllerContextTransitioning)], @"bad parameter");
    if (![self conformsToProtocol:@protocol(UIViewControllerContextTransitioning)]) {
        return nil;
    }
    id<UIViewControllerContextTransitioning> context = (id<UIViewControllerContextTransitioning>)self;

    NSString *vcKey = isTo ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey;
    UIViewController *vc = [context viewControllerForKey:vcKey];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([context respondsToSelector:@selector(viewForKey:)]) {
        NSString *vKey = isTo ? UITransitionContextToViewKey : UITransitionContextFromViewKey;
        return [context viewForKey:vKey];
    }
    else {
        return vc.view;
    }
#else
    return vc.view;
#endif
}
@end
