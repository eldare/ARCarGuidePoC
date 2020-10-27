//
//  MainViewModel.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 11/09/2020.
//  Copyright © 2020 none. All rights reserved.
//

import ARKit

final class MainViewModel {
    private let detector = UnderHoodDetector()

    func process(arFrame: ARFrame, completion: @escaping (Result<MainProcessResultModel, Error>) -> Void) {
        detector.search(in: arFrame, completion: { (results, arFrame) in
            results.forEach { result in
                let flippedBoundingBox = result.boundingBox.flippedCoordinates
                let centerPoint = CGPoint(x: flippedBoundingBox.midX, y: flippedBoundingBox.midY)
                let rayCastQuery = arFrame.raycastQuery(from: centerPoint,
                                                        allowing: .estimatedPlane,
                                                        alignment: .any)
                let processResult = MainProcessResultModel(identifier: result.identifier,
                                                           boundingBox: flippedBoundingBox,
                                                           raycastQuery: rayCastQuery)
                completion(.success(processResult))
            }
        })
    }

    func getMarkdownResourceURL(for entityName: EntityName) -> URL {
        switch entityName {
        case "logo":
            return UnderHoodIdentifiers.logo.loadMarkdownResource()
        case "coolant":
            return UnderHoodIdentifiers.coolant.loadMarkdownResource()
        default:
            fatalError()
        }
    }
}
