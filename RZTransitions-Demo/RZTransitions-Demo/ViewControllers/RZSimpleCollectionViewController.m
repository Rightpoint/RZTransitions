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
#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZRectZoomAnimationController.h"
#import "RZTransitionsManager.h"

#import "UIColor+Random.h"

#define kRZCollectionViewCellReuseId  @"kRZCollectionViewCellReuseId"
#define kRZCollectionViewNumCells     50
#define kRZCollectionViewCellSize     88

@interface RZSimpleCollectionViewController () < UIViewControllerTransitioningDelegate,
                                                 RZTransitionInteractionControllerDelegate,
                                                 RZRectZoomAnimationDelegate >

@property (nonatomic, assign) CGPoint                           circleTransitionStartPoint;
@property (nonatomic, assign) CGRect                            transitionCellRect;
@property (nonatomic, strong) RZOverscrollInteractionController *presentOverscrollInteractor;
@property (nonatomic, strong) RZRectZoomAnimationController     *presentDismissAnimationController;

@end

@implementation RZSimpleCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kRZCollectionViewCellReuseId];
    
    // TODO: Currently the RZOverscrollInteractor will take over the collection view's delegate, meaning that ```didSelectItemAtIndexPath:```
    // will not be forwarded back.  RZOverscrollInteractor requires a bit of a rewrite to use KVO instead of delegation to address this.
//    self.presentOverscrollInteractor = [[RZOverscrollInteractionController alloc] init];
//    [self.presentOverscrollInteractor attachViewController:self withAction:RZTransitionAction_Present];
//    [self.presentOverscrollInteractor setNextViewControllerDelegate:self];
//    [[RZTransitionsManager shared] setInteractionController:self.presentOverscrollInteractor
//                                         fromViewController:[self class]
//                                           toViewController:nil
//                                                  forAction:RZTransitionAction_Present];
    
    self.presentDismissAnimationController = [[RZRectZoomAnimationController alloc] init];
    [self.presentDismissAnimationController setRectZoomDelegate:self];
    
    self.circleTransitionStartPoint = CGPointZero;
    self.transitionCellRect = CGRectZero;
    
    [[RZTransitionsManager shared] setAnimationController:self.presentDismissAnimationController
                                       fromViewController:[self class]
                                                forAction:RZTransitionAction_PresentDismiss];
    
    [self setTransitioningDelegate:[RZTransitionsManager shared]];
}

- (void)viewDidAppear:(BOOL)animated
{
    // TODO: ** Cannot set the scroll view delegate and the collection view delegate at the same time **
//    [self.presentOverscrollInteractor watchScrollView:self.collectionView];
}

#pragma mark - New VC Helper Methods

- (UIViewController *)newColorVCWithColor:(UIColor *)color
{
    RZSimpleColorViewController *newColorVC = [[RZSimpleColorViewController alloc] initWithColor:color];
	[newColorVC setTransitioningDelegate:[RZTransitionsManager shared]];
    
    // TODO: Hook up next VC's dismiss transition	
    return newColorVC;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *cellBackgroundColor = [collectionView cellForItemAtIndexPath:indexPath].backgroundColor;
    UIViewController *colorVC = [self newColorVCWithColor:cellBackgroundColor];
    
    self.circleTransitionStartPoint = [collectionView convertPoint:[collectionView cellForItemAtIndexPath:indexPath].center toView:self.view];;
    self.transitionCellRect = [collectionView convertRect:[collectionView cellForItemAtIndexPath:indexPath].frame toView:self.view];
    
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

#pragma mark - RZTransitionInteractorDelegate

- (UIViewController *)nextViewControllerForInteractor:(id<RZTransitionInteractionController>)interactor
{
    return [self newColorVCWithColor:nil];
}

#pragma mark - RZRectZoomAnimationDelegate

- (CGRect)rectZoomPosition
{
    return self.transitionCellRect;
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
