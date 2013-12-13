//
//  RZSimpleColorViewController.m
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/3/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZSimpleColorViewController.h"
#import "RZCardSlideAnimationController.h"
#import "RZShrinkZoomAnimationController.h"
#import "RZZoomBlurAnimationController.h"
#import "RZZoomPushAnimationController.h"
#import "RZHorizontalTransitionInteractor.h"
#import "RZSegmentControlMoveFadeAnimationController.h"
#import "RZTransitionInteractorProtocol.h"

@interface RZSimpleColorViewController () //<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) id<RZTransitionInteractor> dismissInteractionController;
@property (nonatomic, strong) RZSegmentControlMoveFadeAnimationController *dismissAnimationController;

@end

@implementation RZSimpleColorViewController

+ (UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (id)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.backgroundColor = color;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:self.backgroundColor];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelfOnTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Overidden Properties

- (UIColor *)backgroundColor
{
    if (!_backgroundColor) {
        _backgroundColor = [RZSimpleColorViewController randomColor];
    }
    return _backgroundColor;
}

#pragma mark - Handle Tap Genture Reconizer

- (void)dismissSelfOnTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
