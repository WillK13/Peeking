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
                            VStack {
                                Text("1. Give us a bank of desired technical skills for this position.")
                                    .padding([.top, .horizontal])
                                    .padding(.bottom, 5)
                                    .cornerRadius(10)
                                    .fixedSize(horizontal: false, vertical: true) // Prevent cutting off
                                VStack(alignment: .leading) {
                                    Text("Inspiration:")
                                    Text("1. Landscaper - \"Pest Management\"")
                                    Text("2. Software Engineer - \"Python, C++\"")
                                    Text("3. Chef - \"Menu Planning\"")
                                }
                                .foregroundColor(.gray)
                                .padding(.trailing, 30)
                                .italic()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding([.horizontal, .bottom])
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                            
                            TextEditorWithLimit(text: $technicalSkills, characterLimit: technicalSkillsLimit, placeholder: "Type here...")
                                .frame(height: 150) // Extended height
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                        }
                        .padding(.bottom, 20)
                        
                        // Certifications
                        VStack(alignment: .leading) {
                            Text("2. List any technical or professional certifications you look for in this positon.")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
                                .fixedSize(horizontal: false, vertical: true)
                            
                            TextEditorWithLimit(text: $certifications, characterLimit: certificationsLimit, placeholder: "Type here...")
                                .frame(height: 150) // Extended height
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
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
                                }
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
