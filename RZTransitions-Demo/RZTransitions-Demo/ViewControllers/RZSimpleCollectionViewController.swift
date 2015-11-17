
//  RZSimpleCollectionViewController.swift
//  RZTransitions-Demo

//  Created by Eric Slosser on 11/16/15.
//  Copyright © 2015 Raizlabs and other contributors.
//  http://raizlabs.com/

//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:

//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import CoreGraphics
import UIKit

let kRZCollectionViewCellReuseId = "kRZCollectionViewCellReuseId"
let kRZCollectionViewNumCells = 50
let kRZCollectionViewCellSize: CGFloat = 88

class RZSimpleCollectionViewController: UIViewController
    , UICollectionViewDataSource
    , UICollectionViewDelegate
    , UIViewControllerTransitioningDelegate
    , RZTransitionInteractionControllerDelegate
    , RZCirclePushAnimationDelegate
    , RZRectZoomAnimationDelegate
{
    @IBOutlet weak var collectionView: UICollectionView?

    var circleTransitionStartPoint: CGPoint = CGPointZero
    var transitionCellRect: CGRect = CGRectZero
    var presentOverscrollInteractor: RZOverscrollInteractionController?
    var presentDismissAnimationController: RZRectZoomAnimationController?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier:kRZCollectionViewCellReuseId);

//     TODO: Currently the RZOverscrollInteractor will take over the collection view's delegate, meaning that ```didSelectItemAtIndexPath:```
//     will not be forwarded back.  RZOverscrollInteractor requires a bit of a rewrite to use KVO instead of delegation to address this.
//        self.presentOverscrollInteractor = [[RZOverscrollInteractionController alloc] init];
//        [self.presentOverscrollInteractor attachViewController:self withAction:RZTransitionAction_Present];
//        [self.presentOverscrollInteractor setNextViewControllerDelegate:self];
//        [[RZTransitionsManager shared] setInteractionController:self.presentOverscrollInteractor
//                                             fromViewController:[self class]
//                                               toViewController:nil
//                                                      forAction:RZTransitionAction_Present];

    self.presentDismissAnimationController = RZRectZoomAnimationController()
    self.presentDismissAnimationController?.rectZoomDelegate = self

    RZTransitionsManager.shared().setAnimationController( self.presentDismissAnimationController,
        fromViewController:self.dynamicType,
        forAction:.PresentDismiss )

    self.transitioningDelegate = RZTransitionsManager.shared()
    }

//    - (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    // TODO: ** Cannot set the scroll view delegate and the collection view delegate at the same time **
//    //    [self.presentOverscrollInteractor watchScrollView:self.collectionView];
//}

//MARK: - New VC Helper Methods

    func newColorVCWithColor(color: UIColor?) -> UIViewController
    {
        let newColorVC = RZSimpleColorViewController(color: color)
        newColorVC.transitioningDelegate = RZTransitionsManager.shared()

        // TODO: Hook up next VC's dismiss transition
        return newColorVC;
    }

//MARK: - UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)!
        let cellBackgroundColor = cell.backgroundColor;
        let colorVC = self.newColorVCWithColor(cellBackgroundColor!)

        self.circleTransitionStartPoint = collectionView.convertPoint(cell.center, toView:self.view)
        self.transitionCellRect = collectionView.convertRect(cell.frame, toView:self.view)

        // Present VC
        self.presentViewController(colorVC, animated:true) {}
    }

//MARK: - UICollectionViewDataSource

    func collectionView(collectionView:UICollectionView, numberOfItemsInSection section:NSInteger) -> NSInteger
    {
        return kRZCollectionViewNumCells
    }

    func collectionView(collectionView:UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kRZCollectionViewCellReuseId, forIndexPath:indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell;
    }

//MARK: - RZTransitionInteractionControllerDelegate

    func nextViewControllerForInteractor() -> UIViewController?
    {
        return self.newColorVCWithColor(nil);
    }

//MARK: - RZRectZoomAnimationDelegate

    func rectZoomPosition() -> CGRect
    {
        return self.transitionCellRect;
    }

//MARK: - RZCirclePushAnimationDelegate

    func circleCenter() -> CGPoint
    {
        return self.circleTransitionStartPoint;
    }

    func circleStartingRadius() -> CGFloat
    {
        return (kRZCollectionViewCellSize / 2.0);
    }

//@end

}