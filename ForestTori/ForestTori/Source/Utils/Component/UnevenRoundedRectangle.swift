//
//  UnevenRoundedRectangle.swift
//  ForestTori
//
//  Created by hyebin on 5/20/24.
//

import SwiftUI

struct UnevenRoundedRectangle: Shape {
    var topLeadingRadius: CGFloat
    var topTrailingRadius: CGFloat
    var bottomLeadingRadius: CGFloat
    var bottomTrailingRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let topLeading = min(min(topLeadingRadius, rect.width / 2), rect.height / 2)
        let topTrailing = min(min(topTrailingRadius, rect.width / 2), rect.height / 2)
        let bottomLeading = min(min(bottomLeadingRadius, rect.width / 2), rect.height / 2)
        let bottomTrailing = min(min(bottomTrailingRadius, rect.width / 2), rect.height / 2)

        path.move(to: CGPoint(x: rect.minX + topLeading, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topTrailing, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - topTrailing, y: rect.minY + topTrailing),
                    radius: topTrailing,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomTrailing))
        path.addArc(center: CGPoint(x: rect.maxX - bottomTrailing, y: rect.maxY - bottomTrailing),
                    radius: bottomTrailing,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + bottomLeading, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bottomLeading, y: rect.maxY - bottomLeading),
                    radius: bottomLeading,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeading))
        path.addArc(center: CGPoint(x: rect.minX + topLeading, y: rect.minY + topLeading),
                    radius: topLeading,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)

        return path
    }
}
