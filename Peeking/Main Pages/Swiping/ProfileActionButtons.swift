//
//  ProfileActionButtons.swift
//  Peeking
//
//  Created by Will kaminski on 7/19/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileActionButtons: View {
    @Binding var user_id: String
    @Binding var currentStep: Int // Add binding for currentStep
    @State private var isHeartClicked = false
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var heartAnimationAmount: CGFloat = 1.0
    @State private var heartOffset: CGSize = .zero
    @State private var isBookmarked = false // Track the bookmark state
    @State private var showBookmarkView = false // State to manage BookmarkView display

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        toggleBookmark() // Toggle the bookmark state
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .resizable()
                            .frame(width: 32, height: 40)
                            .foregroundColor(.black)
                    }
                    .padding(.top)
                    .padding(.trailing, 10)
                    .onAppear {
                        checkIfBookmarked() // Check if the profile is already bookmarked
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        showBookmarkView = true // Show the BookmarkView
                    }, label: {
                        Image("eyebookmark")
                            .padding(5)
                    })
                }
                .padding(.trailing, 10)
                
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        if !isHeartClicked {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                heartAnimationAmount = 1.3
                                isHeartClicked = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    heartOffset = CGSize(width: 0, height: -1000)
                                    heartAnimationAmount = 2.0
                                }
                            }
                            print(user_id)
                            addLike()
                        }
                    }) {
                        Image(systemName: isHeartClicked ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 45, height: 35)
                            .foregroundColor(isHeartClicked ? .red : .black)
                            .scaleEffect(heartAnimationAmount)
                            .offset(heartOffset)
                    }
                    .padding(.bottom, 25)
                }.padding(.trailing, 10)
                HStack {
                    Spacer()
                    Button(action: {
                        // Ellipsis action
                    }) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .frame(width: 40, height: 9)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 30)
                }.padding(.trailing, 10)
                // Add slider buttons here
                HStack {
                    Spacer()
                    ForEach(0..<5) { index in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(index == currentStep ? Color("SelectColor") : Color("NotSelectedColor"))
                            .frame(width: 65, height: 15)
                            .onTapGesture {
                                currentStep = index
                            }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 20)
            }

            // Popup Overlay
            if showBookmarkView {
                BookmarkView(showBookmarkView: $showBookmarkView)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
        }
    }


    // Function to add like
    // Function to add like
    func addLike() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        // Determine the path to check `likes_remaining`
        let userDocRef: DocumentReference
        if let userType = appViewModel.userType, userType == 1 {
            userDocRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
        } else {
            userDocRef = db.collection("users").document(currentUserId)
        }

        // Fetch likes_remaining and proceed with the like if possible
        userDocRef.getDocument { document, error in
            if let document = document, document.exists {
                var likesRemaining = document.data()?["likes_remaining"] as? Int ?? 0
                
                if likesRemaining > 0 {
                    likesRemaining -= 1
                    userDocRef.updateData(["likes_remaining": likesRemaining])
                    
                    // Proceed with sending the like
                    let likeData: [String: Any] = [
                        "user_id": user_id,  // Set the user_id field inside the document
                        "status": 0
                    ]
                    
                    if appViewModel.userType == 1 {
                        // Employer like logic
                        let profileRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
                        profileRef.collection("likes_sent").document(user_id).setData(likeData)
                    } else {
                        // Employee like logic
                        let userRef = db.collection("users").document(currentUserId).collection("likes_sent").document(user_id)
                        userRef.setData(likeData)
                    }
                    
                    // Continue with mutual like check...
                    checkMutualLike(currentUserId: currentUserId, likedUserId: user_id)
                } else {
                    // Shake animation for heart
                    withAnimation(Animation.default.repeatCount(3, autoreverses: true)) {
                        heartOffset = CGSize(width: 10, height: 0)
                    }
                }
            } else {
                print("Error fetching user document: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }


    // Function to add or replace the first bookmark
    private func addOrReplaceBookmark() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        if let appViewModelUserType = appViewModel.userType, appViewModelUserType == 1 {
            // Employer bookmark logic
            let profileRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
            profileRef.getDocument { document, error in
                if let document = document, document.exists {
                    var bookmarks = document.data()?["bookmarks"] as? [String] ?? []
                    if bookmarks.isEmpty {
                        bookmarks.append(user_id)
                    } else {
                        bookmarks[0] = user_id
                    }
                    profileRef.updateData(["bookmarks": bookmarks])
                }
            }
        } else {
            // Employee bookmark logic
            let userRef = db.collection("users").document(currentUserId)
            userRef.getDocument { document, error in
                if let document = document, document.exists {
                    var bookmarks = document.data()?["bookmarks"] as? [String] ?? []
                    if bookmarks.isEmpty {
                        bookmarks.append(user_id)
                    } else {
                        bookmarks[0] = user_id
                    }
                    userRef.updateData(["bookmarks": bookmarks])
                }
            }
        }
    }

    // Function to toggle bookmark
    private func toggleBookmark() {
        if isBookmarked {
            removeBookmark()
        } else {
            addOrReplaceBookmark()
        }
        isBookmarked.toggle() // Toggle the bookmark state
    }


    private func removeBookmark() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        if let appViewModelUserType = appViewModel.userType, appViewModelUserType == 1 {
            // Employer bookmark logic
            let profileRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
            profileRef.updateData(["bookmarks": FieldValue.arrayRemove([user_id])])
        } else {
            // Employee bookmark logic
            let userRef = db.collection("users").document(currentUserId)
            userRef.updateData(["bookmarks": FieldValue.arrayRemove([user_id])])
        }
    }


    private func checkMutualLike(currentUserId: String, likedUserId: String) {
        print("IN THE MUTUAL FUNCY")
        let db = Firestore.firestore()

        // Fetch the liked user's document to determine their user type
        db.collection("users").document(likedUserId).getDocument { likedUserDocument, likedUserError in
            if let likedUserDocument = likedUserDocument, likedUserDocument.exists {
                if let likedUserType = likedUserDocument.data()?["user_type"] as? Int {
                    let checkLikesYouPath: DocumentReference
                    
                    // Determine the correct path to check the likes_you array
                    if likedUserType == 1 {
                        // Employer: check in the profile subcollection
                        checkLikesYouPath = db.collection("users").document(likedUserId).collection("profile").document("profile_data")
                    } else {
                        // Employee: check in the main user document
                        checkLikesYouPath = db.collection("users").document(likedUserId)
                    }

                    // Now fetch the likes_you array from the correct location
                    checkLikesYouPath.getDocument { document, error in
                        if let document = document, document.exists {
                            print("doc exist")
                            
                            // Debugging: Print the contents of likes_you array
                            if let likesYouArray = document.data()?["likes_you"] as? [String] {
                                print("likes_you array:", likesYouArray)
                                print("currentUserId:", currentUserId)
                                
                                if likesYouArray.contains(currentUserId) {
                                    print("Calling createChat")
                                    // Mutual like found, create chat
                                    createChatBetweenUsers(currentUserId: currentUserId, likedUserId: likedUserId)
                                    
                                    // Change the heart color to green
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        heartAnimationAmount = 1.3
                                        isHeartClicked = true
                                        // Set the heart color to green
                                    }
                                } else {
                                    print("currentUserId not found in likes_you array.")
                                }
                            } else {
                                print("likes_you array is nil or not an array of strings.")
                            }
                        } else if let error = error {
                            print("Error checking mutual like: \(error.localizedDescription)")
                        }
                    }
                } else if let error = likedUserError {
                    print("Error fetching liked user's type: \(error.localizedDescription)")
                }
            } else if let error = likedUserError {
                print("Error fetching liked user's document: \(error.localizedDescription)")
            }
        }
    }



    private func createChatBetweenUsers(currentUserId: String, likedUserId: String) {
        print("Calling creatorfetchChat")
        ChatManager.shared.createOrFetchChat(userIds: [currentUserId, likedUserId]) { result in
            switch result {
            case .success(let chatId):
                print("Chat created with ID: \(chatId)")
                addChatToUsers(chatId: chatId, currentUserId: currentUserId, likedUserId: likedUserId)
            case .failure(let error):
                print("Failed to create chat: \(error.localizedDescription)")
            }
        }
    }
    private func checkIfBookmarked() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        if let appViewModelUserType = appViewModel.userType, appViewModelUserType == 1 {
            // Check for employer
            let profileRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
            profileRef.getDocument { document, error in
                if let document = document, document.exists {
                    let bookmarks = document.data()?["bookmarks"] as? [String] ?? []
                    self.isBookmarked = bookmarks.contains(self.user_id)
                }
            }
        } else {
            // Check for employee
            let userRef = db.collection("users").document(currentUserId)
            userRef.getDocument { document, error in
                if let document = document, document.exists {
                    let bookmarks = document.data()?["bookmarks"] as? [String] ?? []
                    self.isBookmarked = bookmarks.contains(self.user_id)
                }
            }
        }
    }


    private func addChatToUsers(chatId: String, currentUserId: String, likedUserId: String) {
        let db = Firestore.firestore()
        
        // Add chat ID to the current user's chat array
        if let appViewModelUserType = appViewModel.userType, appViewModelUserType == 1 {
            // Employer chat logic
            let profileRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
            profileRef.updateData(["chats": FieldValue.arrayUnion([chatId])])
        } else {
            // Employee chat logic
            let userRef = db.collection("users").document(currentUserId)
            userRef.updateData(["chats": FieldValue.arrayUnion([chatId])])
        }
        
        // Add chat ID to the liked user's chat array
        db.collection("users").document(likedUserId).getDocument { document, error in
            if let document = document, document.exists {
                if let likedUserType = document.data()?["user_type"] as? Int, likedUserType == 1 {
                    let likedUserProfileRef = db.collection("users").document(likedUserId).collection("profile").document("profile_data")
                    likedUserProfileRef.updateData(["chats": FieldValue.arrayUnion([chatId])]) { error in
                        if let error = error {
                            print("Error updating chats in profile subcollection: \(error.localizedDescription)")
                        } else {
                            print("Successfully added chat to liked user's profile subcollection.")
                        }
                    }
                } else {
                    let likedUserRef = db.collection("users").document(likedUserId)
                    likedUserRef.updateData(["chats": FieldValue.arrayUnion([chatId])]) { error in
                        if let error = error {
                            print("Error updating chats: \(error.localizedDescription)")
                        } else {
                            print("Successfully added chat to liked user's main document.")
                        }
                    }
                }
            } else if let error = error {
                print("Error fetching liked user's document: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ProfileActionButtons(user_id: .constant("example_user_id"), currentStep: .constant(0))
}
