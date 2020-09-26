//
//  UnderHoodDetector.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 05/09/2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import Vision

final class UnderHoodDetector: CoreMLObjectDetector {
    init() {
        let mlModel = Underhood().model
        super.init(mlModel: mlModel)
    }
}

enum UnderHoodIdentifiers: String, Hashable {
    case logo
    case cooler = "cool"
}
