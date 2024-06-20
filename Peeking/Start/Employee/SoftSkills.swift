//
//  SoftSkills.swift
//  Peeking
//
//  Created by Will kaminski on 6/15/24.
//

import SwiftUI

struct SoftSkills: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var workEnvironment: String = ""
    @State private var teamDynamics: String = ""
    @State private var workFlexibility: String = ""
    @State private var supportResources: String = ""
    @State private var goodManagement: String = ""
    
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
                        
                        VStack(alignment: .leading, spacing: 20) {
                            CustomTextField(title: "1. Briefly describe your ideal work environment.", text: $workEnvironment, characterLimit: characterLimit)
                            CustomTextField(title: "2. What kind of team dynamics do you prefer in a workplace?", text: $teamDynamics, characterLimit: characterLimit)
                            CustomTextField(title: "3. What level of flexibility in work hours is important to you?", text: $workFlexibility, characterLimit: characterLimit)
                            CustomTextField(title: "4. What types of support or resources do you find essential in a workplace?", text: $supportResources, characterLimit: characterLimit)
                            CustomTextField(title: "5. What characteristics do you value most in good management?", text: $goodManagement, characterLimit: characterLimit)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            // Next Button
                            NavigationLink(destination: WorkEnviornment()) {
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
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    func isFormComplete() -> Bool {
        return !workEnvironment.isEmpty &&
               !teamDynamics.isEmpty &&
               !workFlexibility.isEmpty &&
               !supportResources.isEmpty &&
               !goodManagement.isEmpty
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
                .padding()
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
        SoftSkills()
    }
}
