//
//  BookmarkView.swift
//  Peeking
//
//  Created by Will kaminski on 8/26/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct BookmarkView: View {
    @State private var photoURL: URL?
    @Binding var showBookmarkView: Bool // Binding to control the visibility of the view
    @State private var bookmarkedUserId: String? // Store the bookmarked user's ID
    
    var body: some View {
        ZStack {
            // Background that will close the popup when tapped
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showBookmarkView = false // Close the popup when background is tapped
                }

            // Popup content
            if let url = photoURL, let userId = bookmarkedUserId {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            showBookmarkView = false // Close the popup
                        }) {
                            Text("X")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                    }
                    
                    NavigationLink(destination: ProfileShare(userId: .constant(userId), needsButtons: .constant(true)).navigationBarBackButtonHidden()) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                                .background(Color.white)
                        }
                    }
                }
                .background(Color.gray)
                .cornerRadius(25)
                .shadow(radius: 10)
                .padding()
            } else {
                Text("No Bookmark Found")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding()
            }
        }
        .onAppear {
            fetchBookmarkPhoto()
        }
    }

    private func fetchBookmarkPhoto() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        let userDocRef = db.collection("users").document(currentUserId)
        
        userDocRef.getDocument { document, error in
            if let document = document, document.exists {
                if let userType = document.data()?["user_type"] as? Int {
                    let bookmarkSourceDocRef: DocumentReference
                    
                    // Determine whether to look in the main document or the profile subcollection
                    if userType == 1 {
                        bookmarkSourceDocRef = db.collection("users").document(currentUserId).collection("profile").document("profile_data")
                    } else {
                        bookmarkSourceDocRef = userDocRef
                    }
                    
                    bookmarkSourceDocRef.getDocument { bookmarkDocument, error in
                        if let bookmarkDocument = bookmarkDocument, bookmarkDocument.exists {
                            if let bookmarks = bookmarkDocument.data()?["bookmarks"] as? [String], !bookmarks.isEmpty {
                                self.bookmarkedUserId = bookmarks[0]
                                
                                db.collection("users").document(bookmarks[0]).getDocument { userDocument, error in
                                    if let userDocument = userDocument, userDocument.exists {
                                        let bookmarkedUserType = userDocument.data()?["user_type"] as? Int ?? 0
                                        if bookmarkedUserType == 1 {
                                            if let photoURLString = userDocument.data()?["photo"] as? String {
                                                self.photoURL = URL(string: photoURLString)
                                            }
                                        } else {
                                            if let personalityPhotoURLString = userDocument.data()?["personality_photo"] as? String {
                                                self.photoURL = URL(string: personalityPhotoURLString)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BookmarkView(showBookmarkView: .constant(true))
}
