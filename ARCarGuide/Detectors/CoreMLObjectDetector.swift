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

struct DetectorResult {
    var identifier: String
    var confidence: Float
    var boundingBox: CGRect
}

class CoreMLObjectDetector {
    typealias SearchCompletion = (_ results: [DetectorResult], _ arFrame: ARFrame) -> Void

    private var mlModel: MLModel
    private var searchCompleted: SearchCompletion
    private let serialQueue: DispatchQueue = {
        let date = Date().description
        let queue = DispatchQueue(label: "modelDetection_\(date)",
                                  qos: .userInteractive)
        return queue
    }()
    private var vnRequests = [VNRequest]()
    private var inProcessARFrame: ARFrame?

    init(mlModel: MLModel, searchCompleted: @escaping SearchCompletion) {
        self.mlModel = mlModel
        self.searchCompleted = searchCompleted
        setupRequest()
    }

    func search(in arFrame: ARFrame) {
        guard inProcessARFrame == nil else {
            return
        }

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

                // DEV: incomplete - *ELDAR* - debug - with fixed image that is known to be good
//                if let cgImage = UIImage(named: "underHoodModelTest")?.cgImage {
//                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//                    try requestHandler.perform(self.vnRequests)
//                }
            }
            catch {
                log.error("\(error)")
            }
        }
    }
}

extension CoreMLObjectDetector {
    private func setupRequest() {
        do {
            let vnModel = try VNCoreMLModel(for: mlModel)
            let coreMlRequest = VNCoreMLRequest(model: vnModel,
                                                completionHandler: { [weak self] in
                self?.requestCompletion(request: $0, error: $1)
            })
            vnRequests.append(coreMlRequest)

            // DEV: incomplete - *ELDAR* - debug - testing a well trained model
//            let coreMlRequest = VNRecognizeAnimalsRequest(completionHandler: { [weak self] in
//                self?.requestCompletion(request: $0, error: $1)
//            })
//            vnRequests.append(coreMlRequest)
        }
        catch {
            log.error("\(error)")
        }
    }

    private func requestCompletion(request: VNRequest, error: Error?) {
        var detectorResults = [DetectorResult]()

        defer {
            DispatchQueue.main.async { [weak self] in
                guard let inProcessARFrame = self?.inProcessARFrame else {
                    log.error("somehow inProcessARFrame is nil")
                    return
                }
                self?.searchCompleted(detectorResults, inProcessARFrame)
                self?.inProcessARFrame = nil
            }
        }

        // DEV: incomplete - *ELDAR* - debug
        if let error = error {
            print("\(error)")
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
