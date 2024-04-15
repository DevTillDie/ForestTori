//
//  GardenARViewModel.swift
//  ForestTori
//
//  Created by Nayeon Kim on 4/15/24.
//

import SwiftUI

class GardenARViewModel: ObservableObject {
    func captureScreen() -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return capturedImage
    }
}
