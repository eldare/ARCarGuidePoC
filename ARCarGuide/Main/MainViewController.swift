//
//  MainViewController.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 08/09/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import ARKit
import RealityKit

class MainViewController: UIViewController {
    @IBOutlet var arView: ARView!

    private let viewModel = MainViewModel()

    private var isARReady = true
    private let processOnceEveryNumberOfCycles = 20
    private var cycleCounter = 0

    private var debugPointEntities = [String: PointEntity]()
}

// MARK: - life cycle
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupARSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCoachingOverlay(with: arView.session)
    }
}

// MARK: - AR setup
extension MainViewController {
    private func setupARSession() {
        setupARDebug()
        arView.session.delegate = self
        let arConfig = ARWorldTrackingConfiguration()
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            arConfig.frameSemantics.insert(.personSegmentationWithDepth)
        }
        arView.session.run(arConfig)
    }

    private func setupARDebug() {
//        arView.debugOptions = [.showFeaturePoints]
    }
}

// MARK: - ARSessionDelegate related
extension MainViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard isProcessARFrame() else { return }
        viewModel.process(arFrame: frame) { [weak self] result in
            switch result {
            case .success(let processResult):
                self?.successfulProcessResult(processResult)
            case .failure(let error):
                log.error("\(error)")
            }
        }
    }

    private func successfulProcessResult(_ processResult: ProcessResult) {
        let raycastResults = arView.session.raycast(processResult.raycastQuery)
        guard let first = raycastResults.first else {
            log.info("no raycast hit result")
            return
        }
        log.info("\tJACKPOT")

        let identifier = processResult.identifier
        if debugPointEntities[identifier] == nil {
            let newEntity = PointEntity(color: .yellow)
            debugPointEntities[identifier] = newEntity
            arView.scene.addAnchor(newEntity)
        }
        guard let entity = debugPointEntities[identifier] else { return }
        transformEntity(entity, with: first.worldTransform)
    }

    private func transformEntity(_ entity: Entity,
                                 with transform: simd_float4x4) {
        let position: SIMD3<Float> = [
            transform.columns.3.x,
            transform.columns.3.y,
            transform.columns.3.z
        ]
        entity.position = position
    }

    private func isProcessARFrame() -> Bool {
        guard isARReady else { return false }
        guard cycleCounter >= processOnceEveryNumberOfCycles else {
            // improves performance by allowing processing once every X number of cycles through ARKit session delegate
            cycleCounter += 1
            return false
        }
        cycleCounter = 0
        return true
    }
}

// MARK: - ARCoachingOverlayViewDelegate related
extension MainViewController: ARCoachingOverlayViewDelegate {
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        log.info("coaching started")
        isARReady = false
    }

    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        log.info("coaching done")
        isARReady = true
    }
}
