//
//  RZUniqueTransition.h
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

#import <Foundation/Foundation.h>
#import "RZTransitionAction.h"

@interface RZUniqueTransition : NSObject <NSCopying>

/**
 *  The bitmask of possible actions allowed for this transition (push/pop/etc).
 */
@property (assign, nonatomic) RZTransitionAction transitionAction;

/**
 *  The class of the @c UIViewController being transitioned from.
 */
@property (assign, nonatomic) Class fromViewControllerClass;

/**
 *  The class of the @c UIViewController being transitioned to.
 */
@property (assign, nonatomic) Class toViewControllerClass;

/**
 *  Creates a new @c RZUniqueTransition for use with the RZTransition Manager
 *
 *  @param action             The action that is to be used in the presentation/dismissal of the View controller
 *  @param fromViewController The ViewController class that will be going away.
 *  @param toViewController   The ViewController class that will be presented.
 *
 *  @return Instance of @c RZUniqueTransition
 */
- (instancetype)initWithAction:(RZTransitionAction)action
   withFromViewControllerClass:(Class)fromViewController
     withToViewControllerClass:(Class)toViewController;

@end
