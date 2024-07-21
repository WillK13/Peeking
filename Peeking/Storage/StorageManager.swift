//
//  StorageManager.swift
//  Peeking
//
//  Created by Will kaminski on 7/21/24.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()

    private init() {}

    func uploadProfileImage(userId: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(.failure(StorageError.failedToConvertImage))
            return
        }

        let storageRef = storage.child("images/pfp/\(userId).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                completion(.failure(StorageError.failedToUpload))
                return
            }

            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(StorageError.failedToGetDownloadURL))
                    return
                }
                completion(.success(downloadURL.absoluteString))
            }
        }
    }

    enum StorageError: Error {
        case failedToConvertImage
        case failedToUpload
        case failedToGetDownloadURL
    }
}
