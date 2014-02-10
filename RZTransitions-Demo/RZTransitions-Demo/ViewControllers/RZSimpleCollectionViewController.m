//
//  RZSimpleCollectionViewController.m
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/11/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZSimpleCollectionViewController.h"
#import "RZSimpleColorViewController.h"

#import "RZTransitionInteractionControllerProtocol.h"
#import "RZOverscrollInteractionController.h"
#import "RZPinchInteractionController.h"
#import "RZShrinkZoomAnimationController.h"
#import "RZZoomBlurAnimationController.h"
#import "RZZoomPushAnimationController.h"
#import "RZCardSlideAnimationController.h"
#import "RZCirclePushAnimationController.h"
#import "RZVerticalTransitionInteractionController.h"

#import "UIColor+Random.h"

#define kRZCollectionViewCellReuseId  @"kRZCollectionViewCellReuseId"
#define kRZCollectionViewNumCells     50
#define kRZCollectionViewCellSize     88

@interface RZSimpleCollectionViewController ()
<UIViewControllerTransitioningDelegate, RZTransitionInteractionControllerDelegate, RZCirclePushAnimationDelegate>

@property (nonatomic, strong) RZOverscrollInteractionController			*presentInteractionController;
@property (nonatomic, strong) RZVerticalTransitionInteractionController *dismissInteractionController;
@property (nonatomic, strong) RZZoomBlurAnimationController				*presentDismissAnimationController;
@property (nonatomic, assign) CGPoint									circleTransitionStartPoint;

@end

@implementation RZSimpleCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kRZCollectionViewCellReuseId];
    
    // TODO: Currently the RZOverscrollInteractor will take over the collection view's delegate, meaning that ```didSelectItemAtIndexPath:```
    // will not be forwarded back.  RZOverscrollInteractor requires a bit of a rewrite to use KVO instead of delegation to address this.
    
    self.presentInteractionController = [[RZOverscrollInteractionController alloc] init];
    [self.presentInteractionController attachViewController:self withAction:RZTransitionAction_Present];
    [self.presentInteractionController setDelegate:self];
    
    self.circleTransitionStartPoint = CGPointZero;

    self.presentDismissAnimationController = [[RZZoomBlurAnimationController alloc] init];
    self.presentDismissAnimationController.isPositiveAnimation = YES;
//    [self.presentDismissAnimationController setCircleDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    // TODO: ** Cannot set the scroll view delegate and the collection view delegate at the same time **
//    [self.presentInteractionController watchScrollView:self.collectionView];
}

#pragma mark - New VC Helper Methods

- (UIViewController *)newColorVCWithColor:(UIColor *)color
{
    RZSimpleColorViewController *newColorVC = [[RZSimpleColorViewController alloc] initWithColor:color];
    
    // Hook up next VC's dismiss transition
	[newColorVC setTransitioningDelegate:self];
	[self.dismissInteractionController attachViewController:newColorVC withAction:RZTransitionAction_Dismiss];
	
    return newColorVC;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *cellBackgroundColor = [collectionView cellForItemAtIndexPath:indexPath].backgroundColor;
    UIViewController *colorVC = [self newColorVCWithColor:cellBackgroundColor];
    
    self.circleTransitionStartPoint = [collectionView convertPoint:[collectionView cellForItemAtIndexPath:indexPath].center toView:self.view];;
    
    // Present VC
    [self presentViewController:colorVC animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kRZCollectionViewNumCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRZCollectionViewCellReuseId forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor randomColor]];
    return cell;
}

#pragma mark - Custom View Controller Animations - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.presentDismissAnimationController.isPositiveAnimation = YES;
    return self.presentDismissAnimationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presentDismissAnimationController.isPositiveAnimation = NO;
    return self.presentDismissAnimationController;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
//    return (self.presentInteractionController && [self.presentInteractionController isInteractive]) ? self.presentInteractionController : nil;
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
	return (self.dismissInteractionController && [self.dismissInteractionController isInteractive]) ? self.dismissInteractionController : nil;
}

#pragma mark - RZTransitionInteractorDelegate

- (UIViewController *)nextViewControllerForInteractor:(id<RZTransitionInteractionController>)interactor
{
    // TODO: ability to set the animation dismissal via the interaction
    // TODO: ability to associate interactor with a cell or optional data such as color or ID
    
    return [self newColorVCWithColor:nil];
}

#pragma mark - RZCirclePushAnimationDelegate

- (CGPoint)circleCenter
{
    return self.circleTransitionStartPoint;
}

- (CGFloat)circleStartingRadius
{
    return (kRZCollectionViewCellSize / 2.0f);
}

@end
