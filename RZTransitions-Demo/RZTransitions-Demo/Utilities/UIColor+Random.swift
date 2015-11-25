//
//  UIColor+Random.swift
//  RZTransitions-Demo
//
//  Created by Eric Slosser on 11/17/15.
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

import UIKit

extension UIColor {

    public class func randomColor() -> UIColor {
        let hue = CGFloat(arc4random_uniform(256)) / 256.0                  //  0.0 to 1.0
        let saturation = CGFloat(arc4random_uniform(128)) / 256.0 + 0.5     //  0.5 to 1.0, away from white
        let brightness = CGFloat(arc4random_uniform(128)) / 256.0 + 0.5     //  0.5 to 1.0, away from black
        return UIColor(hue:hue, saturation:saturation, brightness:brightness, alpha:1.0)
    }
}
