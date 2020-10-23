//
//  GuideContentProtocol.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 04/10/2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation

protocol GuideContentProtocol {
    var rawValue: String { get }
    func loadMarkdownResource() -> URL
}

extension GuideContentProtocol {
    func loadMarkdownResource() -> URL {
        let resourceName = self.rawValue
        return Bundle.main.url(forResource: resourceName, withExtension: "md")!
    }
}
