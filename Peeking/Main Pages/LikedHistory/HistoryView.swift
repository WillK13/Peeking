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

                Text("Likes Sent")
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
            Image("tgheartmain")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.leading, 45)
                .frame(width: 150)
                .foregroundColor(.white)
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
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(likesSent, id: \.user_id) { like in
                    if let photoURL = profiles[like.user_id] {
                        LikeHistoryItemView(photoURL: photoURL, status: like.status)
                    }
                }
            }
            .padding(.horizontal, 15)
        }
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
