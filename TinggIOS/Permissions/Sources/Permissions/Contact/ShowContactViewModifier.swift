//
//  ShowContactViewModifier.swift
//
//
//  Created by Abdulrasaq on 05/08/2023.
//

import SwiftUI

public struct ShowContactViewModifier: ViewModifier {
    @Binding var showContact: Bool
    var completion: (ContactRow) -> Void
    var onFailure: (String) -> Void
    public init(showContact: Binding<Bool>, completion: @escaping (ContactRow) -> Void, onFailure: @escaping (String) -> Void) {
        self._showContact = showContact
        self.completion = completion
        self.onFailure = onFailure
    }
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showContact, content: {
                ContactRowView() { contact in
                    completion(contact)
                } onFailure: { err in
                    onFailure(err)
                }
            })
           
    }
}

extension View {
    public func showContactModifier(
        _ showContact: Binding<Bool>,
        completion: @escaping (ContactRow) -> Void,
        onFailure: @escaping (String) -> Void
    ) -> some View {
        modifier(ShowContactViewModifier(showContact: showContact, completion: completion, onFailure: onFailure))
    }
}
