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

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    addBookmark()
                }) {
                    Image(systemName: "bookmark")
                        .resizable()
                        .frame(width: 32, height: 40)
                        .foregroundColor(.black)
                }
                .padding(.top)
                .padding(.trailing, 10)
            }
            HStack {
                Spacer()
                Button(action: {
                    // Open the pop-up
                }, label: {
                    Image("eyebookmark")
                        .padding(5)
                })
            }.padding(.trailing, 10)
                
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
    }

    // Function to add bookmark
    private func addBookmark() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        if let appViewModelUserType = appViewModel.userType, appViewModelUserType == 1 {
            // Employer bookmark logic
            let profileRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
            profileRef.updateData(["bookmarks": FieldValue.arrayUnion([user_id])])
        } else {
            // Employee bookmark logic
            let userRef = db.collection("users").document(currentUserId)
            userRef.updateData(["bookmarks": FieldValue.arrayUnion([user_id])])
        }
    }

    // Function to add like
    func addLike() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        // Create a like entry with the current user ID as the document ID
        let likeData: [String: Any] = [
            "user_id": user_id,  // Set the user_id field inside the document
            "status": 0
        ]
        
        if let appViewModelUserType = appViewModel.userType, appViewModelUserType == 1 {
            // Employer like logic
            let profileRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
            profileRef.collection("likes_sent").document(user_id).setData(likeData)
        } else {
            // Employee like logic
            let userRef = db.collection("users").document(currentUserId).collection("likes_sent").document(user_id)
            userRef.setData(likeData)
        }
        
        // Check the user type of the liked user to determine where to update likes_you
        db.collection("users").document(user_id).getDocument { document, error in
            if let document = document, document.exists {
                if let likedUserType = document.data()?["user_type"] as? Int, likedUserType == 1 {
                    // Liked user is an employer, update the likes_you array in the profile subcollection
                    let likedUserProfileRef = db.collection("users").document(user_id).collection("profile").document("profile_data")
                    likedUserProfileRef.updateData(["likes_you": FieldValue.arrayUnion([currentUserId])]) { error in
                        if let error = error {
                            print("Error updating likesYou in profile subcollection: \(error.localizedDescription)")
                        } else {
                            print("Successfully added to likesYou array in profile subcollection.")
                        }
                    }
                } else {
                    // Liked user is an employee, update the likes_you array in the main document
                    let likedUserRef = db.collection("users").document(user_id)
                    likedUserRef.updateData(["likes_you": FieldValue.arrayUnion([currentUserId])]) { error in
                        if let error = error {
                            print("Error updating likesYou: \(error.localizedDescription)")
                        } else {
                            print("Successfully added to likesYou array.")
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
