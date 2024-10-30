//
//  ProfileViewEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileViewEmployer: View {
    // Variables for positions and pop-up views
    @State private var selectedPosition = "Position name"
    @State private var positions: [Position] = [Position(title: "Position name", id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString)]
    @State private var showSettings = false
    @State private var showTips = false
    @State private var showProfileDetail = false
    @State private var showDeleteConfirmation = false
    @State private var showEditProfile = false
    @State private var showFirstView = false
    @State private var showProfileShare = false
    @State private var photoURL: String? = nil
    @State private var logoURL: String? = nil
    @State private var companyName: String = "Name"
    @State private var shareId: String = "..."
    @State private var isVisible = true
    @State private var showShareSheet = false



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
            .padding(.bottom)
            // Content
            VStack {
                
                // Top section with settings and tips buttons
                HStack {
                    VStack(alignment: .leading) {
                      
                            Text(companyName)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                       
                        CustomMenu {
                            ForEach(positions, id: \.id) { position in
                                if position.title == "Locked position" {
                                    Text(position.title)
                                        .foregroundColor(.gray)
                                        .padding()
                                } else {
                                    Button(action: {
                                        selectedPosition = position.title
                                    }) {
                                        Text(position.title)
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedPosition)
                                    .foregroundColor(Color.black)
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        }
                        .onAppear {
                            loadCompanyName()
                            loadPositions()
                            loadUserPhoto()
                            loadShareId()
                            loadLogo()
                        }
                    }.padding(.leading, 50)
                    
                    Spacer()
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
                            .padding(.horizontal, 10.0).padding(.trailing, 10)
                        
                    }.padding(.trailing, 10)
                }
                .padding(.top, 40).padding(.trailing, 20)
                
                // User's photo with logo overlay
                ZStack {
                    if let photoURL = photoURL {
                        AsyncImage(url: URL(string: photoURL)) { image in
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
                    VStack {
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        HStack {
                            Spacer()
                            // Overlay the logo on top of the profile image
                            if let logoURL = logoURL {
                                AsyncImage(url: URL(string: logoURL)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                                        .padding(10)
                                } placeholder: {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                        .padding(10)
                                }
                                //                        .offset(x: -500, y: -40) // Adjust the position of the logo as needed
                            }
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 20) {
                    Spacer()
                    Text(shareId)
                        .foregroundColor(Color.white)
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
            EditProfileEmployer()
        }
        .sheet(isPresented: $showTips) {
            TipsView()
        }
        .fullScreenCover(isPresented: $showFirstView) {
            newposition()
        }
        .fullScreenCover(isPresented: $showProfileShare) {
            ProfileShare(userId: .constant(Auth.auth().currentUser?.uid ?? ""), needsButtons: .constant(false))
                .environmentObject(AppViewModel())
        }
    }
    
    // Function to load the employer's positions from Firestore
    private func loadPositions() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).collection("profile").document("profile_data").getDocument { document, error in
            if let document = document, document.exists {
                if let title = document.data()?["title"] as? String, !title.isEmpty {
                    self.positions = [Position(title: title, id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString)]
                    self.selectedPosition = title
                } else {
                    self.positions = [Position(title: "Position name", id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString), Position(title: "Locked position", id: UUID().uuidString)]
                }
            } else {
                print("Profile document does not exist")
            }
        }
    }
    
    // Function to load the employer's photo from Firestore
    private func loadUserPhoto() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                if let photo = document.data()?["photo"] as? String {
                    fetchPhoto(userId: userId, photo: photo)
                } else {
                    print("Photo not found in user document")
                }
            } else {
                print("User document does not exist")
            }
        }
    }

    // Function to fetch the photo URL from Firebase Storage
    private func fetchPhoto(userId: String, photo: String) {
        StorageManager.shared.getProfileImageURL(userId: userId, folder: "photo") { result in
            switch result {
            case .success(let url):
                self.photoURL = url
            case .failure(let error):
                print("Failed to fetch photo URL: \(error)")
            }
        }
    }

    // Function to load the company name from Firestore
    private func loadCompanyName() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                self.companyName = document.data()?["name"] as? String ?? "Company Name Not Found"
            } else {
                print("User document does not exist")
            }
        }
    }
    
    // Function to load the share ID from the profile subcollection
    private func loadShareId() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).collection("profile").document("profile_data").getDocument { document, error in
            if let document = document, document.exists {
                self.shareId = document.data()?["share_id"] as? String ?? "No Share ID"
            } else {
                print("Profile document does not exist")
            }
        }
    }

    // Function to load the employer's logo from Firestore
    private func loadLogo() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                if let logo = document.data()?["logo"] as? String {
                    fetchLogo(userId: userId, logo: logo)
                } else {
                    print("Logo not found in user document")
                }
            } else {
                print("User document does not exist")
            }
        }
    }

    // Function to fetch the logo URL from Firebase Storage
    private func fetchLogo(userId: String, logo: String) {
        StorageManager.shared.getProfileImageURL(userId: userId, folder: "logo") { result in
            switch result {
            case .success(let url):
                self.logoURL = url
            case .failure(let error):
                print("Failed to fetch logo URL: \(error)")
            }
        }
    }
}

// Position struct to ensure unique IDs for each position
struct Position: Identifiable {
    var title: String
    var id: String
}

// Custom menu to handle disabled options
struct CustomMenu<Content: View, Label: View>: View {
    let content: Content
    let label: Label

    init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.content = content()
        self.label = label()
    }

    var body: some View {
        Menu {
            content
        } label: {
            label
        }
    }
}

#Preview {
    ProfileViewEmployer()
}
