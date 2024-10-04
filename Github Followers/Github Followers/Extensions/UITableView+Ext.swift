//
//  UITableView+Ext.swift
//  Github Followers
//
//  Created by Aaron on 2024/10/4.
//

import UIKit

extension UITableView {
    func removeExcessCells() {
        tableFooterView =  UITableView(frame: .zero)
    }

    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
}
