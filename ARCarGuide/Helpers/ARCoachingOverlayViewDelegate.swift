//
//  ARCoachingOverlayViewDelegate.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 11/09/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import ARKit

extension ARCoachingOverlayViewDelegate where Self: UIViewController {
    func setupCoachingOverlay(with arSession: ARSession,
                              goal: ARCoachingOverlayView.Goal = .anyPlane) {
        log.info("preparing coaching")
        let coachingOverlay = ARCoachingOverlayView()

        coachingOverlay.session = arSession
        coachingOverlay.delegate = self

        view.addSubview(coachingOverlay)

        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])

        coachingOverlay.activatesAutomatically = true
        coachingOverlay.goal = goal
    }
}
