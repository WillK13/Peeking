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
    
    func updateEmployeeProfile(userId: String, name: String?, birthday: Date?, age: Int?, languages: [String]?, education: [String]?, experiences: [Experience]?, photoURL: String? = nil) async throws {
            var updates: [String: Any] = [:]
            
            if let name = name {
                updates["name"] = name
            }
            
            if let birthday = birthday {
                updates["birthday"] = Timestamp(date: birthday)
            }
            
            if let age = age {
                updates["age"] = age
            }
            
            if let languages = languages {
                updates["languages"] = languages
            }
            
            if let education = education {
                updates["education"] = education
            }
            
            if let photoURL = photoURL {
                updates["pfp"] = photoURL
            }
            
            // Batch update for user profile
            let batch = Firestore.firestore().batch()
            
            // Update user document
            let userRef = userDocument(userId: userId)
            batch.updateData(updates, forDocument: userRef)
            
            // Clear existing experiences if new experiences are provided
            if let experiences = experiences {
                let experienceDocs = try await experienceCollection(userId: userId).getDocuments()
                for document in experienceDocs.documents {
                    batch.deleteDocument(document.reference)
                }
                
                // Add new experiences
                for experience in experiences {
                    let experienceRef = experienceCollection(userId: userId).document()
                    try batch.setData(from: experience, forDocument: experienceRef)
                }
            }
            
            // Commit the batch
            try await batch.commit()
        }
    
    func updateProfileSettings(userId: String, distance: Int?, fields: [String]?, employer: [String]?, workSetting: [String]?, status: [String]?, start: [String]?) async throws {
        var updates: [String: Any] = [:]
        
        if let distance = distance {
            updates["distance"] = distance
        }
        
        if let fields = fields {
            updates["fields"] = fields
        }
        
        if let employer = employer {
            updates["employer"] = employer
        }
        
        if let workSetting = workSetting {
            updates["work_setting"] = workSetting
        }
        
        if let status = status {
            updates["status"] = status
        }
        
        if let start = start {
            updates["start"] = start
        }
        
        let userRef = userDocument(userId: userId)
        try await userRef.updateData(updates)
    }
    
    func updateTechnicals(userId: String, technicalSkills: String, certifications: String) async throws {
            let updates: [String: Any] = [
                "technicals": [technicalSkills, certifications]
            ]
            
            let userRef = userDocument(userId: userId)
            try await userRef.updateData(updates)
        }
    
    func updateSoftSkills(userId: String, softSkills: [String]) async throws {
            let updates: [String: Any] = ["soft_skills": softSkills]
            
            let userRef = userDocument(userId: userId)
            try await userRef.updateData(updates)
        }
    
    func updateWorkEnvironment(userId: String, workEnvio: [String]) async throws {
        let updates: [String: Any] = ["workEnvio": workEnvio]
        
        let userRef = userDocument(userId: userId)
        try await userRef.updateData(updates)
    }
    
    func updateHobbies(userId: String, hobbies: String, photoURL: String) async throws {
        let updates: [String: Any] = [
            "hobbies": hobbies,
            "personality_photo": photoURL
        ]
        
        let userRef = userDocument(userId: userId)
        try await userRef.updateData(updates)
    }
    func updateLocation(userId: String, location: GeoPoint) async throws {
            let updates: [String: Any] = ["location": location]
            
            let userRef = userDocument(userId: userId)
            try await userRef.updateData(updates)
        }
    
    
    
}
