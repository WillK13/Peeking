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
    @State private var chats: [ChatWithUserName] = []
    @State private var loading = true
    @State private var selectedChatId: String? = nil

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView() // Your custom background view
                    .edgesIgnoringSafeArea(.all) // Ensure the background covers the whole screen
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
                            ForEach(chats, id: \.chat.id) { chatWithUserName in
                                Button(action: {
                                    selectedChatId = chatWithUserName.chat.id
                                }) {
                                    VStack(alignment: .leading) {
                                        Text(chatWithUserName.userName)
                                            .font(.headline)
                                            .fontWeight(.regular)
                                            .padding(.bottom, 8)
                                        if let lastMessage = chatWithUserName.lastMessage {
                                            Text(truncatedMessage(lastMessage.text))
                                                .font(.footnote)
                                                .fontWeight(lastMessage.senderId == Auth.auth().currentUser?.uid ? .regular : .bold)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10) // Add corner radius
                                    .shadow(color: .gray, radius: 3, x: 0, y: 2) // Add shadow for better visibility
                                }
                                .listRowBackground(Color.clear) // Ensure list row background is transparent
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear) // Remove the white background of the entire list
                        .padding(.horizontal, 20) // Adjust horizontal padding
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                fetchChats()
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(item: $selectedChatId) { chatId in
                ChatView(chatId: chatId)
            }
        }
    }

    private func fetchChats() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(currentUserId).getDocument { document, error in
            if let document = document, document.exists {
                if let userType = document.data()?["user_type"] as? Int, userType == 1 {
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
        var fetchedChats: [ChatWithUserName] = []

        for chatId in chatIds {
            dispatchGroup.enter()
            ChatManager.shared.fetchChat(chatId: chatId) { result in
                switch result {
                case .success(let chat):
                    if let otherUserId = chat.users.first(where: { $0 != Auth.auth().currentUser?.uid }) {
                        fetchUserNameAndLastMessage(userId: otherUserId, chat: chat) { chatWithUserName in
                            fetchedChats.append(chatWithUserName)
                            dispatchGroup.leave()
                        }
                    } else {
                        dispatchGroup.leave()
                    }
                case .failure(let error):
                    print("Failed to fetch chat: \(error.localizedDescription)")
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.chats = fetchedChats
            self.loading = false
        }
    }

    private func fetchUserNameAndLastMessage(userId: String, chat: Chat, completion: @escaping (ChatWithUserName) -> Void) {
        let db = Firestore.firestore()

        db.collection("users").document(userId).getDocument { document, error in
            let userName = document?.data()?["name"] as? String ?? "Unknown"

            ChatManager.shared.fetchMessages(chatId: chat.id!) { result in
                switch result {
                case .success(let messages):
                    let lastMessage = messages.last
                    completion(ChatWithUserName(chat: chat, userName: userName, lastMessage: lastMessage))
                case .failure(let error):
                    print("Failed to fetch messages: \(error.localizedDescription)")
                    completion(ChatWithUserName(chat: chat, userName: userName, lastMessage: nil))
                }
            }
        }
    }

    // Helper function to truncate the message
    private func truncatedMessage(_ message: String) -> String {
        if message.count > 20 {
            return String(message.prefix(20)) + "..."
        }
        return message
    }
}

struct ChatWithUserName: Identifiable {
    var id: String { chat.id ?? UUID().uuidString }
    var chat: Chat
    var userName: String
    var lastMessage: Message?
}

#Preview {
    MessagesView()
}
