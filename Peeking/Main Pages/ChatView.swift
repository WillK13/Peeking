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
    @Environment(\.presentationMode) var presentationMode // Used to dismiss the current view
    @State private var lastMessageTimestamp: Timestamp? = nil

    var body: some View {
        VStack {
            // Custom Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                    .padding()
                }
                Spacer()
            }
            
            // Messages List
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            HStack {
                                if message.senderId == Auth.auth().currentUser?.uid {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color("TopOrange"))
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.5))
                                        .foregroundColor(.black)
                                        .cornerRadius(15)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .onChange(of: messages) { _ in
                        if let lastMessage = messages.last {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Message Input
            HStack {
                TextField("Enter message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)
                    .cornerRadius(5)
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18))
                        .padding(5)
                        .foregroundColor(.white)
                        .background(.blue)
                        .clipShape(Circle())
                        
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
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
                self.lastMessageTimestamp = messages.last?.timestamp
                startListeningForNewMessages()
            case .failure(let error):
                print("Failed to fetch messages: \(error.localizedDescription)")
            }
        }
    }
    
    private func startListeningForNewMessages() {
        guard let lastTimestamp = lastMessageTimestamp else { return }
        
        ChatManager.shared.listenForNewMessages(chatId: chatId, since: lastTimestamp) { result in
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
