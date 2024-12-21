//
//  ProfileViewEmployee.swift
//  Peeking
//
//  Created by Will kaminski on 6/10/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import UIKit


struct ProfileViewEmployee: View {
    @State private var showSettings = false
    @State private var showShareSheet = false
    @State private var showTips = false
    @State private var showProfileDetail = false
    @State private var showEditProfile = false
    @State private var showProfileShare = false // To trigger navigation to ProfileShare

    // State variables for storing the user's data
    @State private var userName: String = "Loading..."
    @State private var shareId: String = "..."
    @State private var personalityPhotoURL: String? = nil
    @State private var profilePictureURL: String? = nil
    @State private var isVisible = true

    
    var body: some View {
        // Background
        ZStack {
            BackgroundView()
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.05)]),
                startPoint: .center,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea([.leading, .trailing])
            .padding(.bottom).padding(.bottom, 4).padding(.bottom, 4)
            // Content
            VStack {
                // Top section with settings and tips buttons
                HStack {
                    Spacer()
                    
                    // Profile picture and name
                    if let profilePictureURL = profilePictureURL {
                        AsyncImage(url: URL(string: profilePictureURL)) { image in
                            image
                                .resizable()
                                .cornerRadius(10)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                                .shadow(radius: 5)
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .frame(width: 60)
                                .shadow(radius: 5)
                        }
                    }
                    
                    Text(userName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .onAppear {
                            loadUserData()
                        }
                    Spacer()
                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color.white)
                            .font(.system(size: 40))
                    }
                    .padding(.leading)
                    
                    Button(action: {
                        showTips.toggle()
                    }) {
                        Image("lightbulb")
                            .padding(.horizontal, 10.0)
                        
                    }.padding(.trailing, 10)
                    Spacer()
                }
                .padding(.top, 40)
                
                // User's personality photo
                if let personalityPhotoURL = personalityPhotoURL {
                    AsyncImage(url: URL(string: personalityPhotoURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350, height: 500)
                            .cornerRadius(10)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                            .frame(width: 350, height: 500)
                            .cornerRadius(10)
                    }
                    .onTapGesture {
                        showProfileShare = true
                    }
                } else {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 350, height: 500)
                        .cornerRadius(10)
                        .padding(.horizontal, 50.0)
                        .onTapGesture {
                            showProfileDetail.toggle()
                        }
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 20) {
                    Spacer()
                    Text(shareId)
                        .foregroundColor(Color.white)
//                        .font(.title)
                    Spacer()
                    Button(action: {
                        isVisible.toggle()
                    }) {
                        Image(isVisible ? "openeye" : "tgeye")
                            .shadow(radius: 2)
                    }

                    
                    Button(action: {
                        showEditProfile.toggle()
                    }) {
                        Image("edit")
                            .padding(.leading, 5)
                            .shadow(radius: 2)
                    }
                    Button(action: {
                        showShareSheet.toggle()
                    }) {
                        Image("share")
                            .padding(.bottom, -10)
                            .shadow(radius: 2)
                    }
                    .sheet(isPresented: $showShareSheet) {
                        ShareSheet(items: ["Check out my profile on Peeking! https://peeking.ai"])
                    }

                }
                .padding(.bottom, 90).padding(.top, 10).padding(.trailing, 60)
            }
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $showEditProfile) {
            EditProfile()
        }
        .sheet(isPresented: $showTips) {
            TipsView()
        }
        .fullScreenCover(isPresented: $showProfileShare) {
            ProfileShare(userId: .constant(Auth.auth().currentUser?.uid ?? ""), needsButtons: .constant(false))
//                .environmentObject(AppViewModel())
        }
    }
    
    // Function to load the user's data from Firestore
    private func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.userName = data?["name"] as? String ?? "Name not found"
                self.personalityPhotoURL = data?["personality_photo"] as? String
                self.shareId = data?["share_id"] as? String ?? "No Share ID"
                self.profilePictureURL = data?["pfp"] as? String
            } else {
                print("User document does not exist")
            }
        }
    }
}

#Preview {
    ProfileViewEmployee()
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No need to update anything here
    }
}
