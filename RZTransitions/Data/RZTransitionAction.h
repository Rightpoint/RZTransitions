//
//  RZTransitionAction.h
//  RZTransitions
//
//  Created by Stephen Barnes on 3/13/14.
//  Copyright 2014 Raizlabs and other contributors
//  http://raizlabs.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#ifndef RZTransitions_Demo_RZTransitionAction_h
#define RZTransitions_Demo_RZTransitionAction_h

#define kRZTransitionActionCount        5

/**
 *  All the recognized transition action types.
 */
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
