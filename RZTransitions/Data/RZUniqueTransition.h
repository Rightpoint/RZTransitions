//
//  RZUniqueTransition.h
//
//  Created by Stephen Barnes on 3/13/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZTransitionAction.h"

@interface RZUniqueTransition : NSObject

@property (assign, nonatomic) RZTransitionAction transitionAction;
@property (assign, nonatomic) Class fromViewControllerClass;
@property (assign, nonatomic) Class toViewControllerClass;
@property (assign, nonatomic) BOOL toAnyViewController;

@end
