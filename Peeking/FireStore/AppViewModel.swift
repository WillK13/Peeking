//
//  AppViewModel.swift
//  Peeking
//
//  Created by Will kaminski on 7/8/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AppViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var shouldShowContentView: Bool = false

    func checkUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            isLoading = false
            shouldShowContentView = false
            return
        }

        let userDocument = Firestore.firestore().collection("users").document(userId)
        userDocument.getDocument { documentSnapshot, error in
            self.isLoading = false
            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                let data = documentSnapshot.data()
                let isProfileSetupComplete = data?["is_profile_setup_complete"] as? Bool ?? false
                self.shouldShowContentView = isProfileSetupComplete
            } else {
                self.shouldShowContentView = false
            }
        }
    }
}
