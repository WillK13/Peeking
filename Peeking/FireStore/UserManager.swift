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
    let userId: String
    let status: String
}

struct DBUser: Codable {
    let userId: String
    var isProfileSetupComplete: Bool?
    let dateCreated: Date?
    var matches: [String]?
    var likesYou: [String]?
    var chats: [String]?
    var bookmarks: [String]?
    var userType: Int?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.userId
        self.isProfileSetupComplete = auth.isProfileSetupComplete
        self.dateCreated = auth.dateCreated
        self.matches = auth.matches
        self.likesYou = auth.likesYou
        self.chats = auth.chats
        self.bookmarks = auth.bookmarks
        self.userType = auth.userType
    }
    
    init(
        userId: String,
        isProfileSetupComplete: Bool? = false,
        dateCreated: Date? = nil,
        matches: [String]? = nil,
        likesYou: [String]? = nil,
        chats: [String]? = nil,
        bookmarks: [String]? = nil,
        userType: Int? = nil
    ) {
        self.userId = userId
        self.isProfileSetupComplete = isProfileSetupComplete
        self.dateCreated = dateCreated
        self.matches = matches
        self.likesYou = likesYou
        self.chats = chats
        self.bookmarks = bookmarks
        self.userType = userType
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isProfileSetupComplete = "is_profile_setup_complete"
        case dateCreated = "date_created"
        case matches = "matches"
        case likesYou = "likes_you"
        case chats = "chats"
        case bookmarks = "bookmarks"
        case userType = "user_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isProfileSetupComplete = try container.decodeIfPresent(Bool.self, forKey: .isProfileSetupComplete)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.matches = try container.decodeIfPresent([String].self, forKey: .matches)
        self.likesYou = try container.decodeIfPresent([String].self, forKey: .likesYou)
        self.chats = try container.decodeIfPresent([String].self, forKey: .chats)
        self.bookmarks = try container.decodeIfPresent([String].self, forKey: .bookmarks)
        self.userType = try container.decodeIfPresent(Int.self, forKey: .userType)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isProfileSetupComplete, forKey: .isProfileSetupComplete)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.matches, forKey: .matches)
        try container.encodeIfPresent(self.likesYou, forKey: .likesYou)
        try container.encodeIfPresent(self.likesYou, forKey: .likesYou)
        try container.encodeIfPresent(self.bookmarks, forKey: .bookmarks)
        try container.encodeIfPresent(self.userType, forKey: .userType)
    }
}

final class UserManager: ObservableObject {
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
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
        try await userDocument(userId: userId).updateData(["user_type": userType])
    }
}
