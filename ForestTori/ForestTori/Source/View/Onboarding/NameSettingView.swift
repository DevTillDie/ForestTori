//
//  NameSettingView.swift
//  ForestTori
//
//  Created by Nayeon Kim on 2/18/24.
//

import SwiftUI

struct NameSettingView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    @State var name = ""
    @State var isNameAvailable = false
    @State var isNameLong = false
    @Binding var isCompleted: Bool
    @Binding var isPresented: Bool
    @Binding var textIndex: Int
    
    private let doneButtonLabel = "이름 알려주기"
    private let myNameIsText = "내 이름은"
    private let placeholder = "이름을 입력하세요."
    private let toriText = "토리"
    private let warningDescription = "8자 이하만 가능해요."
    
    var body: some View {
        ZStack {
            Color.yellowTertiary
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text(myNameIsText)
                    .font(.subtitleS)
                    .foregroundColor(.brownPrimary)
                
                HStack {
                    VStack(spacing: 0) {
                        TextField(placeholder, text: $name)
                            .accentColor(.greenSecondary)
                            .onChange(of: name) { _ in
                                checkNameAvailable(name)
                                checkNameLength(name)
                            }
                        Rectangle()
                            .frame(height: 2)
                    }
                    .foregroundColor(setNameColor())
                    
                    Text(toriText)
                        .foregroundColor(.brownPrimary)
                }
                .font(.titleXL)
                
                Text(warningDescription)
                    .font(.bodyXS)
                    .foregroundColor(.redPrimary)
                    .hidden(isNameLong)
                
            }
            .padding(80)
            
            VStack {
                Spacer()
                
                OnboardingDoneButton(action: completeSetting, label: doneButtonLabel)
                    .font(.titleL)
                    .foregroundColor(setButtonLabelColor())
                    .background {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(setButtonBackgroundColor())
                            .overlay {
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(setButtonBackgroundStroke(), lineWidth: 2
                                    )
                            }
                    }
            }
            .padding(20)
        }
    }
}

// MARK: - functions

extension NameSettingView {
    private func checkNameAvailable(_ name: String) {
        if !name.isEmpty && name.count < 9 {
            isNameAvailable = true
        } else {
            isNameAvailable = false
        }
    }
    
    private func checkNameLength(_ name: String) {
        if name.count >= 9 {
            self.name = String(name.prefix(9))
            isNameLong = true
        } else {
            isNameLong = false
        }
    }
    
    private func completeSetting() {
        onboardingViewModel.setUserName(name)
        isCompleted = true
        
        withAnimation(.easeInOut(duration: 1)) {
            isPresented = false
            isCompleted = true
            textIndex += 1
        }
    }
}

// MARK: - UI

extension NameSettingView {
    private func setButtonBackgroundColor() -> Color {
        return isCompleted ? .greenSecondary : isNameAvailable ? .brownPrimary : .clear
    }
    
    private func setButtonBackgroundStroke() -> Color {
        return isNameAvailable ? .clear : .brownPrimary
    }
    
    private func setButtonLabelColor() -> Color {
        return isNameAvailable ? .yellowTertiary : .brownPrimary
    }
    
    private func setNameColor() -> Color {
        return isNameAvailable ? .greenSecondary : isNameLong ? .redPrimary : .brownPrimary
    }
}

#Preview {
    NameSettingView(isCompleted: .constant(false), isPresented: .constant(true), textIndex: .constant(0))
}
