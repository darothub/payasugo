//
//  PinIntroductionDialogView.swift
//  
//
//  Created by Abdulrasaq on 15/08/2023.
//
import CoreNavigation
import Core
import CoreUI
import SwiftUI

public struct PinIntroductionDialogView: View {
    @EnvironmentObject var navigation: NavigationManager
    @Binding var isPresented: Bool
    @State var checkedDontAskAgain = false
    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    public var body: some View {
        VStack(spacing: 1) {
            Group {
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                
                Text("Set up Security PIN?")
                    .foregroundColor(.green)
                Text("Your transactions and accounts will automatically be secured with your PIN")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }.padding(.bottom, 10)
            HStack(spacing: 0) {
                CheckBoxView(checkboxChecked: $checkedDontAskAgain)
                    .scaleEffect(0.7)
                Text("Don't ask again")
                    .font(.caption)
            }.padding(.bottom, 10)
            TinggOutlineButton(backgroundColor: .clear, buttonLabel: "Later", padding: 0, textColor: .black) {
                if checkedDontAskAgain {
                    withAnimation {
                        AppStorageManager.hasCheckedDontShowPinIntroductionAgain = checkedDontAskAgain
                        isPresented = false
                    }
                }
            }
            TinggOutlineButton(backgroundColor: .clear, buttonLabel: "Yes", padding: 0, textColor: .black) {
                withAnimation {
                    isPresented = false
                    navigation.navigateTo(screen: PinScreen.pinView)
                }
            }
        }.padding()
    }
}

#Preview {
    PinIntroductionDialogView(isPresented: .constant(true))
        .environmentObject(NavigationManager())
}
