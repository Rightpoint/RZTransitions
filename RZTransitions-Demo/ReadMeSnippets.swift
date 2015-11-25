//
//  ReadMeSnippets.swift
//  RZTransitions-Demo
//
//  Created by Eric Slosser on 11/24/15.
//  Copyright © 2015 Raizlabs. All rights reserved.
//

import UIKit

class Foo : UIViewController, RZTransitionInteractionControllerDelegate
{
    //5
    var presentInteractionController : RZTransitionInteractionController?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func snippets()
    {
        // 1
        RZTransitionsManager.shared().defaultPresentDismissAnimationController = RZZoomAlphaAnimationController()
        RZTransitionsManager.shared().defaultPushPopAnimationController = RZCardSlideAnimationController()

        // 2
        self.transitioningDelegate = RZTransitionsManager.shared()
        let nextViewController = UIViewController()
        nextViewController.transitioningDelegate = RZTransitionsManager.shared()
        self.presentViewController(nextViewController, animated:true) {}


        // 3
        let navigationController = UINavigationController()
        navigationController.delegate = RZTransitionsManager.shared()

        // 4
        RZTransitionsManager.shared().setAnimationController( RZZoomPushAnimationController(),
            fromViewController:self.dynamicType,
            toViewController:RZSimpleCollectionViewController.self,
            forAction:.PushPop)
    }
    // 5
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presentInteractionController = RZVerticalSwipeInteractionController()
        if let vc = self.presentInteractionController as? RZVerticalSwipeInteractionController {
            vc.nextViewControllerDelegate = self
            vc.attachViewController(self, withAction:.Present)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        RZTransitionsManager.shared().setInteractionController( self.presentInteractionController,
            fromViewController:self.dynamicType,
            toViewController:nil,
            forAction:.Present)
    }


}
