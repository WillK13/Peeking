//
//  ProfileUpdater.swift
//  Peeking
//
//  Created by Will kaminski on 7/13/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ProfileUpdater {
    static let shared = ProfileUpdater()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func experienceCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("experience")
    }
    
    struct Experience: Codable, Identifiable {
        var id: String = UUID().uuidString
        var field: String
        var years: Int
    }
    
    func updateEmployeeProfile(userId: String, name: String, birthday: Date, languages: [String], education: [String], experiences: [Experience]) async throws {
        let updates: [String: Any] = [
            "name": name,
            "birthday": Timestamp(date: birthday),
            "languages": languages,
            "education": education
        ]
        
        // Batch update for user profile
        let batch = Firestore.firestore().batch()
        
        // Update user document
        let userRef = userDocument(userId: userId)
        batch.updateData(updates, forDocument: userRef)
        
        // Clear existing experiences
        let experienceDocs = try await experienceCollection(userId: userId).getDocuments()
        for document in experienceDocs.documents {
            batch.deleteDocument(document.reference)
        }
        
        // Add new experiences
        for experience in experiences {
            let experienceRef = experienceCollection(userId: userId).document()
            try batch.setData(from: experience, forDocument: experienceRef)
        }
        
        // Commit the batch
        try await batch.commit()
    }
}
