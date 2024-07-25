//
//  WorkEnviornment.swift
//  Peeking
//
//  Created by Will kaminski on 6/20/24.
//

import SwiftUI
import FirebaseAuth

struct WorkEnviornment: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var answer1: String = ""
    @State private var answer2: String = ""
    @State private var answer3: String = ""
    @State private var answer4: String = ""
    @State private var answer5: String = ""
    @State private var navigateToNextView: Bool = false
    var fromEditProfile: Bool // Flag to indicate if opened from EditProfile

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
                            Text("Tell Us Your Desired Work Environment")
                                .font(.largeTitle)
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
                        // Questions
                        VStack(alignment: .leading, spacing: 20) {
                            CustomTextField(title: "1. Briefly describe your ideal work environment.", text: $answer1, characterLimit: characterLimit)
                            CustomTextField(title: "2. What kind of team dynamics do you prefer in a workplace?", text: $answer2, characterLimit: characterLimit)
                            CustomTextField(title: "3. What level of flexibility in work hours is important to you?", text: $answer3, characterLimit: characterLimit)
                            CustomTextField(title: "4. What types of support or resources do you find essential in a workplace?", text: $answer4, characterLimit: characterLimit)
                            CustomTextField(title: "5. What characteristics do you value most in good management?", text: $answer5, characterLimit: characterLimit)
                        }
                        .padding(.bottom, 20)
                        
                        Spacer()
                        if !fromEditProfile {
                            HStack {
                                Spacer()
                                // Next Button
                                NavigationLink(destination: Hobbies(fromEditProfile: false).navigationBarBackButtonHidden(true), isActive: $navigateToNextView) {
                                    Button(action: {
                                        Task {
                                            await saveWorkEnvironment()
                                        }
                                    }) {
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(.black)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(25)
                                            .shadow(radius: 10)
                                            .opacity(isFormComplete() ? 1.0 : 0.5)
                                    }
                                    .disabled(!isFormComplete())
                                    .padding(.top, 30)
                                    .padding(.bottom, 50)
                                }.disabled(!isFormComplete())
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func isFormComplete() -> Bool {
        return !answer1.isEmpty && !answer2.isEmpty && !answer3.isEmpty && !answer4.isEmpty && !answer5.isEmpty
    }
    
    func saveWorkEnvironment() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let workEnvio = [
            answer1,
            answer2,
            answer3,
            answer4,
            answer5
        ]

        do {
            try await ProfileUpdater.shared.updateWorkEnvironment(userId: userId, workEnvio: workEnvio)
            navigateToNextView = true
        } catch {
            // Handle error
        }
    }
}
struct WorkEnviornment_Previews: PreviewProvider {
    static var previews: some View {
        WorkEnviornment(fromEditProfile: false)
    }
}
