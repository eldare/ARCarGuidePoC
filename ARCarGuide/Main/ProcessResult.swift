//
//  ProcessResult.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 11/09/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import ARKit

struct ProcessResult {
    var identifier: String
    var boundingBox: CGRect
    var raycastQuery: ARRaycastQuery
}
