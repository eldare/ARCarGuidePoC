//
//  DetailsViewController.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 04/10/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class DetailsViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    private var attributedTextContent: NSAttributedString!

    func set(from markdownResourceURL: URL?) {
        guard let url = markdownResourceURL,
              let markdown = SwiftyMarkdown(url: url) else {
            log.error("failed to load markdown resource from url \(String(describing: markdownResourceURL))")
            return
        }
        markdown.body.alignment = .justified
        attributedTextContent = markdown.attributedString()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.attributedText = attributedTextContent
    }

    @IBAction private func closePressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
