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
    @State private var chatsCount: Int = 0
    @State private var chats: [String] = [] // Array to hold user IDs from the chats array
    
    var body: some View {
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
                        
                        Text("\(chatsCount)")
                            .foregroundColor(.black)
                            .font(.title3)
                            .padding(.leading, 55)
                            .padding(.bottom, 5)
                    }
                    Spacer()
                    Button(action: {
                        showAlert = true
                    }) {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                    }.padding(.top, -40)
                }
                
                Spacer()
                
                if chats.isEmpty {
                    Text("No matches")
                        .foregroundColor(.white)
                        .font(.title)
                } else {
                    VStack {
                        ForEach(chats, id: \.self) { chatId in
                            Text("User ID: \(chatId)")
                                .foregroundColor(.white)
                                .font(.body)
                                .padding(.bottom, 5)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            fetchChats()
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
                            self.chats = profileDocument.data()?["chats"] as? [String] ?? []
                            self.chatsCount = self.chats.count
                        }
                    }
                } else {
                    // Employee, fetch chats from the main document
                    self.chats = document.data()?["chats"] as? [String] ?? []
                    self.chatsCount = self.chats.count
                }
            }
        }
    }
}

#Preview {
    MessagesView()
}
