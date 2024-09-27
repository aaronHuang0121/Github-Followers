//
//  PreviewContainer.swift
//  Github Followers
//
//  Created by Aaron on 2024/9/27.
//

import Foundation
import UIKit
import SwiftUI

struct PreviewContainer<T: UIView>: UIViewRepresentable {
    let view: T

    init(_ viewBuilder: @escaping () -> T) {
        self.view = viewBuilder()
    }

    func makeUIView(context: Context) -> T {
        return view
    }

    func updateUIView(_ uiView: T, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
