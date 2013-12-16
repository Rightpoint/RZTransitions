//
//  RZOverscrollInteractionController.h
//  RZTransitions
//
//  Created by Stephen Barnes on 12/16/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZTransitionInteractionControllerProtocol.h"

@interface RZOverscrollInteractionController : UIPercentDrivenInteractiveTransition
<RZTransitionInteractionController, UIScrollViewDelegate>

@property(nonatomic, strong) UIViewController *fromViewController;

- (void)watchScrollView:(UIScrollView*)scrollView;
- (CGFloat)completionPercent;

@end
