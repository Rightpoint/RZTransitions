//
//  RZSimpleViewController.h
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/3/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RZSimpleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *popButton;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;
@property (weak, nonatomic) IBOutlet UIButton *modalButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionViewButton;

- (IBAction)pushNewViewController:(id)sender;
- (IBAction)popViewController:(id)sender;
- (IBAction)showModal:(id)sender;
- (IBAction)showCollectionView:(id)sender;
@end
