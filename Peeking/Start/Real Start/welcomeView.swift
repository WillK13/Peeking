//
//  Welcome.swift
//  Peeking
//
//  Created by Will kaminski on 6/15/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Welcome: View {
    
    var gradientBackground: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack {
                    Spacer()
                    
                    
                    Text("Choose Your Route")
                        .italic()
                        .font(.title)
                        .padding(.vertical, 20)
                    Spacer()
                    VStack(spacing: 20) {
                        NavigationLink(destination: ProfileSetupViewEmployee(fromEditProfile: false)) {
                            HStack {
                                Image("welcomeduck")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing, 10)
                                VStack(alignment: .leading) {
                                    Text("New Profile")
                                        .font(.body)
                                        .foregroundColor(.black)
                                        .italic()
                                    Text("Job-Seeker")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(30)
                            .background(Color.white)
                            .cornerRadius(15)
                        }.padding(.bottom, 50)
                        .simultaneousGesture(TapGesture().onEnded {
                            Task {
                                do {
                                    if let userId = Auth.auth().currentUser?.uid {
                                        try await UserManager.shared.updateUserProfileType(userId: userId, userType: 0)
                                        let shareID = try await UserManager.shared.generateUniqueShareID()
                                        let additionalData: [String: Any] = [
                                            "name": "",
                                            "location": GeoPoint(latitude: 0, longitude: 0),
                                            "age": 0,
                                            "birthday": Date(),
                                            "languages": [],
                                            "education": [],
                                            "distance": 100,
                                            "fields": [],
                                            "work_setting": [],
                                            "status": [],
                                            "start": [],
                                            "technicals": [],
                                            "soft_skills": [],
                                            "workEnvio": [],
                                            "hobbies": "",
                                            "chats": [],
                                            "pfp": "",
                                            "personality_photo": "",
                                            "share_id": shareID
                                        ]
                                        try await UserManager.shared.updateUserProfileForEmployee(userId: userId, additionalData: additionalData)
                                    }
                                } catch {
                                    print("Failed to update user profile for Job-Seeker.")
                                }
                            }
                        })

                        
                        NavigationLink(destination: newposition()) {
                            HStack {
                                Image("welcomeduck")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing, 10)
                                VStack(alignment: .leading) {
                                    Text("New Profile")
                                        .font(.body)
                                        .foregroundColor(.black)
                                        .italic()
                                    Text("Employer")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(30)
                            .padding(.horizontal, 12)
                            .background(Color.white)
                            .cornerRadius(15)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            Task {
                                do {
                                    if let userId = Auth.auth().currentUser?.uid {
                                        try await UserManager.shared.updateUserProfileType(userId: userId, userType: 1)
                                        let shareID = try await UserManager.shared.generateUniqueShareID()
                                        let additionalData: [String: Any] = [
                                            "logo": "",
                                            "name": "",
                                            "positions": [],
                                            "languages": [],
                                            "type": [],
                                            "mission": "",
                                            "hobbies": "",
                                            "photo": "",
                                            "share_id": shareID
                                        ]
                                        try await UserManager.shared.updateUserProfileForEmployer(userId: userId, additionalData: additionalData)
                                    }
                                } catch {
                                    print("Failed to update user profile for Employer.")
                                }
                            }
                        })

                    }
                    HStack {
                        Spacer()
                    Button(action: {
                        // Action for invite code
                    }) {
                        Text("I have an invite code")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 50)
                            .background(Color.white)
                            .cornerRadius(15)
                    }
                    .padding(.top, 15)
                        Spacer()
                }
                    Spacer()
                    Text("Guest?")
                        .italic()
                        .font(.title)
                        .padding(.vertical, 20)
                    Text("Search Peeking Tag")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .background(Color.white)
                        .cornerRadius(15)
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
