//
//  Entities.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 11/09/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import RealityKit

class PointEntity: Entity, HasModel, HasAnchoring {
    convenience init(color: UIColor) {
        self.init()
        model = ModelComponent(
            mesh: .generateSphere(radius: 0.05),
            materials: [
                SimpleMaterial(color: color, isMetallic: false)
            ]
        )
    }
}
