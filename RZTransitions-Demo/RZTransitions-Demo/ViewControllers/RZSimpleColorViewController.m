//
//  RZSimpleColorViewController.m
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/3/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZSimpleColorViewController.h"
#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZTransitionInteractionControllerProtocol.h"
#import "UIColor+Random.h"

@interface RZSimpleColorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) id<RZTransitionInteractionController> dismissInteractionController;
@property (nonatomic, strong) RZSegmentControlMoveFadeAnimationController *dismissAnimationController;

@end

@implementation RZSimpleColorViewController

- (id)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        if (color) {
            _backgroundColor = color;
        }
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
        _backgroundColor = [UIColor randomColor];
    }
    return _backgroundColor;
}

#pragma mark - Handle Tap Genture Reconizer

- (void)dismissSelfOnTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
