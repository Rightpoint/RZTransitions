//
//  RZSimpleCollectionViewController.h
//  RZTransitions-Demo
//
//  Created by Stephen Barnes on 12/11/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RZSimpleCollectionViewController : UIViewController
    <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
