//
//  LikedView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// Make String conform to Identifiable
extension String: Identifiable {
    public var id: String { self }
}

struct LikedView: View {
    @State private var likedYou: [String] = []  // List of user IDs who liked you
    @State private var profiles: [String: String] = [:] // [userId: photoURL]
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedUserId: String? = nil // State to hold the selected user ID
    @State private var needsButtons = true // Set this as needed

    var body: some View {
        ZStack {
            BackgroundView()
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.05)]),
                startPoint: .center,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea([.leading, .trailing])
            .padding(.bottom)

            VStack(alignment: .center) {
                headerView
                
                

                likedList

                Spacer()
            }
        }
        .onAppear {
            fetchLikedYou()
        }
        .fullScreenCover(item: $selectedUserId) { userId in
            ProfileShare(userId: .constant(userId), needsButtons: $needsButtons)
                .environmentObject(appViewModel)
        }
    }

    private var headerView: some View {
        HStack {
            VStack {
                HStack {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.red)
                        .padding(.leading, 20.0)
                    
                    Text("\(likedYou.count)")
                        .font(.title2)
                                        .foregroundColor(.white)
                                        .bold()
                                        .padding(.leading, 5)
                    Spacer()
                }
                //            Image(systemName: "eye.slash")
                //                .resizable()
                //                .frame(width: 120, height: 100)
                //                .foregroundColor(.white)
                //                .padding(.top, 30)
                HStack {
                Text("Liked You")
                    .font(.largeTitle)
                    .padding(.leading, 20.0)
                    .foregroundColor(.white)
                    .bold()
                    Spacer()
                }
            }
            Spacer()
        }
    }

    private var likedList: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return ScrollView {
            if likedYou.isEmpty {
                        VStack {
                            Image("duckheart2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100)
                                .padding(.top, 20)
                            Spacer()
                            Text("You haven’t liked anyone yet")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.all)
                            Text("Send likes to get started!")
                                .font(.title3)
                                .foregroundColor(.black)
                                .padding([.leading, .bottom, .trailing])
                                .bold()
                            Spacer()
                        }.background(Color.white)
                    .cornerRadius(10).padding(.top, 40)
                    }
            else {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(likedYou, id: \.self) { userId in
                        if let photoURL = profiles[userId] {
                            Button(action: {
                                selectedUserId = userId // Set the selected user ID when an image is clicked
                            }) {
                                ProfileImageView(photoURL: photoURL)
                            }
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
        }
    }

    private func fetchLikedYou() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userDocument = db.collection("users").document(currentUserId)

        userDocument.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching liked_you: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data() {
                print("Document data: \(data)")  // Debug print to see entire document data
                
                if let userType = data["user_type"] as? Int {
                    if userType == 1 {
                        // Employer, fetch likes_you from the profile subcollection
                        fetchLikedYouFromProfileSubcollection(userDocument: userDocument)
                    } else {
                        // Employee, fetch likes_you from the main document
                        if let likedYouArray = data["likes_you"] as? [String] {
                            self.likedYou = likedYouArray
                            fetchUserPhotos(userIds: likedYouArray)
                        } else {
                            print("likes_you array is either empty or not found")
                        }
                    }
                } else {
                    print("User type is not found in the document")
                }
            } else {
                print("Document does not exist or no data found")
            }
        }
    }

    private func fetchLikedYouFromProfileSubcollection(userDocument: DocumentReference) {
        let profileDocument = userDocument.collection("profile").document("profile_data")
        
        profileDocument.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching liked_you from profile subcollection: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data(), let likedYouArray = data["likes_you"] as? [String] {
                self.likedYou = likedYouArray
                fetchUserPhotos(userIds: likedYouArray)
            } else {
                print("No likes_you data found in the profile subcollection")
            }
        }
    }

    private func fetchUserPhotos(userIds: [String]) {
        let db = Firestore.firestore()

        for userId in userIds {
            db.collection("users").document(userId).getDocument { snapshot, error in
                if let data = snapshot?.data() {
                    let userType = data["user_type"] as? Int
                    let photoURL: String?

                    if userType == 0 {
                        // If the user is an employee (type 0), use personality_photo
                        photoURL = data["personality_photo"] as? String
                    } else {
                        // If the user is an employer (type 1), use photo
                        photoURL = data["photo"] as? String
                    }

                    if let photoURL = photoURL {
                        DispatchQueue.main.async {
                            self.profiles[userId] = photoURL
                            print("Fetched photoURL: \(photoURL) for user: \(userId)")  // Debug print
                        }
                    } else {
                        print("No photoURL found for user: \(userId)")
                    }
                } else {
                    print("Error fetching user document for user: \(userId)")
                }
            }
        }
    }
}

struct ProfileImageView: View {
    var photoURL: String

    var body: some View {
        VStack(spacing: 10) {
            // Image Box
            AsyncImage(url: URL(string: photoURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 180)  // Adjusted size for 2-column layout
                    .cornerRadius(10)
            } placeholder: {
                Color.gray
                    .frame(width: 140, height: 180)  // Adjusted size for 2-column layout
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    LikedView()
        .environmentObject(AppViewModel()) // Ensure the appViewModel is available for preview
}
