//
//  UserManager.swift
//  Peeking
//
//  Created by Will kaminski on 7/7/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct LikeSent: Codable {
    let user_id: String
    let status: String
}

struct Experience: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var field: String
    var years: Int
}

struct Profile: Codable {
    let title: String
    let description: String
    let time: [String]
    let fields: [String]
    let setting: [String]
    let enroll: [String]
    let employment_type: [String]
    let location: GeoPoint
    let distance: Int
    let age: Int
    let accepted_fields: [String]
    let accepted_edu: [String]
    let technicals: [String]
    let chats: [String]
    let GPT_WorkEnvio: [String]
    let GPT_Technicals: [String]
    let likes_remaining: Int
    let recommendations: [String]
    let matches: [String]
    let likesYou: [String]
    let bookmarks: [String]
    let soft_skills: [String]
    let workEnvio: [String]
}

struct DBUser: Codable {
    let userId: String
    var isProfileSetupComplete: Bool?
    let lastLogIn: Date?
    var matches: [String]?
    var likesYou: [String]?
    var bookmarks: [String]?
    var userType: Int?
    var likes_remaining: Int?
    // New fields
    var name: String?
    var location: GeoPoint?
    var age: Int?
    var recommendations: [String]?
    var birthday: Date?
    var languages: [String]?
    var education: [String]?
    var distance: Int?
    var fields: [String]?
    var work_setting: [String]?
    var employer: [String]?
    var status: [String]?
    var start: [String]?
    var technicals: [String]?
    var soft_skills: [String]?
    var workEnvio: [String]?
    var hobbies: String?
    var chats: [String]?
    var pfp: String?
    var personality_photo: String?
    var GPT_WorkEnvio: [String]?
    var GPT_Technicals: [String]?
    var GPT_SoftSkills: [String]?
    // Employer-specific fields
    var logo: String?
    var positions: [String]?
    var mission: String?
    var type: [String]?
    var photo: String?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.userId
        self.isProfileSetupComplete = auth.isProfileSetupComplete
        self.lastLogIn = auth.lastLogIn
        self.matches = auth.matches
        self.likesYou = auth.likesYou
        self.bookmarks = auth.bookmarks
        self.userType = auth.userType
    }
    
    init(
        userId: String,
        isProfileSetupComplete: Bool? = false,
        lastLogIn: Date? = nil,
        matches: [String]? = nil,
        likesYou: [String]? = nil,
        bookmarks: [String]? = nil,
        userType: Int? = nil,
        recommendations: [String]? = nil,
        // New fields
        name: String? = nil,
        location: GeoPoint? = nil,
        age: Int? = nil,
        birthday: Date? = nil,
        languages: [String]? = nil,
        education: [String]? = nil,
        distance: Int? = nil,
        fields: [String]? = nil,
        work_setting: [String]? = nil,
        status: [String]? = nil,
        employer: [String]? = nil,
        start: [String]? = nil,
        technicals: [String]? = nil,
        soft_skills: [String]? = nil,
        workEnvio: [String]? = nil,
        hobbies: String? = nil,
        chats: [String]? = nil,
        pfp: String? = nil,
        personality_photo: String? = nil,
        GPT_WorkEnvio: [String]? = nil,
        GPT_Technicals: [String]? = nil,
        GPT_SoftSkills: [String]? = nil,
        likes_remaining: Int? = nil,
        // Employer-specific fields
        logo: String? = nil,
        positions: [String]? = nil,
        mission: String? = nil,
        type: [String]? = nil,
        photo: String? = nil
    ) {
        self.userId = userId
        self.isProfileSetupComplete = isProfileSetupComplete
        self.lastLogIn = lastLogIn
        self.matches = matches
        self.likesYou = likesYou
        self.bookmarks = bookmarks
        self.userType = userType
        self.name = name
        self.location = location
        self.age = age
        self.likes_remaining = likes_remaining
        self.birthday = birthday
        self.languages = languages
        self.education = education
        self.distance = distance
        self.fields = fields
        self.recommendations = recommendations
        self.work_setting = work_setting
        self.status = status
        self.start = start
        self.technicals = technicals
        self.soft_skills = soft_skills
        self.workEnvio = workEnvio
        self.hobbies = hobbies
        self.employer = employer
        self.chats = chats
        self.pfp = pfp
        self.personality_photo = personality_photo
        self.GPT_WorkEnvio = GPT_WorkEnvio
        self.GPT_Technicals = GPT_Technicals
        self.GPT_SoftSkills = GPT_SoftSkills
        self.logo = logo
        self.positions = positions
        self.mission = mission
        self.type = type
        self.photo = photo
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isProfileSetupComplete = "is_profile_setup_complete"
        case lastLogIn = "last_log_in"
        case matches = "matches"
        case likesYou = "likes_you"
        case bookmarks = "bookmarks"
        case userType = "user_type"
        case name
        case location
        case age
        case birthday
        case languages
        case education
        case distance
        case fields
        case work_setting = "work_setting"
        case status
        case start
        case technicals
        case soft_skills = "soft_skills"
        case workEnvio
        case hobbies
        case recommendations
        case chats
        case pfp
        case employer
        case personality_photo = "personality_photo"
        case GPT_WorkEnvio = "GPT_WorkEnvio"
        case GPT_Technicals = "GPT_Technicals"
        case GPT_SoftSkills = "GPT_SoftSkills"
        case likes_remaining = "likes_remaining"
        case logo
        case positions
        case mission
        case type
        case photo
    }
}

final class UserManager: ObservableObject {
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func likesSentCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("likes_sent")
    }
    
    private func experienceCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("experience")
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

    func createOrUpdateUser(user: DBUser) async throws {
        let document = try await userDocument(userId: user.userId).getDocument()
        if document.exists {
            // Merge existing data with new data
            try userDocument(userId: user.userId).setData(from: user, merge: true)
        } else {
            // Create new user
            try userDocument(userId: user.userId).setData(from: user, merge: false)
        }
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateProfileSetupComplete(userId: String, isComplete: Bool) async throws {
        let document = try await userDocument(userId: userId).getDocument()
        if let data = document.data(), let existingValue = data["is_profile_setup_complete"] as? Bool, existingValue {
            // If the profile is already marked as complete, do nothing
            return
        }
        try await userDocument(userId: userId).updateData(["is_profile_setup_complete": isComplete])
    }
    
    func updateUserProfileType(userId: String, userType: Int) async throws {
        let document = try await userDocument(userId: userId).getDocument()
        if let data = document.data(), let existingValue = data["user_type"] as? Int, existingValue != -1 {
            // If the user type is already set, do nothing
            return
        }
        if userType == 0 {
            try await userDocument(userId: userId).updateData([
                "user_type": userType,
                "likes_remaining": 3,
                "recommendations": [],
                "GPT_Technicals": [],
                "GPT_SoftSkills": []
            ])
        } else if userType == 1 {
            try await userDocument(userId: userId).updateData([
                "user_type": userType
            ])
            try await addProfile(userId: userId, profile: Profile(
                title: "", description: "", time: [], fields: [], setting: [], enroll: [], employment_type: [],
                location: GeoPoint(latitude: 0, longitude: 0), distance: 0, age: 0, accepted_fields: [],
                accepted_edu: [], technicals: [], chats: [], GPT_WorkEnvio: [], GPT_Technicals: [],
                likes_remaining: 3, recommendations: [], matches: [], likesYou: [], bookmarks: [], soft_skills: [], workEnvio: []
            ))
        }
    }
    
    // New function to update the user profile for employees
    func updateUserProfileForEmployee(userId: String, additionalData: [String: Any]) async throws {
        let document = try await userDocument(userId: userId).getDocument()
        if let data = document.data(), let existingValue = data["user_type"] as? Int, existingValue != 0 {
            // If the user type is not set to employee, do nothing
            return
        }
        try await userDocument(userId: userId).updateData(additionalData)
    }
    
    // New function to update the user profile for employers
    func updateUserProfileForEmployer(userId: String, additionalData: [String: Any]) async throws {
        let document = try await userDocument(userId: userId).getDocument()
        if let data = document.data(), let existingValue = data["user_type"] as? Int, existingValue != 1 {
            // If the user type is not set to employer, do nothing
            return
        }
        try await userDocument(userId: userId).updateData(additionalData)
    }

    func addLikeSent(userId: String, like: LikeSent) async throws {
        try likesSentCollection(userId: userId).addDocument(from: like)
    }
    
    func addExperience(userId: String, experience: Experience) async throws {
        try experienceCollection(userId: userId).addDocument(from: experience)
    }
    
    func addProfile(userId: String, profile: Profile) async throws {
        try profileDocument(userId: userId).setData(from: profile)
    }

    func addProfileLikeSent(userId: String, like: LikeSent) async throws {
        try profileLikesSentCollection(userId: userId).addDocument(from: like)
    }

    func deleteSubcollections(userId: String) async throws {
        let likesSentDocs = try await likesSentCollection(userId: userId).getDocuments()
        for document in likesSentDocs.documents {
            try await document.reference.delete()
        }
        
        let experienceDocs = try await experienceCollection(userId: userId).getDocuments()
        for document in experienceDocs.documents {
            try await document.reference.delete()
        }
    }
}
