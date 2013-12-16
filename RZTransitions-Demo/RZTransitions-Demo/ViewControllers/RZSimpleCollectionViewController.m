//
//  RZSimpleCollectionViewController.m
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/11/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZSimpleCollectionViewController.h"
#import "RZSimpleColorViewController.h"

#import "RZTransitionInteractorProtocol.h"
#import "RZOverscrollInteractionController.h"
#import "RZPinchInteractionController.h"
#import "RZShrinkZoomAnimationController.h"
#import "RZZoomBlurAnimationController.h"
#import "RZZoomPushAnimationController.h"
#import "RZCardSlideAnimationController.h"

#import "UIColor+Random.h"

#define kRZCollectionViewCellReuseId  @"kRZCollectionViewCellReuseId"
#define kRZCollectionViewNumCells     50;

@interface RZSimpleCollectionViewController ()
<UIViewControllerTransitioningDelegate, RZTransitionInteractorDelegate>

@property (nonatomic, strong) RZOverscrollInteractionController *presentDismissInteractionController;
@property (nonatomic, strong) RZZoomPushAnimationController *presentDismissAnimationController;

@end

@implementation RZSimpleCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kRZCollectionViewCellReuseId];
    
    self.presentDismissInteractionController = [[RZOverscrollInteractionController alloc] init];
    [self.presentDismissInteractionController attachViewController:self withAction:RZTransitionAction_Present];
    [self.presentDismissInteractionController setDelegate:self];

    
    self.presentDismissAnimationController = [[RZZoomPushAnimationController alloc] init];
    self.presentDismissAnimationController.isForward = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    // TODO: ** Cannot set the scroll view delegate and the collection view delegate at the same time **
    [self.presentDismissInteractionController watchScrollView:self.collectionView];
}

#pragma mark - New VC Helper Methods

- (UIViewController *)newColorVCWithColor:(UIColor *)color
{
    RZSimpleColorViewController *newColorVC = [[RZSimpleColorViewController alloc] initWithColor:color];
    
    // TODO: Hook up next VC's dismiss transition
    // [self.presentDismissInteractionController attachViewController:newColorVC withAction:RZTransitionAction_Dismiss];
    
    [newColorVC setTransitioningDelegate:self];
    return newColorVC;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *cellBackgroundColor = [collectionView cellForItemAtIndexPath:indexPath].backgroundColor;
    UIViewController *colorVC = [self newColorVCWithColor:cellBackgroundColor];

    // Present or Push
    //[self presentViewController:colorVC animated:YES completion:nil];
    [self.navigationController pushViewController:colorVC animated:YES];
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
    return self.presentDismissAnimationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.presentDismissAnimationController;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.presentDismissInteractionController;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
//    return self.presentDismissInteractionController;
    return nil;
}

#pragma mark - RZTransitionInteractorDelegate

- (UIViewController *)nextViewControllerForInteractor:(id<RZTransitionInteractor>)interactor
{
    // TODO: ability to set the animation dismissal via the interaction
    // TODO: ability to associate interactor with a cell or optional data such as color or ID
    //self.presentDismissAnimationController.isDismissal = YES;
    
    return [self newColorVCWithColor:nil];
}

@end
