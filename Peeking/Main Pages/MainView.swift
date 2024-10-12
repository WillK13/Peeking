//
//  MainView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SwiftUIPager

// Custom shape for the next profile. It is a rectangle with only the top two corners rounded.
struct TopCornersRounded: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Main view
struct MainView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var showTierView = false
    @State private var showSearchSettings = false
    @State private var showOverlay = false
    @State private var likesRemaining = 0
    @State private var step = 0
    @State private var recommendationUserIds: [String] = []
    @State private var currentIndex = 0
    @State private var buttons = true
    @State private var showShareSheet = false

    @State private var page: Page = .first()
    @State private var showNoMatchesMessage = false

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    // Top Area
                    HStack {
                        Button(action: {
                            showShareSheet.toggle()
                        }) {
                            Image("share")
                                .shadow(radius: 2)
                        }
                        ZStack {
                            Image(systemName: "heart.fill").shadow(radius: 2)
                                .foregroundColor(.white)
                                .font(.system(size: 50))
                            Text("\(likesRemaining)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("TopOrange"))
                        }

                        Spacer()

                        Image("Duck_Head")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80).shadow(radius: 2)
                        Spacer()

                        Button(action: {
                            showSearchSettings.toggle()
                        }) {
                            Image("toggle")
                        }.shadow(radius: 2)

                        Button(action: {
                            showTierView.toggle()
                        }) {
                            Image(systemName: "bag")
                                .foregroundColor(Color.white)
                                .font(.system(size: 45))
                        }.shadow(radius: 2)
                    }
                    .padding(.horizontal, 20.0)

                    // Main Area
                    if showNoMatchesMessage {
                        Text("No potential matches, come back later")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        Pager(page: page, data: recommendationUserIds.indices, id: \.self) { index in
                            VStack {
                                if appViewModel.userType == 0 {
                                    ProfileCardViewEmployer(currentStep: $step, userId: .constant(recommendationUserIds[index]), needsButtons: $buttons)
                                        .environmentObject(appViewModel)
                                } else {
                                    ProfileCardView(currentStep: $step, userId: .constant(recommendationUserIds[index]), needsButtons: $buttons)
                                        .environmentObject(appViewModel)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .vertical()
                        .onPageChanged { newIndex in
                            let swipedUserId = recommendationUserIds[newIndex]
                            addToSeenProfiles(userId: swipedUserId)
                            
                            if newIndex == recommendationUserIds.count - 1 {
                                fetchMoreRecommendations()
                            }
                        }
                    }

                    Spacer()
                }

                if showOverlay {
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showOverlay.toggle()
                        }

                    VStack {
                        Spacer()
                        Button(action: {
                            // Handle report action
                        }) {
                            HStack {
                                Image(systemName: "exclamationmark.circle")
                                    .foregroundColor(.red)
                                Text("Report")
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        }
                        .padding()
                        Spacer()
                    }
                }
            }.sheet(isPresented: $showShareSheet) {
                ShareSheet(items: ["Check out my profile on Peeking! https://peeking.ai"])
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showTierView) {
                if appViewModel.userType == 1 {
                    EmployerTiersView()
                } else {
                    EmployeeTierView()
                }
            }
            .sheet(isPresented: $showSearchSettings) {
                if appViewModel.userType == 1 {
                    ToggleViewEmployer()
                } else {
                    ToggleView()
                }
            }
            .onAppear {
                fetchUserDetails()
            }
        }
    }

    private func fetchUserDetails() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        if appViewModel.userType == 0 {
            // For users of type 0 (Employee), data is in the main user document
            let docRef = db.collection("users").document(userId)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    self.likesRemaining = data?["likes_remaining"] as? Int ?? 0
                    self.recommendationUserIds = data?["recommendations"] as? [String] ?? []
                    self.currentIndex = 0
                } else {
                    print("Document does not exist")
                }
            }
        } else if appViewModel.userType == 1 {
            // For users of type 1 (Employer), data is in the profile subcollection
            let profileRef = db.collection("users").document(userId).collection("profile").document("profile_data")

            profileRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    self.likesRemaining = data?["likes_remaining"] as? Int ?? 0
                    self.recommendationUserIds = data?["recommendations"] as? [String] ?? []
                    self.currentIndex = 0
                } else {
                    print("Document does not exist")
                }
            }
        }
    }


    private func fetchMoreRecommendations() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Call the match API
        APIClient.shared.match(userId: userId, userType: appViewModel.userType ?? 0) { result in
            switch result {
            case .success:
                // If the API call was successful, fetch the updated recommendations from Firestore
                self.fetchUpdatedRecommendations(for: userId)
            case .failure(let error):
                print("Failed to fetch more recommendations: \(error.localizedDescription)")
            }
        }
    }

    private func fetchUpdatedRecommendations(for userId: String) {
        let db = Firestore.firestore()

        if appViewModel.userType == 0 {
            // Employee, data is in the main user document
            let docRef = db.collection("users").document(userId)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let newRecommendations = document.data()?["recommendations"] as? [String] ?? []
                    if newRecommendations.isEmpty {
                        self.showNoMatchesMessage = true
                    } else {
                        self.recommendationUserIds.append(contentsOf: newRecommendations)
                        self.showNoMatchesMessage = false
                    }
                } else {
                    print("Document does not exist")
                    self.showNoMatchesMessage = true
                }
            }
        } else if appViewModel.userType == 1 {
            // Employer, data is in the profile subcollection
            let profileRef = db.collection("users").document(userId).collection("profile").document("profile_data")

            profileRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let newRecommendations = document.data()?["recommendations"] as? [String] ?? []
                    if newRecommendations.isEmpty {
                        self.showNoMatchesMessage = true
                    } else {
                        self.recommendationUserIds.append(contentsOf: newRecommendations)
                        self.showNoMatchesMessage = false
                    }
                } else {
                    print("Document does not exist")
                    self.showNoMatchesMessage = true
                }
            }
        }
    }




    private func addToSeenProfiles(userId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        if appViewModel.userType == 0 {
            // Employee, update seen_profiles in the main user document
            let userRef = db.collection("users").document(currentUserId)
            userRef.getDocument { document, error in
                if let document = document, document.exists {
                    var seenProfiles = document.data()?["seen_profiles"] as? [String] ?? []

                    if seenProfiles.count >= 50 {
                        seenProfiles.removeFirst()
                    }

                    seenProfiles.append(userId)
                    userRef.updateData(["seen_profiles": seenProfiles])
                    
                    // Update the status to 1 in the likes_sent subcollection
                    updateLikeStatus(userId: currentUserId, targetUserId: userId, status: 1)
                }
            }
        } else {
            // Employer, update seen_profiles in the profile subcollection
            let profileRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
            profileRef.getDocument { document, error in
                if let document = document, document.exists {
                    var seenProfiles = document.data()?["seen_profiles"] as? [String] ?? []

                    if seenProfiles.count >= 50 {
                        seenProfiles.removeFirst()
                    }

                    seenProfiles.append(userId)
                    profileRef.updateData(["seen_profiles": seenProfiles])
                    
                    // Update the status to 1 in the likes_sent subcollection
                    updateLikeStatus(userId: currentUserId, targetUserId: userId, status: 1)
                }
            }
        }
    }

    private func updateLikeStatus(userId: String, targetUserId: String, status: Int) {
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                if let userType = document.data()?["user_type"] as? Int, userType == 1 {
                    // Employer: update in profile subcollection
                    let profileRef = db.collection("users").document(userId).collection("profile").document("profile_data").collection("likes_sent").document(targetUserId)
                    profileRef.updateData(["status": status])
                } else {
                    // Employee: update in main document's subcollection
                    let likesSentRef = db.collection("users").document(userId).collection("likes_sent").document(targetUserId)
                    likesSentRef.updateData(["status": status])
                }
            } else if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
            }
        }
    }

}

#Preview {
    MainView()
}
