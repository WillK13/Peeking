//
//  softskillsemployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/21/24.
//

import SwiftUI
import FirebaseAuth

struct softskillsemployer: View {
    @Environment(\.presentationMode) var presentationMode
    var fromEditProfile: Bool // Flag to indicate if opened from EditProfile

    @State private var workEnvironment: String = ""
    @State private var teamDynamics: String = ""
    @State private var workFlexibility: String = ""
    @State private var supportResources: String = ""
    @State private var goodManagement: String = ""
    @State private var positivenv: String = ""
    @State private var isSaving: Bool = false
    @State private var navigateToNextView: Bool = false
    
    let characterLimit = 150

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(alignment: .leading) {
                        // Custom back arrow
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            Spacer()
                            if fromEditProfile {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 30.0)
                                    .font(.system(size: 70))
                                Spacer()
                                
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("Done")
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color(.white))
                                        .cornerRadius(5)
                                }
                            }
                        }
                        .padding(.leading)
                        
                        HStack {
                            Spacer()
                            Text("Let’s Understand Your Desired Soft-Skills")
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                                .padding(.top)
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Text("These will NOT be publicly visible")
                                .font(.subheadline)
                                .italic()
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            CustomTextField(title: "1. What personal qualities you prioritize when hiring new employees?", text: $workEnvironment, characterLimit: characterLimit)
                            CustomTextField(title: "2. Which soft-skills do you consider most valuable in your employees?", text: $teamDynamics, characterLimit: characterLimit)
                            CustomTextField(title: "3. What soft-skills are most important for effective teamwork in your organization?", text: $workFlexibility, characterLimit: characterLimit)
                            CustomTextField(title: "4. How do you expect potential employees to solve challenges or conflicts?", text: $supportResources, characterLimit: characterLimit)
                            CustomTextField(title: "5. Which interpersonal skills do you look for to ensure good relationships with colleagues and clients?", text: $goodManagement, characterLimit: characterLimit)
                            CustomTextField(title: "6. What do you believe is key to maintaining a positive work environment?", text: $positivenv, characterLimit: characterLimit)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        if !fromEditProfile {
                            HStack {
                                Spacer()
                                // Next Button
                                NavigationLink(destination: hobbiesemployer(fromEditProfile: false), isActive: $navigateToNextView) {
                                    Button(action: {
                                        Task {
                                            await saveSoftSkills()
                                        }
                                    }) {
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(isFormComplete() ? Color.black : Color.gray)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(25)
                                            .shadow(radius: 10)
                                    }
                                    .disabled(!isFormComplete() || isSaving)
                                    .padding(.top, 30)
                                    .padding(.bottom, 50)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarBackButtonHidden(true)
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func isFormComplete() -> Bool {
        return !workEnvironment.isEmpty &&
               !teamDynamics.isEmpty &&
               !workFlexibility.isEmpty &&
               !supportResources.isEmpty &&
               !goodManagement.isEmpty &&
               !positivenv.isEmpty
    }

    func saveSoftSkills() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            isSaving = true
            let softSkills = [workEnvironment, teamDynamics, workFlexibility, supportResources, goodManagement, positivenv]
            try await ProfileUpdaterEmployer.shared.updateSoftSkills(userId: userId, softSkills: softSkills)
            isSaving = false
            navigateToNextView = true
        } catch {
            isSaving = false
            // Handle error
        }
    }
}

#Preview {
    softskillsemployer(fromEditProfile: false)
}
