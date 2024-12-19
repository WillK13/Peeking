//
//  SoftSkills.swift
//  Peeking
//
//  Created by Will kaminski on 6/15/24.
//

import SwiftUI
import FirebaseAuth

struct SoftSkills: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var workEnvironment: String = ""
    @State private var teamDynamics: String = ""
    @State private var workFlexibility: String = ""
    @State private var supportResources: String = ""
    @State private var goodManagement: String = ""
    @State private var goodEnv: String = ""
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
                        HStack() {
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color.white)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color("UnimportantText"))
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color("UnimportantText"))
                            Spacer()
                        }
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
                            Image("feather")
                        }
                        .padding(.leading)
                        
                        HStack {
                            Spacer()
                            Text("Show Off Your \n Feathers")
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                                .padding(.top)
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Text("These will be publicly visible")
                                .font(.subheadline)
                                .italic()
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            CustomTextField(title: "1. What do you perceive as your top three personal qualities?", text: $workEnvironment, characterLimit: characterLimit)
                            CustomTextField(title: "2. Which soft-skills do you consider to be your strongest assets in the workplace?", text: $teamDynamics, characterLimit: characterLimit)
                            CustomTextField(title: "3. What are the most important soft-skills you rely on for effective teamwork?", text: $workFlexibility, characterLimit: characterLimit)
                            CustomTextField(title: "4. How do you deal with challenges or conflicts at work?", text: $supportResources, characterLimit: characterLimit)
                            CustomTextField(title: "5. How do you build good relationships with colleagues and clients?", text: $goodManagement, characterLimit: characterLimit)
                            CustomTextField(title: "6. What do you believe forms a positive work environment?", text: $goodEnv, characterLimit: characterLimit)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        if !fromEditProfile {
                            HStack {
                                Spacer()
                                // Next Button
                                NavigationLink(destination: WorkEnviornment(fromEditProfile: false).navigationBarBackButtonHidden(true), isActive: $navigateToNextView) {
                                    Button(action: {
                                        Task {
                                            await saveSoftSkills()
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
        return !workEnvironment.isEmpty &&
               !teamDynamics.isEmpty &&
               !workFlexibility.isEmpty &&
               !supportResources.isEmpty &&
               !goodManagement.isEmpty &&
               !goodEnv.isEmpty
    }
    
    func saveSoftSkills() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let softSkills = [
            workEnvironment,
            teamDynamics,
            workFlexibility,
            supportResources,
            goodManagement,
            goodEnv
        ]

        do {
            try await ProfileUpdater.shared.updateSoftSkills(userId: userId, softSkills: softSkills)
            navigateToNextView = true
        } catch {
            // Handle error
        }
    }
}

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var characterLimit: Int
    
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .padding().padding(.trailing, 30)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                .fixedSize(horizontal: false, vertical: true)
            
            ZStack(alignment: .leading) {
                if text.isEmpty && !isEditing {
                    Text("Type here...")
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                }
                TextEditor(text: $text)
                    .onChange(of: text) { oldValue, newValue in
                        if newValue.count > characterLimit {
                            text = String(newValue.prefix(characterLimit))
                        }
                    }
                    .onTapGesture {
                        isEditing = true
                    }
                    .frame(height: 100)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
            }
            
            Text("\(text.count)/\(characterLimit) characters")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct SoftSkills_Previews: PreviewProvider {
    static var previews: some View {
        SoftSkills(fromEditProfile: false)
    }
}
