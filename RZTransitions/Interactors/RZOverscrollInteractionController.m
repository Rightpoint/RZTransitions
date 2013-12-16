//
//  RZOverscrollInteractionController.m
//  RZTransitions
//
//  Created by Stephen Barnes on 12/16/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZOverscrollInteractionController.h"

#define kRZOverscrollInteractionDefaultCompletionPercentage  0.35f
#define kRZOverscrollInteractionDefaultTopStartDistance      75.0f
#define kRZOverscrollInteractionDefaultBottomStartDistance   25.0f
#define kRZOverscrollInteractionDefaultTranslationDistance   200.0f

@interface RZOverscrollInteractionController ()

@property (nonatomic, assign) CGFloat lastYOffset;

@end

@implementation RZOverscrollInteractionController

// TODO: can't autosynthesize from protocol :(
@synthesize action = _action;
@synthesize isInteractive = _isInteractive;
@synthesize delegate = _delegate;
@synthesize shouldCompleteTransition = _shouldCompleteTransition;

#pragma mark - RZTransitionInteractor Protocol

- (void)attachViewController:(UIViewController *)viewController withAction:(RZTransitionAction)action
{
    self.fromViewController = viewController;
    self.action = action;
}

- (void)watchScrollView:(UIScrollView*)scrollView
{
    [scrollView setDelegate:self];
}

#pragma mark - UIPercentDrivenInteractiveTransition

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

#pragma mark - Interaction Logic

- (CGFloat)completionPercent
{
    return kRZOverscrollInteractionDefaultCompletionPercentage;
}

- (CGFloat)translationPercentageWithScrollView:(UIScrollView *)scrollView isScrollingDown:(BOOL)isScrollingDown
{
    if (isScrollingDown)
    {
        return ((scrollView.contentOffset.y + kRZOverscrollInteractionDefaultTopStartDistance) / kRZOverscrollInteractionDefaultTranslationDistance) * -1;
    }
    else
    {
        return ((scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height - kRZOverscrollInteractionDefaultBottomStartDistance) / kRZOverscrollInteractionDefaultTranslationDistance);
    }
}

- (BOOL)scrollViewPastStartLocationWithScrollView:(UIScrollView *)scrollview isScrollingDown:(BOOL)isScrollingDown
{
    if (isScrollingDown)
    {
        return (scrollview.contentOffset.y < kRZOverscrollInteractionDefaultTopStartDistance);
    }
    else
    {
        return ((scrollview.contentOffset.y + scrollview.frame.size.height - scrollview.contentSize.height) > kRZOverscrollInteractionDefaultBottomStartDistance);
    }
}

- (void)updateInteractionWithPercentage:(CGFloat)percentage
{
    self.shouldCompleteTransition = percentage > [self completionPercent];
    [self updateInteractiveTransition:percentage];
}

- (void)completeInteractionWithScrollView:(UIScrollView *)scrollView
{
    if (self.isInteractive)
    {
        self.isInteractive = NO;
        self.shouldCompleteTransition ? [self finishInteractiveTransition] : [self cancelInteractiveTransition];
        if(self.shouldCompleteTransition)
        {
            [scrollView setDelegate:nil];
        }
    }
}

- (void)beginTransition
{
    self.isInteractive = YES;
    if (self.action & RZTransitionAction_Push)
    {
        [self.fromViewController.navigationController pushViewController:[self.delegate nextViewControllerForInteractor:self] animated:YES];
    }
    else if (self.action & RZTransitionAction_Present)
    {
        [self.fromViewController presentViewController:[self.delegate nextViewControllerForInteractor:self] animated:YES completion:nil];
    }
    else if (self.action & RZTransitionAction_Pop)
    {
        [self.fromViewController.navigationController popViewControllerAnimated:YES];
    }
    else if (self.action & RZTransitionAction_Dismiss)
    {
        [self.fromViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

// TODO: break out into helper class or base class
#pragma mark - RZTransition Action Helpers

+ (BOOL)actionIsPresentOrDismissWithAction:(NSUInteger)action
{
    return ((action & RZTransitionAction_Present) || (action & RZTransitionAction_Dismiss));
}

+ (BOOL)actionIsPushOrPopWithAction:(NSUInteger)action
{
    return ((action & RZTransitionAction_Push) || (action & RZTransitionAction_Pop));
}

+ (BOOL)actionIsPushOrPresentWithAction:(NSUInteger)action
{
    return ((action & RZTransitionAction_Present) || (action & RZTransitionAction_Push));
}

+ (BOOL)actionIsDismissOrPopWithAction:(NSUInteger)action
{
    return ((action & RZTransitionAction_Dismiss) || (action & RZTransitionAction_Pop));
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL overScrollDown = scrollView.contentOffset.y < 0;
    BOOL overScrollUp = scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height);
    BOOL scrollViewPastStartLocation = [self scrollViewPastStartLocationWithScrollView:scrollView isScrollingDown:overScrollDown];
    BOOL scrollingDirectionUp = scrollView.contentOffset.y - self.lastYOffset < 0;
    
    if (!scrollViewPastStartLocation)
    {
        return;
    }
    
    CGFloat percentage = [self translationPercentageWithScrollView:scrollView isScrollingDown:overScrollDown];

    if (overScrollDown && [RZOverscrollInteractionController actionIsPushOrPresentWithAction:self.action])
    {
        if (!self.isInteractive && scrollingDirectionUp && scrollViewPastStartLocation)
        {
            [self beginTransition];
        }
        else if (scrollViewPastStartLocation)
        {
            [self updateInteractionWithPercentage:percentage];
        }
    }
    else if (overScrollUp && [RZOverscrollInteractionController actionIsDismissOrPopWithAction:self.action])
    {
        if (!self.isInteractive && !scrollingDirectionUp && scrollViewPastStartLocation)
        {
            [self beginTransition];
        }
        else if (scrollViewPastStartLocation)
        {
            [self updateInteractionWithPercentage:percentage];
        }
    }
    
    self.lastYOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self completeInteractionWithScrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self completeInteractionWithScrollView:scrollView];
}

@end
