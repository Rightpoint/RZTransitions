<p align="center">
<img src="https://raw.github.com/Raizlabs/RZTransitions/master/Web/RZTransitions.png" alt="RZTransitions" width="763" height="200" />
</p>

[![Build Status](https://travis-ci.org/Raizlabs/RZTransitions.svg)](https://travis-ci.org/Raizlabs/RZTransitions)

============

<h3 align="center">RZTransitions is a library to help make iOS7 custom View Controller transitions slick and simple.</h3>
<p align="center" >
<br/>
<img src="http://raw.github.com/Raizlabs/RZTransitions/master/Web/RZTransitionsDemo.gif" alt="Overview" />
<br/>
</p>

## Installation

### CocoaPods (Recommended)

Add the following to your Podfile:

`pod 'RZTransitions', '~> 1.0'`

RZTransitions follows semantic versioning conventions. Check the [releases page](https://github.com/Raizlabs/RZTransitions/releases) for the latest updates and version history. 

### Manual Installation

Copy and add all of the files in the `RZTransitions` directory (and its subdirectories) into your project.

## Setting a New Default Transition

```objective-c
id<RZAnimationControllerProtocol> presentDismissAnimationController = [[RZZoomAlphaAnimationController alloc] init];
id<RZAnimationControllerProtocol> pushPopAnimationController = [[RZCardSlideAnimationController alloc] init];
[[RZTransitionsManager shared] setDefaultPresentDismissAnimationController:presentDismissAnimationController];
[[RZTransitionsManager shared] setDefaultPushPopAnimationController:pushPopAnimationController];
```

When Presenting a View Controller

```objective-c
[self setTransitioningDelegate:[RZTransitionsManager shared]];
UIViewController *nextViewController = [[UIViewController alloc] init];
[nextViewController setTransitioningDelegate:[RZTransitionsManager shared]];
[self presentViewController:nextViewController animated:YES completion:nil];
```

When creating a Navigation Controller ( **or** use RZTransitionsNavigationController )

```objective-c
UINavigationController *navigationController = [[UINavigationController alloc] init];
[navigationController setDelegate:[RZTransitionsManager shared]];
```

## Specifying Transitions for Specific View Controllers

```objective-c
// Use the RZZoomPushAnimationController when pushing from this view controller to a
// RZSimpleCollectionViewController or popping from a RZSimpleCollectionViewController to
// this view controller.
[[RZTransitionsManager shared] setAnimationController:[[RZZoomPushAnimationController alloc] init]
                                   fromViewController:[self class]
                                     toViewController:[RZSimpleCollectionViewController class]
                                            forAction:RZTransitionAction_PushPop];
```

## Hooking up Interactors

```objective-c
@property (nonatomic, strong) id<RZTransitionInteractionController> presentInteractionController;

- (void)viewDidLoad
{
	// Create the presentation interaction controller that allows a custom gesture
	// to control presenting a new VC via a presentViewController
   self.presentInteractionController = [[RZVerticalSwipeInteractionController alloc] init];
   [self.presentInteractionController setNextViewControllerDelegate:self];
   [self.presentInteractionController attachViewController:self withAction:RZTransitionAction_Present];
}

- (void)viewWillAppear:(BOOL)animated
{
	//  Use the present interaction controller for presenting any view controller from this view controller
   [[RZTransitionsManager shared] setInteractionController:self.presentInteractionController
                                        fromViewController:[self class]
                                          toViewController:nil
                                                 forAction:RZTransitionAction_Present];
}
```

## Features

 - A comprehensive library of animation controllers
 - A comprehensive library of interaction controllers
 - Mix and match any animation controller with any interaction controller
 - A shared instance manager that helps wrap the iOS7 custom transition protocol to expose a friendlier API
 
You can use any of the animation controllers or interaction controllers without the RZTransitionsManager and simply use them with the iOS7 custom View Controller transition APIs.

## License
RZTransitions is distributed under an [MIT License](http://opensource.org/licenses/MIT). See the LICENSE file for more details.

```
Copyright (c) 2014 Raizlabs and other contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
