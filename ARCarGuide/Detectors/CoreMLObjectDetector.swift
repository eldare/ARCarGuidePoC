//
//  CoreMLObjectDetector.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 04/09/2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import Vision
import ARKit
import CoreML

class CoreMLObjectDetector {
    typealias SearchCompletion = (_ results: [DetectorResult], _ arFrame: ARFrame) -> Void

    private var searchCompletion: SearchCompletion?
    private let serialQueue: DispatchQueue = {
        let date = Date().description
        let queue = DispatchQueue(label: "modelDetection_\(date)",
                                  qos: .userInteractive)
        return queue
    }()
    private var vnRequests = [VNRequest]()
    private var inProcessARFrame: ARFrame?

    /// use a custom `MLModel` to construct a `CoreMLRequest`
    init(mlModel: MLModel) {
        setupRequest(mlModel: mlModel)
    }

    /// use `VNImageBasedRequest` type to construct a Vision request
    init(requestType: VNImageBasedRequest.Type) {
        setupRequest(type: requestType)
    }

    /// search ARFrame with the initiated Vision request
    func search(in arFrame: ARFrame,
                completion: @escaping SearchCompletion) {
        guard inProcessARFrame == nil else {
            // progress only if no AR frame is being proccessed
            return
        }

        searchCompletion = completion

        serialQueue.async { [weak self] in
            guard let self = self else {
                log.error("self is nil")
                return
            }
            do {
                self.inProcessARFrame = arFrame
                let requestHandler = VNImageRequestHandler(cvPixelBuffer: arFrame.capturedImage,
                                                           options: [:])
                try requestHandler.perform(self.vnRequests)
            }
            catch {
                log.error(.init(describing: error))
            }
        }
    }
}

extension CoreMLObjectDetector {
    private func setupRequest(mlModel: MLModel) {
        do {
            let vnModel = try VNCoreMLModel(for: mlModel)
            let vnRequest = VNCoreMLRequest(model: vnModel,
                                            completionHandler: { [weak self] in
                self?.requestCompletion(request: $0, error: $1)
            })
            vnRequests.append(vnRequest)
        }
        catch {
            log.error(.init(describing: error))
        }
    }

    private func setupRequest(type preferedRequestType: VNImageBasedRequest.Type) {
        let vnRequest = preferedRequestType.init(completionHandler: { [weak self] in
            self?.requestCompletion(request: $0, error: $1)
        })
        vnRequests.append(vnRequest)
    }

    private func requestCompletion(request: VNRequest, error: Error?) {
        var detectorResults = [DetectorResult]()

        defer {
            DispatchQueue.main.async { [weak self] in
                guard let inProcessARFrame = self?.inProcessARFrame else {
                    log.error("somehow inProcessARFrame is nil")
                    return
                }
                self?.searchCompletion?(detectorResults, inProcessARFrame)
                self?.inProcessARFrame = nil
            }
        }

        if let error = error {
            log.error("\(error)")
        }

        guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
        detectorResults = results.compactMap { result in
            guard let bestLabelIdentifier = result.labels.first?.identifier else { return nil }
            let foundResult = DetectorResult(identifier: bestLabelIdentifier,
                                             confidence: result.confidence,
                                             boundingBox: result.boundingBox)
            return foundResult
        }
    }
}
