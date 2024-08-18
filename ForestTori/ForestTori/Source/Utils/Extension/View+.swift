//
//  View+.swift
//  ForestTori
//
//  Created by hyebin on 2/17/24.
//

import SwiftUI

// MARK: - View

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 1 : 0)
    }
    
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
    
    func snapshot() -> UIImage {
            let controller = UIHostingController(rootView: self)
            let view = controller.view

            let targetSize = CGSize(width: 350, height: 466)
            view?.bounds = CGRect(origin: .zero, size: targetSize)
            view?.backgroundColor = .clear

            let renderer = UIGraphicsImageRenderer(size: targetSize)

            return renderer.image { _ in
                view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
        }
}
