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
                VStack {
                    Spacer()
                    
                    Text("Welcome")
                        .font(.largeTitle)
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    Text("Choose your route:")
                        .italic()
                        .font(.title)
                        .padding(.vertical, 20)
                    
                    VStack(spacing: 20) {
                        NavigationLink(destination: ProfileSetupViewEmployee(fromEditProfile: false)) {
                            HStack {
                                Image("Duck_Head")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing, 10)
                                VStack(alignment: .leading) {
                                    Text("New Profile")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Text("Job-Seeker")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(30)
                            .background(gradientBackground)
                            .cornerRadius(15)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            Task {
                                do {
                                    if let userId = Auth.auth().currentUser?.uid {
                                        try await UserManager.shared.updateUserProfileType(userId: userId, userType: 0)
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
                                            "personality_photo": ""
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
                                Image("Duck_Head")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing, 10)
                                VStack(alignment: .leading) {
                                    Text("New Profile")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Text("Employer")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(30)
                            .background(gradientBackground)
                            .cornerRadius(15)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            Task {
                                do {
                                    if let userId = Auth.auth().currentUser?.uid {
                                        try await UserManager.shared.updateUserProfileType(userId: userId, userType: 1)
                                        let additionalData: [String: Any] = [
                                            "logo": "",
                                            "name": "",
                                            "positions": [],
                                            "languages": [],
                                            "type": [],
                                            "mission": "",
                                            "workEnvio": "",
                                            "soft_skills": [],
                                            "hobbies": "",
                                            "photo": ""
                                        ]
                                        try await UserManager.shared.updateUserProfileForEmployer(userId: userId, additionalData: additionalData)
                                    }
                                } catch {
                                    print("Failed to update user profile for Employer.")
                                }
                            }
                        })
                    }
                    
                    Button(action: {
                        // Action for invite code
                    }) {
                        Text("I have an invite code")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding()
                            .background(gradientBackground)
                            .cornerRadius(15)
                    }
                    .padding(.top, 15)
                    .padding(.leading, 50)
                    
                    Spacer()
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
