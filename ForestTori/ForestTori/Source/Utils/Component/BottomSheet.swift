//
//  BottomSheet.swift
//  ForestTori
//
//  Created by hyebin on 4/29/24.
//

import SwiftUI

struct BottomSheet<Content>: View where Content: View {
    @Binding var isPresented: Bool
    
    var height: CGFloat
    var content: Content
    
    @State private var translation: CGFloat = .zero
    
    init(_ isPresented: Binding<Bool>, height: CGFloat, content: () -> Content) {
        self._isPresented = isPresented
        self.height = height
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundStyle(.gray)
                        .frame(width: 30, height: 5)
                )
            
            content
                .frame(height: height)
        }
        .frame(height: height + 30)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 16, topTrailingRadius: 16)
                .fill(.white)
                .edgesIgnoringSafeArea([.bottom, .horizontal])
        )
        .transition(.opacity.combined(with: .move(edge: .bottom)))
        .offset(y: translation)
        .gesture(
            DragGesture()
                .onChanged { value in
                    let translation = min(self.height, max(-self.height, value.translation.height))
                    self.translation = translation
                }
                .onEnded { value in
                    if value.translation.height >= height/5 {
                        self.isPresented = false
                    }

                    self.translation = .zero
                }
        )
    }
}