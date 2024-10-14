//
//  HistoryView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HistoryView: View {
    @State private var showAlert = false
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var likesSent: [likes_sent] = []  // Correct initialization of the likesSent array
    @State private var profiles: [String: String] = [:] // [userId: photoURL]
    @State private var selectedUserId: String? = nil // State to hold the selected user ID
    @State private var needsButtons = false // Set this as needed

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

                historyList

                Spacer()
            }
            
            if showAlert {
                alertView
            }
        }
        .animation(.easeInOut, value: showAlert)
        .onAppear {
            fetchLikeHistory()
        }
        .fullScreenCover(item: $selectedUserId) { userId in
            ProfileShare(userId: .constant(userId), needsButtons: $needsButtons)
                .environmentObject(appViewModel)
        }
    }

    private var headerView: some View {
        HStack {
//            Spacer()
//            Image("tgheartmain")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .padding(.leading, 45)
//                .frame(width: 150)
//                .foregroundColor(.white)
            Spacer()
            Text("Likes Sent")
                .font(.largeTitle)
                .padding(.bottom, 10.0)
                .foregroundColor(.white)
                .bold()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Button(action: {
                showAlert = true
            }) {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
            }
        }.padding(.top, 10).padding(.bottom, 20)
    }

    private var historyList: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return ScrollView {
            if likesSent.isEmpty {
                VStack {
                    Image("feet")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100)
                        .padding(.top, 20)
                    Spacer()
                    Text("No Likes Yet")
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(.all)
                        .bold()
                    Text("Users that like your profile will appear here.")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding([.leading, .bottom, .trailing])
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    Spacer()
                }.background(Color.white)
                    .cornerRadius(10).padding(.top, 40).padding(.horizontal, 15)
                    }
            else {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(likesSent, id: \.user_id) { like in
                        if let photoURL = profiles[like.user_id] {
                            Button(action: {
                                selectedUserId = like.user_id // Set the selected user ID when an image is clicked
                            }) {
                                LikeHistoryItemView(photoURL: photoURL, status: like.status)
                            }
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
        }
    }

    private var alertView: some View {
        return CustomAlertView(showAlert: $showAlert)
            .transition(.scale)
    }

    private func fetchLikeHistory() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let collectionPath: CollectionReference

        if let appViewModelUserType = appViewModel.userType, appViewModelUserType == 1 {
            collectionPath = db.collection("users").document(currentUserId).collection("profile").document("profile_data").collection("likes_sent")
        } else {
            collectionPath = db.collection("users").document(currentUserId).collection("likes_sent")
        }

        collectionPath.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching likes_sent documents: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No likes found")
                return
            }

            var likes: [likes_sent] = []  // Initialize as an empty array
            var userIds: [String] = []

            for document in documents {
                // Debug print to see what data is being returned
                print("Document data: \(document.data())")

                if let like = try? document.data(as: likes_sent.self) {  // Ensure correct type
                    likes.append(like)
                    userIds.append(like.user_id)
                } else {
                    print("Failed to decode like document: \(document.data())")
                }
            }

            self.likesSent = likes
            print("Fetched likes: \(likes)")  // Debug print

            // Fetch user photos
            fetchUserPhotos(userIds: userIds)
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
                        // Employee, use personality_photo
                        photoURL = data["personality_photo"] as? String
                    } else {
                        // Employer, use photo
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

#Preview {
    HistoryView()
        .environmentObject(AppViewModel()) // Ensure the appViewModel is available for preview
}
