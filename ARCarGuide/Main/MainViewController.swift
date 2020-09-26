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
import Combine

class MainViewController: UIViewController {
    @IBOutlet var arView: ARView!

    private let viewModel = MainViewModel()

    private var isARReady = true
    private let processOnceEveryNumberOfCycles = 10
    private var cycleCounter = 0

    private var detectedEntities = [UnderHoodIdentifiers: Entity]()

    private let LogoScene: GuideScenes.Logo = {
        return try! GuideScenes.loadLogo()
    }()
    private let CoolerScene: GuideScenes.Cooler = {
        return try! GuideScenes.loadCooler()
    }()
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

// MARK: - ARSession related
extension MainViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        updateEntitiesToLookAtCamera()
        guard isProcessARFrame() else { return }
        process(frame: frame)
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

    private func updateEntitiesToLookAtCamera() {
        for (_, entity) in detectedEntities {
            let targetPosition = arView.cameraTransform.translation
            entity.look(at: targetPosition)
        }
    }
}

// MARK: frame processing related
extension MainViewController {
    private func process(frame: ARFrame) {
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
        guard let identifier = UnderHoodIdentifiers(rawValue: processResult.identifier) else {
            log.error("unsupported identifier: \(processResult.identifier)")
            return
        }

        guard detectedEntities[identifier] == nil else { return }

        let raycastResults = arView.session.raycast(processResult.raycastQuery)
        guard let firstRaycastResult = raycastResults.first else {
            log.info("no raycast hit result")
            return
        }

        let newEntity = prepareGuideEntity(identifier: identifier)
        detectedEntities[identifier] = newEntity
        newEntity.position(with: firstRaycastResult.worldTransform)
        arView.scene.addAnchor(newEntity)
    }

    private func prepareGuideEntity(identifier: UnderHoodIdentifiers) -> GuideEntity {
        let newEntity = GuideEntity()
        switch identifier {
        case .cooler:
            newEntity.add(children: CoolerScene.coolerEntities)
        case .logo:
            newEntity.add(children: LogoScene.logoEntities)
        }
        return newEntity
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
