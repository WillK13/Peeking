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
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.05)]),
                    startPoint: .center,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea([.leading, .trailing])
                .padding(.bottom) // Ensure the background covers the whole screen
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
                        VStack {
                            HStack {
                                Spacer()
                                Text("No matches right now")
                                    .foregroundColor(.white)
                                    .font(.title)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Image("Duck_Body")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Link(destination: URL(string: "https://peeking.ai/Tips")!) {
                                    SettingsButton(im: "rocket", title: "Get some tips here!")
                                }
                                .padding(.horizontal, 25.0)
                                Spacer()
                            }
                        }
                    } else {
                        List {
                            ForEach(chats, id: \.chat.id) { chatWithUserName in
                                Button(action: {
                                    selectedChatId = chatWithUserName.chat.id
                                }) {
                                    HStack {
                                        // Profile Image
                                        AsyncImage(url: URL(string: chatWithUserName.profileImageURL)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 85)
                                                .cornerRadius(10)
                                                .padding(.leading, 20)
                                        } placeholder: {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 60, height: 85)
                                                .padding(.leading, 20)
                                        }
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(chatWithUserName.userName)
                                                    .font(.headline)
                                                    .fontWeight(.regular)
                                                Spacer()
                                                if let lastMessage = chatWithUserName.lastMessage {
                                                    Text(formattedTimestamp(lastMessage.timestamp))
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .padding(.bottom, 10)
                                            if let lastMessage = chatWithUserName.lastMessage {
                                                Text(truncatedMessage(lastMessage.text))
                                                    .font(.footnote)
                                                    .fontWeight(lastMessage.senderId == Auth.auth().currentUser?.uid ? .regular : .bold)
                                                    .foregroundColor(.black)
                                            }
                                        }.padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                    }
                                    // Add corner radius
                                }
                                .listRowBackground(Color.clear) // Ensure list row background is transparent
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear) // Remove the white background of the entire list
                        .padding(.leading, 20)
                        .padding(.horizontal, 10) // Adjust horizontal padding
                    }

                    Spacer()
                }
            }
            .onAppear {
                fetchChats()
            }
            .fullScreenCover(item: $selectedChatId) { chatId in
                if let chatWithUserName = chats.first(where: { $0.chat.id == chatId }) {
                    ChatView(chatId: chatId, profileImageURL: .constant(chatWithUserName.profileImageURL), userName: .constant(chatWithUserName.userName))
                }
            }
            .sheet(isPresented: $showAlert) {
                TipsView()
            }
        }
    }

    private func fetchChats() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(currentUserId).getDocument { document, error in
            if let document = document, document.exists {
                if let userType = document.data()?["user_type"] as? Int, userType == 1 {
                    // Employer users (userType == 1)
                    let profileRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
                    profileRef.getDocument { profileDocument, profileError in
                        if let profileDocument = profileDocument, profileDocument.exists {
                            let chatIds = profileDocument.data()?["chats"] as? [String] ?? []
                            if chatIds.isEmpty {
                                // No chats for employer, set loading to false
                                self.loading = false
                            } else {
                                fetchChatsDetails(chatIds: chatIds)
                            }
                        } else {
                            self.loading = false
                        }
                    }
                } else {
                    // Employee users (userType == 0)
                    let chatIds = document.data()?["chats"] as? [String] ?? []
                    if chatIds.isEmpty {
                        // No chats for employee, set loading to false
                        self.loading = false
                    } else {
                        fetchChatsDetails(chatIds: chatIds)
                    }
                }
            } else {
                self.loading = false
            }
        }
    }

    private func fetchChatsDetails(chatIds: [String]) {
        var fetchedChats: [ChatWithUserName] = []
        for chatId in chatIds {
            ChatManager.shared.fetchChat(chatId: chatId) { result in
                switch result {
                case .success(let chat):
                    if let otherUserId = chat.users.first(where: { $0 != Auth.auth().currentUser?.uid }) {
                        fetchUserNameAndLastMessage(userId: otherUserId, chat: chat) { chatWithUserName in
                            DispatchQueue.main.async {
                                fetchedChats.append(chatWithUserName)
                                if fetchedChats.count == chatIds.count {
                                    self.chats = fetchedChats
                                    self.loading = false
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print("Failed to fetch chat: \(error.localizedDescription)")
                }
            }
        }
    }
}



    private func fetchUserNameAndLastMessage(userId: String, chat: Chat, completion: @escaping (ChatWithUserName) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in
            let userName = document?.data()?["name"] as? String ?? "Unknown"
            let profileImageURL = document?.data()?["pfp"] as? String ?? document?.data()?["logo"] as? String ?? ""
            ChatManager.shared.fetchMessages(chatId: chat.id!) { result in
                switch result {
                case .success(let messages):
                    let lastMessage = messages.last
                    completion(ChatWithUserName(chat: chat, userName: userName, lastMessage: lastMessage, profileImageURL: profileImageURL))
                case .failure(let error):
                    print("Failed to fetch messages: \(error.localizedDescription)")
                    completion(ChatWithUserName(chat: chat, userName: userName, lastMessage: nil, profileImageURL: profileImageURL))
                }
            }
        }
    }
    private func formattedTimestamp(_ timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
    }
    // Helper function to truncate the message
    private func truncatedMessage(_ message: String) -> String {
        if message.count > 20 {
            return String(message.prefix(20)) + "..."
        }
        return message
    }

struct ChatWithUserName: Identifiable {
    var id: String { chat.id ?? UUID().uuidString }
    var chat: Chat
    var userName: String
    var lastMessage: Message?
    var profileImageURL: String // URL for profile image or logo
}
#Preview {
    MessagesView()
}
