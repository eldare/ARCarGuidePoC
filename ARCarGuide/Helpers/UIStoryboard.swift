//
//  UIStoryboard.swift
//  ARCarGuide
//
//  Created by Eldar Eliav on 26/09/2020.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func loadVC(storyboardName: String = "Main", vcIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(identifier: vcIdentifier)
    }
}
