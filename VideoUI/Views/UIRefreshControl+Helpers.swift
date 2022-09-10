//
//  UIRefreshControl+Helpers.swift
//  VideoUI
//
//  Created by PT.Koanba on 10/09/22.
//


import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
