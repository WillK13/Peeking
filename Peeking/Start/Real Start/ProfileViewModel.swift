//
//  ProfileViewModel.swift
//  Peeking
//
//  Created by Will kaminski on 7/6/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var userID: String?
    @Published var dbUser: DBUser?
    @Published var isProfileCreated: Bool = false
    @Published var isLoading: Bool = true
    private let userManager = UserManager()

    init() {
        loadCurrentUser()
    }

    func loadCurrentUser() {
        if let user = Auth.auth().currentUser {
            self.userID = user.uid
            Task {
                do {
                    let userExists = try await userManager.checkUserExists(userId: user.uid)
                    if userExists {
                        fetchUserFromFirestore(userId: user.uid)
                    } else {
                        createUserInFirestore(userId: user.uid)
                    }
                    self.isLoading = false
                } catch {
                    print("Failed to check if user exists: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        } else {
            self.isLoading = false
        }
    }

    private func createUserInFirestore(userId: String) {
        let dbUser = DBUser(id: nil, userId: userId, dateCreated: Timestamp(), isProfileSetupComplete: false)
        
        Task {
            do {
                try await userManager.createNewUser(user: dbUser)
                print("User created successfully in Firestore.")
                self.dbUser = dbUser
                self.isProfileCreated = dbUser.isProfileSetupComplete
            } catch {
                print("Failed to create user in Firestore: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchUserFromFirestore(userId: String) {
        Task {
            do {
                let fetchedUser = try await userManager.getUser(userId: userId)
                DispatchQueue.main.async {
                    self.dbUser = fetchedUser
                    self.isProfileCreated = fetchedUser.isProfileSetupComplete
                }
            } catch {
                print("Failed to fetch user from Firestore: \(error.localizedDescription)")
            }
        }
    }
}
