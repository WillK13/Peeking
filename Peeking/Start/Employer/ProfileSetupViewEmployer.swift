//
//  ProfileSetupViewEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/14/24.
//

import SwiftUI

struct ProfileSetupViewEmployer: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var companyName: String = ""
    @State private var companyLogo: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = nil
    @State private var positionTitle: String = ""
    @State private var positionDescription: String = ""
    @State private var selectedStartTime: [String] = []
    @State private var relevantFields: [String] = []
    @State private var workplaceLanguages: [String] = []
    @State private var employerType: [String] = []
    @State private var workSetting: [String] = []
    @State private var employmentType: [String] = []
    @State private var companyMission: String = ""
    @State private var languageSearchText: String = ""
    @State private var fieldsSearchText: String = ""
    @State private var timeSearchText: String = ""
    @State private var erTypeSearchText: String = ""
    @State private var entTypeSearchText: String = ""
    @State private var settingSearchText: String = ""


    
    let startTimeOptions = ["Morning", "Afternoon", "Evening", "Night"]
    let relevantFieldsOptions = ["Hospitality and Tourism", "Sales and Customer Service", "Telecommunications"]
    let workplaceLanguagesOptions = ["English", "Spanish", "French", "German"]
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
                                TextFieldWithLimit(text: $companyName, characterLimit: 50, placeholder: "Type here...")
                                    .padding(.trailing, 150.0)
                                
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
                                TextFieldWithLimit(text: $positionTitle, characterLimit: 50, placeholder: "Type here...")
                                    .padding(.trailing, 100)
                                
                                Text("4. Position Description")
                                TextEditorWithLimit(text: $positionDescription, characterLimit: 100, placeholder: "Type here...")
                                    .frame(height: 100)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                                
                                Divider().background(Color.gray)

                                Text("5. Start Time")
                                    .font(.headline)
                                SearchBar(text: $timeSearchText, options: startTimeOptions, selectedOptions: $selectedStartTime)
                                
                            }
                            
                            Group {
                                
                                Text("6. Relevant Fields")
                                    .font(.headline)
                                SearchBar(text: $fieldsSearchText, options: relevantFieldsOptions, selectedOptions: $relevantFields)
                                                                
                                Text("7. Workplace Languages")
                                    .font(.headline)
                                SearchBar(text: $languageSearchText, options: workplaceLanguagesOptions, selectedOptions: $workplaceLanguages)
                                
                                
                                Text("8. Employer Type")
                                    .font(.headline)
                                SearchBar(text: $erTypeSearchText, options: employerTypeOptions, selectedOptions: $employerType)
  
                                Text("9. Work Setting")
                                    .font(.headline)
                                SearchBar(text: $settingSearchText, options: workSettingOptions, selectedOptions: $workSetting)
  
                                Text("10. Employment Type")
                                    .font(.headline)
                                SearchBar(text: $entTypeSearchText, options: employmentTypeOptions, selectedOptions: $employmentType)
                                
                                
                                Divider().background(Color.gray)

                                Text("11. Company Mission (Optional)")
                                TextEditorWithLimit(text: $companyMission, characterLimit: 100, placeholder: "Type here...")
                                    .frame(height: 100)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                            }
                            
                            // Next button
                            HStack {
                                Spacer()
                                NavigationLink(destination: searchsettings()) {
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

struct DropdownMultiSelector: View {
    let title: String
    let options: [String]
    @Binding var selections: [String]

    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(true)
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .padding(.trailing, 10)
                    }
                )
                .onTapGesture {
                    showOptions.toggle()
                }
            
            if showOptions {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        if !selections.contains(option) {
                            selections.append(option)
                        }
                    }) {
                        HStack {
                            Text(option)
                            Spacer()
                            if selections.contains(option) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }
            }

            FlowLayout(alignment: .leading) {
                ForEach(selections, id: \.self) { selection in
                    HStack {
                        Text(selection)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        Button(action: {
                            selections.removeAll { $0 == selection }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding([.leading, .bottom], 10)
                }
            }
        }
    }

    @State private var showOptions = false
}

struct TextFieldWithLimit: View {
    @Binding var text: String
    var characterLimit: Int
    var placeholder: String
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(placeholder, text: $text)
                .onChange(of: text) { oldValue, newValue in
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("\(text.count)/\(characterLimit) characters")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}



struct ProfileSetupViewEmployer_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupViewEmployer()
    }
}
