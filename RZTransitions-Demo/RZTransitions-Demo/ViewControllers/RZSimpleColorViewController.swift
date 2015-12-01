//
//  RZSimpleColorViewController.swift
//  RZTransitions-Demo
//
//  Created by Eric Slosser on 11/16/15.
//  Copyright © 2015 Raizlabs and other contributors
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

import Foundation
import UIKit

@objc(RZSimpleColorViewController)
final class RZSimpleColorViewController: UIViewController
{
    lazy var backgroundColor:  UIColor = UIColor.redColor()

    @IBOutlet weak var titleLabel: UILabel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(color: UIColor?) {
        super.init(nibName: nil, bundle: nil)
        if (color != nil) {
            backgroundColor = color!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:"dismissSelfOnTap:")
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    //MARK: - Handle Tap Gesture Recognizer

    @objc(dismissSelfOnTap:)
    func dismissSelfOnTap(tapGestureRecognizer: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}