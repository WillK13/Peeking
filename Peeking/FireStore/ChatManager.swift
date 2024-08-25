//
//  ChatManager.swift
//  Peeking
//
//  Created by Will kaminski on 8/24/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Chat: Codable {
    @DocumentID var id: String?
    let users: [String]
}

struct Message: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    let senderId: String
    let text: String
    let timestamp: Timestamp

    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}

final class ChatManager: ObservableObject {
    static let shared = ChatManager()
    private init() { }
    
    private let chatCollection: CollectionReference = Firestore.firestore().collection("chats_collection")
    
    private func chatDocument(chatId: String) -> DocumentReference {
        chatCollection.document(chatId)
    }
    
    private func messagesCollection(chatId: String) -> CollectionReference {
        chatDocument(chatId: chatId).collection("messages")
    }
    
    // Function to create a new chat or retrieve existing chat
    func createOrFetchChat(userIds: [String], completion: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
        print("Inside of create chat or fetch func")
        // Check if chat exists with these users
        db.collection("chats_collection")
            .whereField("users", arrayContains: userIds[0])
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let documents = snapshot?.documents {
                    for document in documents {
                        if let users = document.data()["users"] as? [String], Set(users) == Set(userIds) {
                            completion(.success(document.documentID))
                            return
                        }
                    }
                }
                
                // If chat doesn't exist, create a new one
                self.createChat(userIds: userIds, completion: completion)
                print("Created new chat")
            }
    }
    
    private func createChat(userIds: [String], completion: @escaping (Result<String, Error>) -> Void) {
        print("Inside of create chat func")
        let chat = Chat(users: userIds)
        
        do {
            let newChatRef = try chatCollection.addDocument(from: chat)
            completion(.success(newChatRef.documentID))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Function to send a message in a chat
    func sendMessage(chatId: String, message: Message) async throws {
        try messagesCollection(chatId: chatId).addDocument(from: message)
    }
    
    // Function to fetch all messages in a chat
    func fetchMessages(chatId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        messagesCollection(chatId: chatId)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let messages = snapshot?.documents.compactMap { document in
                    try? document.data(as: Message.self)
                } ?? []
                
                completion(.success(messages))
            }
    }
    
    // Function to listen for new messages in a chat after a certain timestamp
    func listenForNewMessages(chatId: String, since lastTimestamp: Timestamp, completion: @escaping (Result<Message, Error>) -> Void) {
        messagesCollection(chatId: chatId)
            .whereField("timestamp", isGreaterThan: lastTimestamp)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let document = snapshot?.documents.first, let message = try? document.data(as: Message.self) {
                    completion(.success(message))
                }
            }
    }

    func fetchChat(chatId: String, completion: @escaping (Result<Chat, Error>) -> Void) {
            chatDocument(chatId: chatId).getDocument { document, error in
                if let document = document, document.exists {
                    do {
                        let chat = try document.data(as: Chat.self)
                        completion(.success(chat))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
}

