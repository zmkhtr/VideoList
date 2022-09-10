//
//  UIControl+TestHelpers.swift
//  VideoListTests
//
//  Created by PT.Koanba on 10/09/22.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
