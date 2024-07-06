//
//  UserManager.swift
//  Peeking
//
//  Created by Will kaminski on 7/6/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager: ObservableObject {
    private let db = Firestore.firestore()
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }

    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }

    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserProfileSetup(userId: String, isComplete: Bool) async throws {
        try await userDocument(userId: userId).updateData(["isProfileSetupComplete": isComplete])
    }

    func checkUserExists(userId: String) async throws -> Bool {
        let document = try await userDocument(userId: userId).getDocument()
        return document.exists
    }
}
