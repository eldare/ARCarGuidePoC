//
//  Bundle.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 04/10/2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation

extension Bundle {
    func loadJsonResource<T: Decodable>(name: String) -> T? {
        guard let resourceURL = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: resourceURL) else {
            log.error("failed to load json resource `\(name)`")
            return nil
        }
        guard let model = try? JSONDecoder().decode(T.self, from: data) else {
            log.error("failed to decode data of json resource `\(name)`")
            return nil
        }
        return model
    }
}
