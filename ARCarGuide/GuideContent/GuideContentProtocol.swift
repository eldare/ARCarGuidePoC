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
    func load() -> GuideContentModel?
}

extension GuideContentProtocol {
    func load() -> GuideContentModel? {
        let resourceName = self.rawValue
        return Bundle.main.loadJsonResource(name: resourceName)
    }
}
