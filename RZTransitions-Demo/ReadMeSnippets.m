//
//  ReadMeSnippets.m
//  RZTransitions-Demo
//
//  Created by Eric Slosser on 11/24/15.
//  Copyright © 2015 Raizlabs. All rights reserved.
//

#import "RZTransitions.h"
#import "RZSimpleCollectionViewController.h"

@interface ReadMeSnippets : UIViewController <RZTransitionInteractionControllerDelegate>

// 5
@property (nonatomic, strong) id<RZTransitionInteractionController> presentInteractionController;

@end

@implementation ReadMeSnippets

-(void)snippets
{
    // 1
    id<RZAnimationControllerProtocol> presentDismissAnimationController = [[RZZoomAlphaAnimationController alloc] init];
    id<RZAnimationControllerProtocol> pushPopAnimationController = [[RZCardSlideAnimationController alloc] init];
    [[RZTransitionsManager shared] setDefaultPresentDismissAnimationController:presentDismissAnimationController];
    [[RZTransitionsManager shared] setDefaultPushPopAnimationController:pushPopAnimationController];

    // 2
    [self setTransitioningDelegate:[RZTransitionsManager shared]];
    UIViewController *nextViewController = [[UIViewController alloc] init];
    [nextViewController setTransitioningDelegate:[RZTransitionsManager shared]];
    [self presentViewController:nextViewController animated:YES completion:nil];

    // 3
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    [navigationController setDelegate:[RZTransitionsManager shared]];

    // 4
    [[RZTransitionsManager shared] setAnimationController:[[RZZoomPushAnimationController alloc] init]
                                       fromViewController:[self class]
                                         toViewController:[RZSimpleCollectionViewController class]
                                                forAction:RZTransitionAction_PushPop];

}

// 5
//@property (nonatomic, strong) id<RZTransitionInteractionController> presentInteractionController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create the presentation interaction controller that allows a custom gesture
    // to control presenting a new VC via a presentViewController
    self.presentInteractionController = [[RZVerticalSwipeInteractionController alloc] init];
    [self.presentInteractionController setNextViewControllerDelegate:self];
    [self.presentInteractionController attachViewController:self withAction:RZTransitionAction_Present];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //  Use the present interaction controller for presenting any view controller from this view controller
    [[RZTransitionsManager shared] setInteractionController:self.presentInteractionController
                                         fromViewController:[self class]
                                           toViewController:nil
                                                  forAction:RZTransitionAction_Present];
}
// end of 5

@end
