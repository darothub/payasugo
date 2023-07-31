//
//  FirebaseDatabaseManager.swift
//
//
//  Created by Abdulrasaq on 20/07/2023.
//

import FirebaseDatabase
import Firebase
import Foundation
import class Foundation.Bundle
public class FirebaseDatabaseManager: ObservableObject {
    let baseRequest: BaseRequest = .shared
    let ref = Database.database().reference()
    public init() {
        //
    }
    public func handleAuthCredentials() {
        ref.child("app_data").observe(.value) { snapshot in
            for childSnapshot in snapshot.children {
                if let childSnapshot = childSnapshot as? DataSnapshot,
                   let value = childSnapshot.value as? [String: Any],
                   let clientId = value["client_id"] as? String,
                   let clientSecret = value["client_secret"] as? String,
                   let fetchTokenUrl = value["fetch_token_url"] as? String,
                   let processUrl = value["process_request_url"] as? String
                {
                    AppStorageManager.setAuthClientId(clientId)
                    AppStorageManager.setAuthClientSecret(clientSecret)
                    AppStorageManager.setFetchTokenUrl(fetchTokenUrl)
                    AppStorageManager.setProcessRequestUrl(processUrl)
                    
                    Task {
                       let token = try await TinggAuth.performBasicAuthentication(clientId, clientSecret, fetchTokenUrl)
                       AppStorageManager.setToken(token)
                    }
                }
            }
        }
    }

}



