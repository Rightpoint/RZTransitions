//
//  RZZoomBlurAnimatedTransitioning.h
//  RZTransitions
//
//  Created by Nick Donaldson on 10/17/13.
//  Copyright 2014 Raizlabs and other contributors
//  http://raizlabs.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIColor.h>

#import "RZAnimationControllerProtocol.h"

@interface RZZoomBlurAnimationController : NSObject <RZAnimationControllerProtocol>

/**
 *  The blur radius used when snapshotting to the fromView and applying a blur to it.
 *  see UIImage+RZTransitionsFastImageBlur for more info.
 *
 *  Default is 12.0f
 */
@property (assign, nonatomic) CGFloat blurRadius;

/**
 *  The saturation amount used when applying the blur to the snapshot.
 *  see UIImage+RZTransitionsFastImageBlur for more info.
 *
 *  Default is 1.0f
 */
@property (assign, nonatomic) CGFloat saturationDelta;

/**
 *  The tint color that is used when applying the blur to the snapshot.
 *  see UIImage+RZTransitionsFastImageBlur for more info.
 *
 *  Default is [UIColor colorWithWhite:1.0f alpha:0.15f]
 */
@property (strong, nonatomic) UIColor *blurTintColor;

@end
