//
//  ContactPermission.swift
//  Permissions
//
//  Created by Abdulrasaq on 15/06/2022.
//

import Contacts
import Combine
import Foundation

public class ContactPermission : ObservableObject {
    var subscription = Set<AnyCancellable>()
    let contactStore = CNContactStore()
    @Published public var invalidPermission: Bool = false
    
    public init(){}
    
    private var authorizationStatus: AnyPublisher<CNAuthorizationStatus, Never> {
      Future<CNAuthorizationStatus, Never> { promise in
        self.contactStore.requestAccess(for: .contacts) { (_, _) in
          let status = CNContactStore.authorizationStatus(for: .contacts)
          promise(.success(status))
        }
      }
      .eraseToAnyPublisher()
    }
    
    public func requestAccess() {
      self.authorizationStatus
        .receive(on: RunLoop.main)
        .map { $0 == .denied || $0 == .restricted }
        .assign(to: \.invalidPermission, on: self)
        .store(in: &subscription)
    }
}
