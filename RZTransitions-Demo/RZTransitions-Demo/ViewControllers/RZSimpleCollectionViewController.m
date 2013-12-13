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
#import "RZPinchInteration.h"
#import "RZShrinkZoomAnimationController.h"
#import "RZZoomBlurAnimationController.h"

#define kRZCollectionViewCellReuseId  @"kRZCollectionViewCellReuseId"
#define kRZCollectionViewNumCells     50;

@interface RZSimpleCollectionViewController ()
<UIViewControllerTransitioningDelegate, RZTransitionInteractorDelegate>

@property (nonatomic, strong) id<RZTransitionInteractor> presentDismissInteractionController;
@property (nonatomic, strong) RZZoomBlurAnimationController *presentDismissAnimationController;

@end

@implementation RZSimpleCollectionViewController

+ (UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kRZCollectionViewCellReuseId];
    
    self.presentDismissInteractionController = [[RZPinchInteration alloc] init];
    [self.presentDismissInteractionController attachViewController:self withAction:RZTransitionAction_Present];
    [self.presentDismissInteractionController setDelegate:self];
    
    self.presentDismissAnimationController = [[RZZoomBlurAnimationController alloc] init];
    self.presentDismissAnimationController.isDismissal = NO;
}

#pragma mark - New VC Helper Methods

- (UIViewController *)newColorVCWithColor:(UIColor *)color
{
    RZSimpleColorViewController *newColorVC = [[RZSimpleColorViewController alloc] initWithColor:color];
//    [self.presentDismissInteractionController attachViewController:newColorVC withAction:RZTransitionAction_Dismiss];
    [newColorVC setTransitioningDelegate:self];
    return newColorVC;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *cellBackgroundColor = [collectionView cellForItemAtIndexPath:indexPath].backgroundColor;
    UIViewController *colorVC = [self newColorVCWithColor:cellBackgroundColor];
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
    [cell setBackgroundColor:[RZSimpleCollectionViewController randomColor]];
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
    return self.presentDismissInteractionController;
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
