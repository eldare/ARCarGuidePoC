//
//  DetectorResult.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 11/09/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

struct DetectorResult {
    var identifier: String
    var confidence: Float
    var boundingBox: CGRect
}
