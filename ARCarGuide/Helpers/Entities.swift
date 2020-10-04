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

class GuideEntity: Entity, HasAnchoring, HasCollision {
    func add(children: [Entity]) {
        children.forEach { addChild($0) }
//        collision = CollisionComponent(shapes: [.generateBox(size: [0.5, 0.5, 0.5])])
    }
}

extension Entity {
    func position(with transformWith: simd_float4x4) {
        let newPosition: SIMD3<Float> = [
            transformWith.columns.3.x,
            transformWith.columns.3.y,
            transformWith.columns.3.z
        ]
        position = newPosition
    }

    func look(at targetPosition: SIMD3<Float>) {
        look(at: targetPosition,
             from: position(relativeTo: nil),
             relativeTo: nil)
    }
}
