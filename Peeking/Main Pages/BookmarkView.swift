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
    @State private var bookmarkedUserId: String?
    @EnvironmentObject var appViewModel: AppViewModel// Store the bookmarked user's ID
    
    var body: some View {
        ZStack {
            // Background that will close the popup when tapped
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showBookmarkView = false // Close the popup when background is tapped
                }
                .padding(.top, -10).padding(.bottom, -15)
            
            // Popup content
            if let url = photoURL, let userId = bookmarkedUserId {
                VStack(spacing: 10) {
                    HStack {
                        Button(action: {
                            showBookmarkView = false // Close the popup
                        }) {
                            Text("X")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding([.top, .leading, .trailing])
                        }
                        Spacer()
                    }
                    
                    Text("Bookmarks")
                        .font(.title)
                        .foregroundColor(.black)
                    Text("24 hour holding limit")
                        .font(.body)
                        .foregroundColor(.black)
                        .italic()
                        .padding(.top, -10)
                    HStack(spacing: 20) {
                        ZStack(alignment: .topTrailing) {
                            NavigationLink(destination: ProfileShare(userId: .constant(userId), needsButtons: .constant(true))
                                .navigationBarBackButtonHidden()
                                .toolbar(.hidden, for: .tabBar)) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(5)
                                            .frame(width: 100, height: 175)
                                            .padding(.bottom, 15)
                                            .padding(.bottom, 25)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 100, height: 100)
                                            .background(Color.white)
                                    }
                                }
                                .padding([.top, .leading, .bottom], 20)
                            
                            // Red circle with minus button
                            Button(action: {
                                removeBookmark()
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 20))
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .padding(.top, 20)
                                    .padding(.leading, 15)
                            }
                            /*.offset(x: 10, y: 10)*/ // Position at the top-right of the image
                        }
                        NavigationLink(
                            destination: appViewModel.userType == 1 ? AnyView(EmployerTiersView().toolbar(.hidden, for: .tabBar)) : AnyView(EmployeeTierView().toolbar(.hidden, for: .tabBar))
                        ) {
                        VStack {
                            // Conditionally present EmployerTiersView or EmployeeTierView based on user type
                            
                                Image(systemName: "lock")
                                    .padding(.vertical, 25)
                                    .padding(.horizontal, 10)
                                    .font(.system(size: 75))
                                    .foregroundColor(Color.black)
                                    .background(Color.gray)
                                    .opacity(0.3)
                                    .cornerRadius(5)
                                Text("Get Glider")
                                .foregroundColor(Color.black)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(20)
                                    .padding(.top, 5)
                            }
                        }
                        NavigationLink(
                            destination: appViewModel.userType == 1 ? AnyView(EmployerTiersView().toolbar(.hidden, for: .tabBar)) : AnyView(EmployeeTierView().toolbar(.hidden, for: .tabBar))
                        ) {
                        VStack {
                            
                                Image(systemName: "lock")
                                    .padding(.vertical, 25)
                                    .padding(.horizontal, 10)
                                    .font(.system(size: 75))
                                    .foregroundColor(Color.black)
                                    .background(Color.gray)
                                    .opacity(0.3)
                                    .cornerRadius(5)
                                Text("Get Diver")
                                .foregroundColor(Color.black)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.purple.opacity(0.2))
                                    .cornerRadius(20)
                                    .padding(.top, 5)
                            }.padding(.trailing, 20)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 10)
                .padding(.horizontal, 50)
                .padding(.vertical, 15)
            } else {
                VStack(spacing: 10)
                {
                    Text("Bookmarks")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .padding(.top, 10)
                    Text("24 hour holding limit")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .italic()
                        .padding(.bottom, 10)
                    HStack(spacing: 20) {
                        Image(systemName: "lock.open")
                            .padding(.vertical, 35)
                            .padding(.horizontal, 5)
                            .font(.system(size: 57))
                            .foregroundColor(Color.black)
                            .background(Color.gray)
                            .opacity(0.3)
                            .cornerRadius(5)
                            .padding(.bottom, 38)
                            .padding(.leading, 20)
                        NavigationLink(
                            destination: appViewModel.userType == 1 ? AnyView(EmployerTiersView().toolbar(.hidden, for: .tabBar)) : AnyView(EmployeeTierView().toolbar(.hidden, for: .tabBar))
                        ) {
                        VStack {
                            // Conditionally present EmployerTiersView or EmployeeTierView based on user type
                            
                                Image(systemName: "lock")
                                    .padding(.vertical, 25)
                                    .padding(.horizontal, 10)
                                    .font(.system(size: 75))
                                    .foregroundColor(Color.black)
                                    .background(Color.gray)
                                    .opacity(0.3)
                                    .cornerRadius(5)
                                Text("Get Glider")
                                .foregroundColor(Color.black)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(20)
                                    .padding(.top, 5)
                            }
                        }
                        NavigationLink(
                            destination: appViewModel.userType == 1 ? AnyView(EmployerTiersView().toolbar(.hidden, for: .tabBar)) : AnyView(EmployeeTierView().toolbar(.hidden, for: .tabBar))
                        ) {
                        VStack {
                            
                                Image(systemName: "lock")
                                    .padding(.vertical, 25)
                                    .padding(.horizontal, 10)
                                    .font(.system(size: 75))
                                    .foregroundColor(Color.black)
                                    .background(Color.gray)
                                    .opacity(0.3)
                                    .cornerRadius(5)
                                Text("Get Diver")
                                .foregroundColor(Color.black)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.purple.opacity(0.2))
                                    .cornerRadius(20)
                                    .padding(.top, 5)
                            }.padding(.trailing, 20)
                        }
                        
                    }.padding(.bottom, 20)
                }
                .background(Color.white)
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
    private func removeBookmark() {
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
                    
                    bookmarkSourceDocRef.updateData(["bookmarks": FieldValue.arrayRemove([bookmarkedUserId!])]) { error in
                        if let error = error {
                            print("Error removing bookmark: \(error.localizedDescription)")
                        } else {
                            print("Bookmark removed successfully")
                            self.bookmarkedUserId = nil
                            self.photoURL = nil
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BookmarkView(showBookmarkView: .constant(true)).environmentObject(AppViewModel())
}
