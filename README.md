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

`pod 'RZTransitions'`

RZTransitions follows semantic versioning conventions. Check the [releases page](https://github.com/Raizlabs/RZTransitions/releases) for the latest updates and version history.

### Manual Installation

Copy and add all of the files in the `RZTransitions` directory (and its subdirectories) into your project.

## Setting a New Default Transition

<p align="right">Swift</p>
```Swift
RZTransitionsManager.shared().defaultPresentDismissAnimationController = RZZoomAlphaAnimationController()
RZTransitionsManager.shared().defaultPushPopAnimationController = RZCardSlideAnimationController()
```

<p align="right">Objective C</p>
```objective-c
id<RZAnimationControllerProtocol> presentDismissAnimationController = [[RZZoomAlphaAnimationController alloc] init];
id<RZAnimationControllerProtocol> pushPopAnimationController = [[RZCardSlideAnimationController alloc] init];
[[RZTransitionsManager shared] setDefaultPresentDismissAnimationController:presentDismissAnimationController];
[[RZTransitionsManager shared] setDefaultPushPopAnimationController:pushPopAnimationController];
```

When Presenting a View Controller

<p align="right">Swift</p>
```Swift
self.transitioningDelegate = RZTransitionsManager.shared()
let nextViewController = UIViewController()
nextViewController.transitioningDelegate = RZTransitionsManager.shared()
self.presentViewController(nextViewController, animated:true) {}
```
<p align="right">Objective C</p>
```objective-c
[self setTransitioningDelegate:[RZTransitionsManager shared]];
UIViewController *nextViewController = [[UIViewController alloc] init];
[nextViewController setTransitioningDelegate:[RZTransitionsManager shared]];
[self presentViewController:nextViewController animated:YES completion:nil];
```

When creating a Navigation Controller ( **or** use RZTransitionsNavigationController )

<p align="right">Swift</p>
```Swift
let navigationController = UINavigationController()
navigationController.delegate = RZTransitionsManager.shared()
```
<p align="right">Objective C</p>
```objective-c
UINavigationController *navigationController = [[UINavigationController alloc] init];
[navigationController setDelegate:[RZTransitionsManager shared]];
```

## Specifying Transitions for Specific View Controllers

<p align="right">Swift</p>
```Swift
RZTransitionsManager.shared().setAnimationController( RZZoomPushAnimationController(),
    fromViewController:self.dynamicType,
    toViewController:RZSimpleCollectionViewController.self,
    forAction:.PushPop)
```
<p align="right">Objective C</p>
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

<p align="right">Swift</p>
```Swift
override func viewDidLoad() {
    super.viewDidLoad()

    self.presentInteractionController = RZVerticalSwipeInteractionController()
    if let vc = self.presentInteractionController as? RZVerticalSwipeInteractionController {
        vc.nextViewControllerDelegate = self
        vc.attachViewController(self, withAction:.Present)
    }
}

override func viewWillAppear(animated: Bool)
{
    super.viewWillAppear(animated)
    RZTransitionsManager.shared().setInteractionController( self.presentInteractionController,
        fromViewController:self.dynamicType,
        toViewController:nil,
        forAction:.Present)
}
```
<p align="right">Objective C</p>
```objective-c
@property (nonatomic, strong) id<RZTransitionInteractionController> presentInteractionController;

- (void)viewDidLoad
{
   [super viewDidLoad];
	// Create the presentation interaction controller that allows a custom gesture
	// to control presenting a new VC via a presentViewController
   self.presentInteractionController = [[RZVerticalSwipeInteractionController alloc] init];
   [self.presentInteractionController setNextViewControllerDelegate:self];
   [self.presentInteractionController attachViewController:self withAction:RZTransitionAction_Present];
}

- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
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

## Maintainers

[arrouse](https://github.com/arrouse) ([@arrouse88](http://twitter.com/arrouse88))

[nbonatsakis](https://github.com/nbonatsakis) ([@nickbona](http://twitter.com/nickbona))

[dostrander](https://github.com/dostrander) ([@_Derko](http://twitter.com/_Derko))

[markpragma](https://github.com/markpragma) ([@markpragma ](http://twitter.com/markpragma))

[rztakashi](https://github.com/rztakashi)

## Contributors

[smbarne](https://github.com/smbarne) ([@smbarne](http://twitter.com/smbarne))

## License

RZTransitions is licensed under the MIT license. See the `LICENSE` file for details.
