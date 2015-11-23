//
//  RZPinchInteration.m
//  RZTransitions
//
//  Created by Stephen Barnes on 12/11/13.
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

#import "RZPinchInteractionController.h"

static const CGFloat kRZPinchInteractionDefaultCompletionPercentage     = 0.5f;

@implementation RZPinchInteractionController

@synthesize action = _action;
@synthesize isInteractive = _isInteractive;
@synthesize nextViewControllerDelegate = _delegate;
@synthesize shouldCompleteTransition = _shouldCompleteTransition;

- (void)attachViewController:(UIViewController *)viewController withAction:(RZTransitionAction)action
{
    self.fromViewController = viewController;
    self.action = action;
    [self attachGestureRecognizerToView:self.fromViewController.view];
}

- (void)attachGestureRecognizerToView:(UIView *)view
{
    [view addGestureRecognizer:self.gestureRecognizer];
}

-(void)dealloc
{
    [self.gestureRecognizer.view removeGestureRecognizer:self.gestureRecognizer];
}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (CGFloat)translationPercentageWithPinchGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    return pinchGestureRecognizer.scale / 2.0f;
}

- (BOOL)isPinchWithGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    return pinchGestureRecognizer.scale < 1.0f;
}

#pragma mark - UIPinchGestureRecognizer Delegate

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    CGFloat percentage = [self translationPercentageWithPinchGestureRecognizer:pinchGestureRecognizer];
    BOOL isPinch = [self isPinchWithGesture:pinchGestureRecognizer];
    
    switch ( pinchGestureRecognizer.state ) {
        case UIGestureRecognizerStateBegan:
            self.isInteractive = YES;
            
            if ( !isPinch && self.nextViewControllerDelegate && [self.nextViewControllerDelegate conformsToProtocol:@protocol(RZTransitionInteractionControllerDelegate)] ) {
                if ( self.action & RZTransitionAction_Push ) {
                    [self.fromViewController.navigationController pushViewController:[self.nextViewControllerDelegate nextViewControllerForInteractor:self] animated:YES];
                }
                else if ( self.action & RZTransitionAction_Present ) {
                    // TODO: set and store a completion
                    [self.fromViewController presentViewController:[self.nextViewControllerDelegate nextViewControllerForInteractor:self] animated:YES completion:nil];
                }
            }
            else {
                if ( self.action & RZTransitionAction_Pop ) {
                    [self cancelInteractiveTransition];
                    self.isInteractive = NO;
                    [self.fromViewController.navigationController popViewControllerAnimated:YES];
                }
                else if ( self.action & RZTransitionAction_Dismiss ) {
                    [self cancelInteractiveTransition];
                    self.isInteractive = NO;
                    [self.fromViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            if ( self.isInteractive ) {
                self.shouldCompleteTransition = (percentage > kRZPinchInteractionDefaultCompletionPercentage);
                [self updateInteractiveTransition:percentage];
            }
            break;
            
        case UIGestureRecognizerStateCancelled:
            self.isInteractive = NO;
            [self cancelInteractiveTransition];
            break;
            
        case UIGestureRecognizerStateEnded:
            if ( self.isInteractive ) {
                self.isInteractive = NO;
                if ( !self.shouldCompleteTransition || pinchGestureRecognizer.state == UIGestureRecognizerStateCancelled ) {
                    [self cancelInteractiveTransition];
                }
                else {
                    [self finishInteractiveTransition];
                }
            }
            
        default:
            break;
    }
}

#pragma mark - Overridden Properties

- (UIGestureRecognizer *)gestureRecognizer
{
    if ( !_gestureRecognizer ) {
        _gestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [_gestureRecognizer setDelegate:self];
    }
    return _gestureRecognizer;
}

@end
