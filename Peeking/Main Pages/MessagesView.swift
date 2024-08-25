//
//  MessagesView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MessagesView: View {
    @State private var showAlert = false
    @State private var chats: [Chat] = [] // Array to hold chat objects
    @State private var loading = true

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    HStack {
                        Spacer()
                        Spacer()
                        ZStack {
                            Image("tgmessages")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                                .padding(.top, -40)
                            
                            Text("\(chats.count)")
                                .foregroundColor(.black)
                                .font(.title3)
                                .padding(.leading, 55)
                                .padding(.bottom, 5)
                        }
                        Spacer()
                        Button(action: {
                            showAlert = true
                        }) {
                            Image("lightbulb")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .padding(.trailing, 20)
                        }.padding(.top, -40)
                    }
                    
                    Spacer()
                    
                    if loading {
                        ProgressView()
                            .foregroundColor(.white)
                    } else if chats.isEmpty {
                        Text("No matches")
                            .foregroundColor(.white)
                            .font(.title)
                    } else {
                        List {
                            ForEach(chats, id: \.id) { chat in
                                if let otherUserId = chat.users.first(where: { $0 != Auth.auth().currentUser?.uid }) {
                                    NavigationLink(destination: ChatView(chatId: chat.id!)) {
                                        Text("Chat with User ID: \(otherUserId)")
                                            .foregroundColor(.black)
                                            .padding(.vertical, 5)
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                fetchChats()
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func fetchChats() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(currentUserId).getDocument { document, error in
            if let document = document, document.exists {
                if let userType = document.data()?["user_type"] as? Int, userType == 1 {
                    // Employer, fetch chats from the profile subcollection
                    let profileRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
                    profileRef.getDocument { profileDocument, profileError in
                        if let profileDocument = profileDocument, profileDocument.exists {
                            let chatIds = profileDocument.data()?["chats"] as? [String] ?? []
                            fetchChatsDetails(chatIds: chatIds)
                        } else {
                            loading = false
                        }
                    }
                } else {
                    // Employee, fetch chats from the main document
                    let chatIds = document.data()?["chats"] as? [String] ?? []
                    fetchChatsDetails(chatIds: chatIds)
                }
            } else {
                loading = false
            }
        }
    }
    
    private func fetchChatsDetails(chatIds: [String]) {
        let dispatchGroup = DispatchGroup()
        var fetchedChats: [Chat] = []
        
        for chatId in chatIds {
            dispatchGroup.enter()
            ChatManager.shared.fetchChat(chatId: chatId) { result in
                switch result {
                case .success(let chat):
                    fetchedChats.append(chat)
                case .failure(let error):
                    print("Failed to fetch chat: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.chats = fetchedChats
            self.loading = false
        }
    }
}

#Preview {
    MessagesView()
}
