//
//  TechnicalsEmployee.swift
//  Peeking
//
//  Created by Will kaminski on 6/15/24.
//

import SwiftUI

struct TechnicalsEmployee: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var technicalSkills: String = ""
    @State private var certifications: String = ""
    
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
                        }
                        .padding(.leading)
                        
                        HStack {
                            Spacer()
                            Text("Technicals")
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
                                Text("1. Give us a bank of your technical skills.")
                                    .padding([.top, .horizontal])
                                    .padding(.bottom, 5)
                                    .cornerRadius(10)
                                    .fixedSize(horizontal: true, vertical: true) // Prevent cutting off
                                VStack(alignment: .leading) {
                                    Text("Inspiration:")
                                    Text("1. Landscaper - Pest Management")
                                    Text("2. Software Engineer - Python, C++")
                                    Text("3. Chef - Menu Planning")
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
                            Text("2. Please list any technical or professional certifications you have.")
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
                        
                        HStack {
                            Spacer()
                            // Next Button
                            NavigationLink(destination: HonestyStatement()) {
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
                        }
                    }
                    .padding()
                    
                }
            }
        }
    }
    
    func isFormComplete() -> Bool {
        return !technicalSkills.isEmpty && !certifications.isEmpty
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
        TechnicalsEmployee()
    }
}
