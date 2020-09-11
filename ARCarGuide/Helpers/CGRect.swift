//
//  CGRect.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 11/09/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

extension CGRect {
    var flippedCoordinates: CGRect {
        var flippedRect = self.applying(CGAffineTransform(scaleX: 1, y: -1))
        flippedRect = flippedRect.applying(CGAffineTransform(translationX: 0, y: 1))
        return flippedRect
    }
}
