//
//  ProfileUpdaterEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 7/17/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ProfileUpdaterEmployer {
    static let shared = ProfileUpdaterEmployer()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func profileCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("profile")
    }
    
    private func profileDocument(userId: String) -> DocumentReference {
        profileCollection(userId: userId).document("profile_data")
    }
    
    private func profileLikesSentCollection(userId: String) -> CollectionReference {
        profileCollection(userId: userId).document("profile_data").collection("likes_sent")
    }
    
    struct Position: Codable, Identifiable {
        var id: String = UUID().uuidString
        var title: String
        var description: String
    }
    
    func updateEmployerProfile(
        userId: String,
        companyName: String,
        companyMission: String?,
        languages: [String],
        employerType: [String],
        positionTitle: String,
        positionDescription: String,
        startTime: [String],
        relevantFields: [String],
        workSetting: [String],
        employmentType: [String],
        logoURL: String? = nil,
        GPT_Technicals: [String]? = nil,
        GPT_WorkEnvio: [String]? = nil,
        likes_remaining: Int? = nil,
        recommendations: [String]? = nil,
        matches: [String]? = nil,
        likesYou: [String]? = nil,
        bookmarks: [String]? = nil,
        soft_skills: [String]? = nil,
        workEnvio: [String]? = nil
    ) async throws {
        var updates: [String: Any] = [:]
        
        // Update main user document
        updates["name"] = companyName
        updates["languages"] = languages
        updates["type"] = employerType
        updates["mission"] = companyMission
        if let logoURL = logoURL {
            updates["logo"] = logoURL
        }
        
        if let GPT_Technicals = GPT_Technicals {
            updates["GPT_Technicals"] = GPT_Technicals
        }
        
        if let GPT_WorkEnvio = GPT_WorkEnvio {
            updates["GPT_WorkEnvio"] = GPT_WorkEnvio
        }

        // Batch update for user profile
        let batch = Firestore.firestore().batch()
        
        // Update user document
        let userRef = userDocument(userId: userId)
        batch.updateData(updates, forDocument: userRef)
        
        // Update profile subcollection
        var profileUpdates: [String: Any] = [
            "title": positionTitle,
            "description": positionDescription,
            "time": startTime,
            "fields": relevantFields,
            "setting": workSetting,
            "employment_type": employmentType
        ]

        if let likes_remaining = likes_remaining {
            profileUpdates["likes_remaining"] = likes_remaining
        }
        
        if let recommendations = recommendations {
            profileUpdates["recommendations"] = recommendations
        }
        
        if let matches = matches {
            profileUpdates["matches"] = matches
        }
        
        if let likesYou = likesYou {
            profileUpdates["likesYou"] = likesYou
        }
        
        if let bookmarks = bookmarks {
            profileUpdates["bookmarks"] = bookmarks
        }
        
        if let soft_skills = soft_skills {
            profileUpdates["soft_skills"] = soft_skills
        }
        
        if let workEnvio = workEnvio {
            profileUpdates["workEnvio"] = workEnvio
        }
        
        let profileRef = profileDocument(userId: userId)
        batch.updateData(profileUpdates, forDocument: profileRef)

        // Add likes_sent subcollection
        try await addProfileLikeSent(userId: userId, like: LikeSent(user_id: "", status: ""))
        
        // Commit the batch
        try await batch.commit()
    }
    
    func updateSearchSettings(
        userId: String,
        distance: Double,
        experience: Double,
        acceptedFields: [String],
        acceptedEducation: [String]
    ) async throws {
        let updates: [String: Any] = [
            "distance": Int(distance),
            "age": Int(experience), // Assuming experience years is stored as 'age'
            "accepted_fields": acceptedFields,
            "accepted_edu": acceptedEducation
        ]
        
        let profileRef = profileDocument(userId: userId)
        try await profileRef.updateData(updates)
    }
    
    func updateTechnicalSkills(
        userId: String,
        technicalSkills: String,
        certifications: String
    ) async throws {
        let updates: [String: Any] = [
            "technicals": [technicalSkills, certifications]
        ]
        let profileRef = profileDocument(userId: userId)
        try await profileRef.updateData(updates)
    }
    
    func updateWorkEnvironment(
        userId: String,
        answers: [String]
    ) async throws {
        let updates: [String: Any] = ["workEnvio": answers]
        
        let profileRef = profileDocument(userId: userId)
        try await profileRef.updateData(updates)
    }
    
    func updateSoftSkills(
        userId: String,
        softSkills: [String]
    ) async throws {
        let updates: [String: Any] = ["soft_skills": softSkills]
        
        let profileRef = profileDocument(userId: userId)
        try await profileRef.updateData(updates)
    }
    
    func updateHobbiesAndPhoto(
        userId: String,
        hobbies: String,
        photoURL: String
    ) async throws {
        let updates: [String: Any] = [
            "hobbies": hobbies,
            "photo": photoURL
        ]
        
        let userRef = userDocument(userId: userId)
        try await userRef.updateData(updates)
    }

    private func addProfileLikeSent(userId: String, like: LikeSent) async throws {
        try profileLikesSentCollection(userId: userId).addDocument(from: like)
    }
}
