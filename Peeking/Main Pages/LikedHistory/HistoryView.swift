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

                Text("Like History")
                    .font(.largeTitle)
                    .padding(.bottom, 10.0)

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
    }

    private var headerView: some View {
        HStack {
            Spacer()
            Image(systemName: "heart.fill")
                .resizable()
                .frame(width: 120, height: 110)
                .foregroundColor(.white)
                .padding(.bottom, 5.0)
                .padding(.top, 30.0)
            Spacer()
            Button(action: {
                showAlert = true
            }) {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
                    .padding([.top, .trailing], 30)
            }
        }
    }

    private var historyList: some View {
        ScrollView {
            ForEach(likesSent, id: \.user_id) { like in
                if let photoURL = profiles[like.user_id] {
                    LikeHistoryItemView(photoURL: photoURL, status: like.status)
                        .padding(.bottom, 15)
                }
            }
        }
        .padding(.top, 15)
    }

    private var alertView: some View {
        Color.black.opacity(0.4)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                showAlert = false
            }
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
                if let data = snapshot?.data(), let photoURL = data["photo"] as? String {
                    DispatchQueue.main.async {
                        self.profiles[userId] = photoURL
                        print("Fetched photoURL: \(photoURL) for user: \(userId)")  // Debug print
                    }
                } else {
                    print("Error fetching photo for user: \(userId)")
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
