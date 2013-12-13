//
//  RZSimpleColorViewController.h
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/3/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RZSimpleColorViewController : UIViewController

@property (nonatomic, strong) UIColor *backgroundColor;

- (id)initWithColor:(UIColor *)color;

@end
