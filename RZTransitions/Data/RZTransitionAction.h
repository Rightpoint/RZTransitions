//
//  RZTransitionAction.h
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 3/13/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#ifndef RZTransitions_Demo_RZTransitionAction_h
#define RZTransitions_Demo_RZTransitionAction_h

#define kRZTransitionActionCount        5

typedef NS_ENUM (NSInteger, RZTransitionAction) {
    RZTransitionAction_Push             = (1 << 0),
    RZTransitionAction_Pop              = (1 << 1),
    RZTransitionAction_Present          = (1 << 2),
    RZTransitionAction_Dismiss          = (1 << 3),
    RZTransitionAction_Tab              = (1 << 4),
    RZTransitionAction_PushPop          = RZTransitionAction_Push|RZTransitionAction_Pop,
    RZTransitionAction_PresentDismiss   = RZTransitionAction_Present|RZTransitionAction_Dismiss,
    RZTransitionAction_Any              = RZTransitionAction_Present|RZTransitionAction_Dismiss|RZTransitionAction_Tab,
};

#endif
