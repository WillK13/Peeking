//
//  ChatView.swift
//  Peeking
//
//  Created by Will kaminski on 8/25/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatView: View {
    let chatId: String
    @State private var messageText: String = ""
    @State private var messages: [Message] = []
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        VStack {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            HStack {
                                if message.senderId == Auth.auth().currentUser?.uid {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.3))
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .onChange(of: messages) { _ in
                        if let lastMessage = messages.last {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            HStack {
                TextField("Enter message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchMessages()
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty, let senderId = Auth.auth().currentUser?.uid else { return }
        
        let newMessage = Message(senderId: senderId, text: messageText, timestamp: Timestamp())
        
        Task {
            do {
                try await ChatManager.shared.sendMessage(chatId: chatId, message: newMessage)
                messageText = ""
            } catch {
                print("Failed to send message: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchMessages() {
        ChatManager.shared.fetchMessages(chatId: chatId) { result in
            switch result {
            case .success(let messages):
                self.messages = messages
            case .failure(let error):
                print("Failed to fetch messages: \(error.localizedDescription)")
            }
        }
        
        ChatManager.shared.listenForNewMessages(chatId: chatId) { result in
            switch result {
            case .success(let message):
                self.messages.append(message)
            case .failure(let error):
                print("Failed to listen for new messages: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ChatView(chatId: "example_chat_id")
}
