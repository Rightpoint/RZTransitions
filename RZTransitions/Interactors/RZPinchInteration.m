//
//  RZPinchInteration.m
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/11/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZPinchInteration.h"

#define kRZPinchInteractionDefaultCompletionPercentage  0.5f

@implementation RZPinchInteration

// TODO: can't autosynthesize from protocol :(
@synthesize action = _action;
@synthesize isInteractive = _isInteractive;
@synthesize delegate = _delegate;
@synthesize shouldCompleteTransition = _shouldCompleteTransition;

- (void)attachViewController:(UIViewController *)viewController withAction:(RZTransitionAction)action
{
    self.fromViewController = viewController;
    self.action = action;
    [self attachGestureRecognizerToView:self.fromViewController.view];
}

- (void)attachGestureRecognizerToView:(UIView*)view {
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
    
    switch (pinchGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.isInteractive = YES;
            
            if (!isPinch && self.delegate && [self.delegate conformsToProtocol:@protocol(RZTransitionInteractorDelegate)])
            {
                if (self.action & RZTransitionAction_Push) {
                    [self.fromViewController.navigationController pushViewController:[self.delegate nextViewControllerForInteractor:self] animated:YES];
                }
                else if (self.action & RZTransitionAction_Present) {
                    // TODO: set and store a completion
                    [self.fromViewController presentViewController:[self.delegate nextViewControllerForInteractor:self] animated:YES completion:nil];
                }
            }
            else
            {
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
                self.shouldCompleteTransition = (percentage > kRZPinchInteractionDefaultCompletionPercentage);
                [self updateInteractiveTransition:percentage];
            }
            break;
            
        case UIGestureRecognizerStateCancelled:
            self.isInteractive = NO;
            [self cancelInteractiveTransition];
            break;
            
        case UIGestureRecognizerStateEnded:
            if (self.isInteractive) {
                self.isInteractive = NO;
                if (!self.shouldCompleteTransition || pinchGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
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

- (UIGestureRecognizer*)gestureRecognizer
{
    if (!_gestureRecognizer)
    {
        _gestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [_gestureRecognizer setDelegate:self];
    }
    return _gestureRecognizer;
}

@end
