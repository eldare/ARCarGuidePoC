//
//  DetailsViewController.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 04/10/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    private var titleText: String!
    private var bodyText: String!

    func set(titleText: String, bodyText: String) {
        self.titleText = titleText
        self.bodyText = bodyText
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        bodyTextView.text = bodyText
    }

    @IBAction private func closePressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
