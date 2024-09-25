//
//  Date+Formatted.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/25.
//

import Foundation

extension Date {
    func formatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
