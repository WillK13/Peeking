//
//  ProfileSetupViewEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/14/24.
//

import SwiftUI

import SwiftUI

struct ProfileSetupViewEmployer: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var companyName: String = ""
    @State private var companyLogo: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = nil
    @State private var positionTitle: String = ""
    @State private var positionDescription: String = ""
    @State private var selectedStartTime = ""
    @State private var relevantFields = ""
    @State private var workplaceLanguages = ""
    @State private var employerType = ""
    @State private var workSetting = ""
    @State private var employmentType = ""
    @State private var companyMission: String = ""

    let startTimeOptions = ["Option 1", "Option 2", "Option 3"]
    let employerTypeOptions = ["Startup", "Small Business", "Corporate"]
    let workSettingOptions = ["Remote", "In-Person", "Hybrid"]
    let employmentTypeOptions = ["Part-time", "Full-time", "Internship"]

    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    BackgroundView()
                        .edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading) {
                        // Custom back button
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .font(.system(size: 25))
                                    .padding()
                            }
                            Spacer()
                        }
                        .padding(.top)
                        
                        // Form fields
                        VStack(alignment: .leading, spacing: 20) {
                            Group {
                                Text("1. Company Name")
                                TextField("Type here...", text: $companyName)
                                    .padding(.trailing, 150.0)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Text("2. Company Logo (Optional)")
                                VStack {
                                    if let companyLogo = companyLogo {
                                        companyLogo
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                            .clipShape(Rectangle())
                                            .cornerRadius(10)
                                    } else {
                                        HStack {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(height: 165)
                                                .cornerRadius(10)
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .foregroundColor(.gray)
                                                )
                                            Image("uploadimage")
                                        }
                                    }
                                }
                                .padding(.trailing, 100)
                                .onTapGesture {
                                    self.showingImagePicker = true
                                }
                                
                                Text("3. Position Title")
                                Text("Ex: Front Desk Customer Service").italic()
                                    .font(.footnote)
                                    .padding(.top, -10.0)
                                TextField("Type here...", text: $positionTitle)
                                    .padding(.trailing, 100)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Text("4. Position Description")
                                TextEditor(text: $positionDescription)
                                    .frame(height: 100)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                                
                                Text("5. Start Time")
                                Picker("Select...", selection: $selectedStartTime) {
                                    ForEach(startTimeOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            
                            Group {
                                Text("6. Relevant Fields")
                                TextField("Type here...", text: $relevantFields)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Text("7. Workplace Languages")
                                TextField("Type here...", text: $workplaceLanguages)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Text("8. Employer Type")
                                Picker("Select...", selection: $employerType) {
                                    ForEach(employerTypeOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                
                                Text("9. Work Setting")
                                Picker("Select...", selection: $workSetting) {
                                    ForEach(workSettingOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                
                                Text("10. Employment Type")
                                Picker("Select...", selection: $employmentType) {
                                    ForEach(employmentTypeOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                
                                Text("11. Company Mission (Optional)")
                                TextEditor(text: $companyMission)
                                    .frame(height: 100)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                            }
                            
                            // Next button
                            HStack {
                                Spacer()
                                NavigationLink(destination: Text("Hi")) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.gray.opacity(isFormComplete() ? 1.0 : 0.5))
                                        .cornerRadius(25)
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
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func isFormComplete() -> Bool {
        return !companyName.isEmpty &&
               !positionTitle.isEmpty &&
               !positionDescription.isEmpty &&
               !selectedStartTime.isEmpty &&
               !relevantFields.isEmpty &&
               !workplaceLanguages.isEmpty &&
               !employerType.isEmpty &&
               !workSetting.isEmpty &&
               !employmentType.isEmpty
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        companyLogo = Image(uiImage: inputImage)
    }
}

struct ProfileSetupViewEmployer_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupViewEmployer()
    }
}
