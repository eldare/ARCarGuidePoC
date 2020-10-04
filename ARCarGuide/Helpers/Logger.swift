//
//  Logger.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 04/09/2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation

struct log {
    static func info(_ text: String) {
        print("[INFO] \(text)")
    }

    static func warning(_ text: String) {
        print("[WARNING] \(text)")
    }

    static func error(_ text: String) {
        print("[ERROR] \(text)")
    }
}
