//
//  DesiredTechnicals.swift
//  Peeking
//
//  Created by Will kaminski on 6/21/24.
//

import SwiftUI
import FirebaseAuth

struct DesiredTechnicals: View {
    @Environment(\.presentationMode) var presentationMode
    var fromEditProfile: Bool // Flag to indicate if opened from EditProfile

    @State private var technicalSkills: String = ""
    @State private var certifications: String = ""
    @State private var isSaving: Bool = false
    @State private var navigateToNextView: Bool = false
    
    let technicalSkillsLimit = 400
    let certificationsLimit = 300

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
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color("UnimportantText"))
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color("UnimportantText"))
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
                        }
                        .padding(.leading)
                        
                        HStack {
                            Spacer()
                            Text("Desired Technicals")
                                .font(.largeTitle)
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
                        // Technical Skills
                        VStack(alignment: .leading) {
                                CustomTextField2(title: "1. Give us a bank of desired technical skills for this position.", text: $technicalSkills, characterLimit: technicalSkillsLimit)
                                
                        }
                        .padding(.bottom, 20)
                        
                        // Certifications
                        VStack(alignment: .leading) {
                            CustomTextField(title: "2. List any technical or professional certifications you look for in this positon.", text: $certifications, characterLimit: certificationsLimit)
                        }
                        
                        Spacer()
                        if !fromEditProfile {
                            HStack {
                                Spacer()
                                // Next Button
                                NavigationLink(destination: honestyemployer().navigationBarBackButtonHidden(true), isActive: $navigateToNextView) {
                                    Button(action: {
                                        Task {
                                            await saveTechnicalSkills()
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
                                }.disabled(!isFormComplete() || isSaving)
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
        return !technicalSkills.isEmpty && !certifications.isEmpty
    }

    func saveTechnicalSkills() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            isSaving = true
            try await ProfileUpdaterEmployer.shared.updateTechnicalSkills(
                userId: userId,
                technicalSkills: technicalSkills,
                certifications: certifications
            )
            isSaving = false
            navigateToNextView = true
        } catch {
            isSaving = false
            // Handle error
        }
    }
}

#Preview {
    DesiredTechnicals(fromEditProfile: false)
}
