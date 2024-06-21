//
//  softskillsemployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/21/24.
//

import SwiftUI

struct softskillsemployer: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var workEnvironment: String = ""
    @State private var teamDynamics: String = ""
    @State private var workFlexibility: String = ""
    @State private var supportResources: String = ""
    @State private var goodManagement: String = ""
    @State private var positivenv: String = ""

    
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
                            CustomTextField(title: "5. Which interpersonal skills do you look for to ensure good relationships with colleagues and clients??", text: $goodManagement, characterLimit: characterLimit)
                            CustomTextField(title: "5. What do you believe is key to maintaining a positive work environment?", text: $positivenv, characterLimit: characterLimit)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            // Next Button
                            NavigationLink(destination: hobbiesemployer()) {
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
#Preview {
    softskillsemployer()
}
