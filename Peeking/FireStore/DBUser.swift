//
//  DBUser.swift
//  Peeking
//
//  Created by Will kaminski on 7/6/24.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct DBUser: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let dateCreated: Timestamp
    let isProfileSetupComplete: Bool

    var dateCreatedDate: Date {
        return dateCreated.dateValue()
    }
}
