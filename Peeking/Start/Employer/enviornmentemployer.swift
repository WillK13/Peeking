//
//  enviornmentemployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/21/24.
//

import SwiftUI

struct enviornmentemployer: View {
    @Environment(\.presentationMode) var presentationMode
    var fromEditProfile: Bool // Flag to indicate if opened from EditProfile

    
    @State private var answer1: String = ""
    @State private var answer2: String = ""
    @State private var answer3: String = ""
    @State private var answer4: String = ""
    @State private var answer5: String = ""
    
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
                            Text("Tell Us About Your Work Environment")
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
                        // Questions
                        VStack(alignment: .leading, spacing: 20) {
                            CustomTextField(title: "Briefly describe the general work environment at your company.", text: $answer1, characterLimit: characterLimit)
                            CustomTextField(title: "What kind of team dynamics do you promote in your workplace?", text: $answer2, characterLimit: characterLimit)
                            CustomTextField(title: "3. What level of flexibility do you offer in work hours for your employees?", text: $answer3, characterLimit: characterLimit)
                            CustomTextField(title: "4. What types of support or resources do you provide to your employees?", text: $answer4, characterLimit: characterLimit)
                            CustomTextField(title: "5. How would you describe your management approach and style?", text: $answer5, characterLimit: characterLimit)
                        }
                        .padding(.bottom, 20)
                        
                        Spacer()
                        if !fromEditProfile {
                        HStack {
                            Spacer()
                            // Next Button
                            NavigationLink(destination: softskillsemployer(fromEditProfile: false)) {
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
                    }
                    .padding()
                    .navigationBarBackButtonHidden(true)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func isFormComplete() -> Bool {
        return !answer1.isEmpty && !answer2.isEmpty && !answer3.isEmpty && !answer4.isEmpty && !answer5.isEmpty
    }
}

#Preview {
    enviornmentemployer(fromEditProfile: false)
}
