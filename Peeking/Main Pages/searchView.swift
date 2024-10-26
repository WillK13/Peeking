//
//  searchView.swift
//  Peeking
//
//  Created by Will kaminski on 10/26/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct searchView: View {
    @State private var searchText = ""
    @State private var recentUsers: [UserResult] = [] // Array to store recent users
    @State private var selectedUser: UserResult?
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {
            ZStack {
                BackgroundView() // Background at the bottom layer

                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                        }

                        Spacer()
                        VStack {
                            Image("tgduck") // Replace with the actual duck icon asset name
                                .resizable()
                                .frame(width: 50, height: 40)
                            
                            Text("Peeking Tag")
                                .font(.title)
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                    .padding()
                    // Header and Search field area
                    VStack {

                        TextField("6 Digit Number...", text: $searchText, onCommit: {
                            searchUser()
                        })
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    
                    // Results list area
                    List(recentUsers, id: \.id) { user in
                        HStack {
                            // Profile Image
                            AsyncImage(url: URL(string: user.personalityPhoto)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 50, height: 50)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.headline)
                                Text("Tag: \(user.shareID)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // X button for removing user from list
                            Button(action: {
                                removeUser(user: user)
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onTapGesture {
                            selectedUser = user
                        }
                    }
                    .background(Color.white).cornerRadius(20).padding(.top, 10) // White background for the results list
                }
                .cornerRadius(20)
//                .shadow(radius: 5)
                .padding(.horizontal, 20)
                .padding(.top, 50)
            }
            .navigationBarHidden(true)
            .fullScreenCover(item: $selectedUser) { user in
                ProfileShare(userId: .constant(user.id), needsButtons: .constant(false))
            }.navigationBarHidden(true)
        
    }

    private func searchUser() {
        // Search for user by their share ID in Firestore
        let db = Firestore.firestore()
        db.collection("users").whereField("share_id", isEqualTo: searchText).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("No users found or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.recentUsers = documents.compactMap { doc in
                let data = doc.data()
                guard let name = data["name"] as? String,
                      let shareID = data["share_id"] as? String,
                      let personalityPhoto = data["personality_photo"] as? String else { return nil }
                return UserResult(id: doc.documentID, name: name, shareID: shareID, personalityPhoto: personalityPhoto)
            }
        }
    }
    
    private func removeUser(user: UserResult) {
        if let index = recentUsers.firstIndex(where: { $0.id == user.id }) {
            recentUsers.remove(at: index)
        }
    }
}

// UserResult model for holding user data
struct UserResult: Identifiable {
    var id: String
    var name: String
    var shareID: String
    var personalityPhoto: String
}

#Preview {
    searchView()
}
