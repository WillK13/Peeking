//
//  TechnicalsEmployee.swift
//  Peeking
//
//  Created by Will kaminski on 6/23/24.
//

import SwiftUI
import FirebaseAuth

struct TechnicalsEmployee: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var technicalSkills: String = ""
    @State private var certifications: String = ""
    @State private var navigateToNextView: Bool = false
    var fromEditProfile: Bool // Flag to indicate if opened from EditProfile

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
                            Text("Technicals")
                                .font(.largeTitle)
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
                            CustomTextField2(title: "1. Give us a bank of your technical skills.", text: $technicalSkills, characterLimit: technicalSkillsLimit)
                        }
                        .padding(.bottom, 20)
                        
                        // Certifications
                        VStack(alignment: .leading) {
                            CustomTextField(title: "2. Please list any technical or professional certifications you have.", text: $certifications, characterLimit: certificationsLimit)
                        }
                        
                        Spacer()
                        if !fromEditProfile {
                            HStack {
                                Spacer()
                                // Next Button
                                NavigationLink(destination: HonestyStatement().navigationBarBackButtonHidden(true), isActive: $navigateToNextView) {
                                    Button(action: {
                                        Task {
                                            await saveTechnicals()
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
        return !technicalSkills.isEmpty && !certifications.isEmpty
    }
    
    func saveTechnicals() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        do {
            try await ProfileUpdater.shared.updateTechnicals(userId: userId, technicalSkills: technicalSkills, certifications: certifications)
            navigateToNextView = true
        } catch {
            // Handle error
        }
    }
}

struct TextEditorWithLimit: View {
    @Binding var text: String
    var characterLimit: Int
    var placeholder: String
    
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                if text.isEmpty && !isEditing {
                    Text(placeholder)
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
                    .padding(.horizontal)
            }
            Text("\(text.count)/\(characterLimit) characters")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.trailing)
                .frame(alignment: .trailing)
        }
    }
}


struct CustomTextField2: View {
    var title: String
    @Binding var text: String
    var characterLimit: Int
    
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text(title)
                    
                
                VStack(alignment: .leading) {
                    Text("Inspiration:")
                        .font(.body)
                    Text("1. Landscaper - Pest Management")
                        .font(.body)
                    Text("2. Software Engineer - Python, C++")
                        .font(.body)
                    Text("3. Chef - Menu Planning")
                        .font(.body)
                }
                .foregroundColor(.gray)
                .padding(.trailing, 30)
                .italic()
            }.padding().padding(.trailing, 30)
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





struct TechnicalsEmployee_Previews: PreviewProvider {
    static var previews: some View {
        TechnicalsEmployee(fromEditProfile: false)
    }
}
