//
//  ProfileSetupViewEmployer.swift
//  Peeking
//
//  Created by Will kaminski on 6/14/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileSetupViewEmployer: View {
    @Environment(\.presentationMode) var presentationMode
    var fromEditProfile: Bool // Flag to indicate if opened from EditProfile

    @State private var companyName: String = ""
    @State private var companyLogo: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = nil
    @State private var positionTitle: String = ""
    @State private var positionDescription: String = ""
    @State private var selectedStartTime: String = ""
    @State private var relevantFields: [String] = []
    @State private var workplaceLanguages: [String] = []
    @State private var selectedEmployerType: String = ""
    @State private var selectedWorkSetting: String = ""
    @State private var selectedEmploymentType: String = ""
    @State private var companyMission: String = ""
    @State private var languageSearchText: String = ""
    @State private var fieldsSearchText: String = ""
    @State private var timeSearchText: String = ""
    @State private var erTypeSearchText: String = ""
    @State private var entTypeSearchText: String = ""
    @State private var settingSearchText: String = ""
    @State private var isSaving: Bool = false
    @State private var navigateToNextView: Bool = false

    let startTimeOptions = ["Fall", "Winter", "Spring", "Summer", "Any"]
    let relevantFieldsOptions = [
        "Architecture",
        "Arts and Entertainment",
        "Automotive",
        "Beauty and Cosmetics",
        "Construction",
        "Consulting",
        "Creative and Design",
        "Cybersecurity",
        "E-commerce",
        "Education",
        "Energy and Utilities",
        "Engineering",
        "Environmental and Agriculture",
        "Event Planning and Management",
        "Fashion",
        "Finance",
        "Food and Beverage",
        "Government and Public Administration",
        "Health and Wellness",
        "Healthcare",
        "Home Improvement",
        "Hospitality and Tourism",
        "Human Resources",
        "IT Services and Consulting",
        "Legal",
        "Manufacturing and Production",
        "Media and Communications",
        "Non-Profit and Social Services",
        "Operations and Logistics",
        "Pharmaceuticals",
        "Real Estate",
        "Restaurant",
        "Retail",
        "Sales and Customer Service",
        "Science and Research",
        "Software and Development",
        "Sports and Recreation",
        "Telecommunications",
        "Transportation"
    ]
    let workplaceLanguagesOptions = [
        "Arabic",
        "Bengali",
        "Bulgarian",
        "Cambodian (Khmer)",
        "Chinese",
        "Croatian",
        "Czech",
        "Danish",
        "Dutch",
        "English",
        "Estonian",
        "Farsi (Persian)",
        "Finnish",
        "French",
        "German",
        "Greek",
        "Haitian Creole",
        "Hebrew",
        "Hindi",
        "Hungarian",
        "Icelandic",
        "Indonesian",
        "Italian",
        "Japanese",
        "Kazakh",
        "Korean",
        "Kurdish",
        "Kyrgyz",
        "Lao",
        "Latvian",
        "Lithuanian",
        "Macedonian",
        "Malay",
        "Mongolian",
        "Nepali",
        "Norwegian",
        "Pashto",
        "Polish",
        "Portuguese",
        "Punjabi",
        "Romanian",
        "Russian",
        "Serbian",
        "Slovak",
        "Slovenian",
        "Somali",
        "Spanish",
        "Swahili",
        "Swedish",
        "Tagalog",
        "Tamil",
        "Telugu",
        "Thai",
        "Turkish",
        "Ukrainian",
        "Urdu",
        "Uzbek",
        "Vietnamese",
        "Yoruba"
    ]

    let employerTypeOptions = ["Startup", "Small Business", "Corporate", "Independent Client"]
    let workSettingOptions = ["Remote", "In-Person", "Hybrid"]
    let employmentTypeOptions = ["Part-time", "Full-time", "Internship", "Temporary"]

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
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color("UnimportantText"))
                            Spacer()
                            RoundedRectangle(cornerRadius: 10).frame(width: 35, height: 12).foregroundColor(Color("UnimportantText"))
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
                                .padding(.trailing, 15)
                            }
                        }
                        .padding(.top)
                        HStack {
                            Spacer()
                            Text("The Basics")
                                .font(.largeTitle)
                                .multilineTextAlignment(.center).padding(.top,-10)
                            Spacer()
                        }
                        
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
                                TextFieldWithLimit2(text: $positionDescription, characterLimit: 100)
                                
                                Divider().background(Color.gray)
                                
                                Text("5. Start Time")
                                    .font(.headline)
                                SingleSelectSearchBar(text: $timeSearchText, options: startTimeOptions, selectedOption: $selectedStartTime)
                                
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
                                SingleSelectSearchBar(text: $erTypeSearchText, options: employerTypeOptions, selectedOption: $selectedEmployerType)
                                
                                Text("9. Work Setting")
                                    .font(.headline)
                                SingleSelectSearchBar(text: $settingSearchText, options: workSettingOptions, selectedOption: $selectedWorkSetting)
                                
                                Text("10. Employment Type")
                                    .font(.headline)
                                SingleSelectSearchBar(text: $entTypeSearchText, options: employmentTypeOptions, selectedOption: $selectedEmploymentType)
                                
                                Divider().background(Color.gray)
                                
                                Text("11. Company Mission (Optional)")
                                TextFieldWithLimit2(text: $companyMission, characterLimit: 100)
                                    
                            }
                            if !fromEditProfile {
                                // Next button
                                HStack {
                                    Spacer()
                                    NavigationLink(destination: searchsettings(), isActive: $navigateToNextView) {
                                        Button(action: {
                                            Task {
                                                await saveProfile()
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
               !selectedEmployerType.isEmpty &&
               !selectedWorkSetting.isEmpty &&
               !selectedEmploymentType.isEmpty
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        companyLogo = Image(uiImage: inputImage)
    }

    func saveProfile() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        if let inputImage = inputImage {
            StorageManager.shared.uploadProfileImage(userId: userId, image: inputImage, folder: "logo") { result in
                switch result {
                case .success(let logoURL):
                    Task {
                        do {
                            try await ProfileUpdaterEmployer.shared.updateEmployerProfile(
                                userId: userId,
                                companyName: companyName,
                                companyMission: companyMission,
                                languages: workplaceLanguages,
                                employerType: [selectedEmployerType],
                                positionTitle: positionTitle,
                                positionDescription: positionDescription,
                                startTime: [selectedStartTime],
                                relevantFields: relevantFields,
                                workSetting: [selectedWorkSetting],
                                employmentType: [selectedEmploymentType],
                                logoURL: logoURL // Add logoURL to the update
                            )
                            navigateToNextView = true
                        } catch {
                            // Handle error
                        }
                    }
                case .failure(let error):
                    // Handle error
                    print("Failed to upload image: \(error)")
                }
                isSaving = false
            }
        } else {
            Task {
                do {
                    try await ProfileUpdaterEmployer.shared.updateEmployerProfile(
                        userId: userId,
                        companyName: companyName,
                        companyMission: companyMission,
                        languages: workplaceLanguages,
                        employerType: [selectedEmployerType],
                        positionTitle: positionTitle,
                        positionDescription: positionDescription,
                        startTime: [selectedStartTime],
                        relevantFields: relevantFields,
                        workSetting: [selectedWorkSetting],
                        employmentType: [selectedEmploymentType],
                        logoURL: nil // No logo URL provided
                    )
                    navigateToNextView = true
                } catch {
                    // Handle error
                }
                isSaving = false
            }
        }
    }
}

struct SingleSelectSearchBar: View {
    @Binding var text: String
    let options: [String]
    @Binding var selectedOption: String
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search or select", text: $text)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .padding(.trailing, 10)
                        }
                    )
            }.padding(.trailing, 120).padding(.bottom, 10)
            if !text.isEmpty {
                VStack {
                    ForEach(options.filter { $0.lowercased().contains(text.lowercased()) }, id: \.self) { option in
                        HStack {
                            Text(option)
                                .foregroundColor(Color.black)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(10)
                            Spacer()
                            Image(systemName: "plus").foregroundColor(.black)
                        }.padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                        .onTapGesture {
                            selectedOption = option
                            text = ""
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            if !selectedOption.isEmpty {
                HStack {
                    Text(selectedOption)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    Button(action: {
                        selectedOption = ""
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .padding([.leading, .bottom], 20).padding(.top, 10)
            }
        }
    }
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

struct TextFieldWithLimit2: View {
    @Binding var text: String
    var characterLimit: Int
    
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading) {

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

struct ProfileSetupViewEmployer_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupViewEmployer(fromEditProfile: false)
    }
}
