//
//  RZBaseSwipeInteractionTransition.m
//  RZTransitions
//
//  Created by Stephen Barnes on 12/4/13.
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

#import "RZBaseSwipeInteractionController.h"

#define kRZBaseSwipeInteractionDefaultCompletionPercentage  0.3f

@implementation RZBaseSwipeInteractionController

@synthesize action = _action;
@synthesize isInteractive = _isInteractive;
@synthesize nextViewControllerDelegate = _delegate;
@synthesize shouldCompleteTransition = _shouldCompleteTransition;

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        _reverseGestureDirection = NO;
    }
    return self;
}

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

#pragma mark - UIPanGestureRecognizer Delegate

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGFloat percentage = [self translationPercentageWithPanGestureRecongizer:panGestureRecognizer];
    BOOL positiveDirection = self.reverseGestureDirection ? ![self isGesturePositive:panGestureRecognizer] : [self isGesturePositive:panGestureRecognizer];
    
    switch ( panGestureRecognizer.state ) {
        case UIGestureRecognizerStateBegan:
            self.isInteractive = YES;
            
            if ( positiveDirection && self.nextViewControllerDelegate &&
                [self.nextViewControllerDelegate conformsToProtocol:@protocol(RZTransitionInteractionControllerDelegate)] ) {
                if ( self.action & RZTransitionAction_Push ) {
                    [self.fromViewController.navigationController pushViewController:[self.nextViewControllerDelegate nextViewControllerForInteractor:self] animated:YES];
                }
                else if ( self.action & RZTransitionAction_Present ) {
                    // TODO: set and store a completion
                    [self.fromViewController presentViewController:[self.nextViewControllerDelegate nextViewControllerForInteractor:self] animated:YES completion:nil];
                }
            }
            else {
                if (self.action & RZTransitionAction_Pop) {
                    [self.fromViewController.navigationController popViewControllerAnimated:YES];
                }
                else if (self.action & RZTransitionAction_Dismiss) {
                    [self.fromViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }
            break;

        case UIGestureRecognizerStateChanged:
            if (self.isInteractive) {
                self.shouldCompleteTransition = (percentage >= [self swipeCompletionPercent]);
                [self updateInteractiveTransition:percentage];
            }
            break;

        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if (self.isInteractive) {
                if (!self.shouldCompleteTransition) {
                    [self cancelInteractiveTransition];
                }
                else {
                    [self finishInteractiveTransition];
                }

                self.isInteractive = NO;
            }

        default:
            break;
    }
}

- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return NO;
}

- (CGFloat)swipeCompletionPercent
{
    return kRZBaseSwipeInteractionDefaultCompletionPercentage;
}

- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0.0f;
}

- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0.0f;
}

#pragma mark - Overridden Properties

- (UIGestureRecognizer *)gestureRecognizer
{
    if ( !_gestureRecognizer ) {
        _gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [_gestureRecognizer setDelegate:self];
    }
    return _gestureRecognizer;
}

@end
