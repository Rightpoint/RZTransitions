//
//  RZTransitionsNavigationController.m
//  RZTransitions
//
//  Created by Stephen Barnes on 3/7/14.
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

#import "RZTransitionsNavigationController.h"
#import "RZTransitionsManager.h"

@interface RZTransitionsNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation RZTransitionsNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak RZTransitionsNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self.interactivePopGestureRecognizer setEnabled:YES];
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = [RZTransitionsManager shared];
    }
}

// Hijack the push method to disable the gesture
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    [super pushViewController:viewController animated:animated];
//}

#pragma mark - UINavigationControllerDelegate

// TODO: reenable the back gesture from the transitions manager

//- (void)navigationController:(UINavigationController *)navigationController
//       didShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animate
//{
//    // Enable the gesture again once the new controller is shown
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = YES;
//    }
//}

@end
