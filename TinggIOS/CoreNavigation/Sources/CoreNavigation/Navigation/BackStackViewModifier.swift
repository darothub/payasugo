//
//  NavigationBackStackViewModifier.swift
//  
//
//  Created by Abdulrasaq on 14/07/2023.
//

import Foundation
import SwiftUI

public extension View {
    func navigationBarBackButton<T: NavigationProtocol>(navigation: T, action:  (() -> Void)? = nil) -> some View {
        self.modifier(NavigationBackStackViewModifier(navigation: navigation, action: action))
    }
}

struct NavigationBackStackViewModifier<T: NavigationProtocol>: ViewModifier {
    var navigation: T
    var action:  (() -> Void)?
    init(navigation: T, action: (() -> Void)? = nil) {
        self.navigation = navigation
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                Button(action : {
                    guard let action = action else {
                        return navigation.goBack()
                    }
                    action()
                }){
                    HStack {
                       Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                }
            )
           
    }
}

 
