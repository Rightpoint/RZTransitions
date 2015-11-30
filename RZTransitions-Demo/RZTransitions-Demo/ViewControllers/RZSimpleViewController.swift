//
//  RZSimpleViewController.swift
//  RZTransitions-Demo
//
//  Created by Eric Slosser on 11/13/15.
//  Copyright 2015 Raizlabs and other contributors
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

import UIKit

@objc(RZSimpleViewController)
final class RZSimpleViewController: UIViewController
{
    @IBOutlet weak var popButton: UIButton?
    @IBOutlet weak var pushButton: UIButton?
    @IBOutlet weak var modalButton: UIButton?
    @IBOutlet weak var collectionViewButton: UIButton?

    var pushPopInteractionController: RZTransitionInteractionController?
    var presentInteractionController: RZTransitionInteractionController?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the push and pop interaction controller that allows a custom gesture
        // to control pushing and popping from the navigation controller
        pushPopInteractionController = RZHorizontalInteractionController()
        if let vc = pushPopInteractionController as? RZHorizontalInteractionController {
            vc.nextViewControllerDelegate = self
            vc.attachViewController(self, withAction: .PushPop)
            RZTransitionsManager.shared().setInteractionController( vc, fromViewController:self.dynamicType, toViewController:nil, forAction: .PushPop);
        }

        // Create the presentation interaction controller that allows a custom gesture
        // to control presenting a new VC via a presentViewController
        presentInteractionController = RZVerticalSwipeInteractionController()
        if let vc = presentInteractionController as? RZVerticalSwipeInteractionController {
            vc.nextViewControllerDelegate = self;
            vc.attachViewController(self, withAction:.Present);
        }

        // Setup the push & pop animations as well as a special animation for pushing a
        // RZSimpleCollectionViewController
        RZTransitionsManager.shared().setAnimationController( RZCardSlideAnimationController(),
            fromViewController:self.dynamicType,
            forAction:.PushPop);

        RZTransitionsManager.shared().setAnimationController( RZZoomPushAnimationController(),
            fromViewController:self.dynamicType,
            toViewController:RZSimpleCollectionViewController.self,
            forAction:.PushPop);

        // Setup the animations for presenting and dismissing a new VC
        RZTransitionsManager.shared().setAnimationController( RZCirclePushAnimationController(),
            fromViewController:self.dynamicType,
            forAction:.PresentDismiss);
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        RZTransitionsManager.shared().setInteractionController( presentInteractionController,
            fromViewController:self.dynamicType,
            toViewController:nil,
            forAction:.Present);
    }
}

// MARK: - Actions
extension RZSimpleViewController {

    @IBAction func pushNewViewController(_: AnyObject) {
        navigationController?.pushViewController(nextSimpleViewController(), animated:true);
    }

    @IBAction func popViewController(_: AnyObject) {
        navigationController?.popViewControllerAnimated(true);
    }

    @IBAction func showModal(_: AnyObject) {
        presentViewController(nextSimpleColorViewController(), animated:true, completion:({}));
    }

    @IBAction func showCollectionView(_: AnyObject) {
        navigationController?.pushViewController(RZSimpleCollectionViewController(), animated:true);
    }

}

// MARK: - RZTransitionInteractionControllerDelegate

extension RZSimpleViewController: RZTransitionInteractionControllerDelegate {

    func nextSimpleViewController() -> UIViewController {
        let newVC = RZSimpleViewController()
        newVC.transitioningDelegate = RZTransitionsManager.shared()
        return newVC;
    }

    func nextSimpleColorViewController() -> UIViewController {
        let newColorVC = RZSimpleColorViewController()
        newColorVC.transitioningDelegate = RZTransitionsManager.shared()

        // Create a dismiss interaction controller that will be attached to the presented
        // view controller to allow for a custom dismissal
        let dismissInteractionController = RZVerticalSwipeInteractionController()
        dismissInteractionController.attachViewController(newColorVC, withAction:.Dismiss)
        RZTransitionsManager.shared().setInteractionController(dismissInteractionController,
            fromViewController:self.dynamicType,
            toViewController:nil,
            forAction:.Dismiss)
        return newColorVC
    }

    func nextViewControllerForInteractor(interactor: RZTransitionInteractionController) -> UIViewController {
        if (interactor is RZVerticalSwipeInteractionController) {
            return nextSimpleColorViewController();
        }
        else {
            return nextSimpleViewController();
        }
    }

}
