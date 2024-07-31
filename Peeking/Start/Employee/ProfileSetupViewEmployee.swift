//
//  ProfileSetupViewEmployee.swift
//  Peeking
//
//  Created by Will kaminski on 6/14/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileSetupViewEmployee: View {
    @Environment(\.presentationMode) var presentationMode
    var fromEditProfile: Bool

    @State private var firstName: String = ""
    @State private var selectedMonth: String = "January"
    @State private var selectedDay: String = "1"
    @State private var selectedYear: String = "2000"
    @State private var profileImage: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? = nil
    @State private var languageSearchText: String = ""
    @State private var experienceSearchText: String = ""
    @State private var educationSearchText: String = ""
    @State private var languages: [String] = []
    @State private var fieldsOfExperience: [Experience] = []
    @State private var levelOfEducation: [String] = []
    @State private var isSaving: Bool = false
    @State private var navigateToNextView: Bool = false

    var languageOptions = ["English", "Spanish", "French", "German"]
    var experienceOptions = ["Software and Development", "Cybersecurity", "IT Consulting"]
    var educationOptions = ["Highschool Graduate", "Currently enrolled in Bachelor's Degree", "Currently enrolled in Master's Degree"]
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var days = Array(1...31).map { String($0) }
    var years = Array(1924...2008).map { String($0) }
    var experienceYears = Array(0...50).map { String($0) + " yrs" }

    struct Experience: Identifiable {
        var id = UUID()
        var field: String
        var years: String
    }

    var body: some View {
        NavigationStack {
            
                ZStack {
                    BackgroundView()
                        .edgesIgnoringSafeArea(.all)
                    ScrollView {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Button(action: {
                                if fromEditProfile {
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    presentationMode.wrappedValue.dismiss()
                                }
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
                            }
                        }
                        .padding(.top)
                        
                        HStack {
                            Spacer()
                            Text("The Basics")
                                .font(.largeTitle)
                                .padding(.top)
                                .padding(.bottom, 20)
                            Spacer()
                        }
                        // First Name
                        Text("1. First Name")
                            .font(.headline)
                        TextField("Type here...", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 20).padding(.trailing, 150)
                        Divider().background(Color.gray)
                        
                        // Birthday
                        Text("2. Birthday")
                            .font(.headline)
                        HStack {
                            Picker("Month", selection: $selectedMonth) {
                                ForEach(months, id: \.self) {
                                    Text($0).foregroundColor(.black)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 130)
                            .padding(.trailing, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                            
                            Picker("Day", selection: $selectedDay) {
                                ForEach(days, id: \.self) {
                                    Text($0).foregroundColor(.black)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 80)
                            .padding(.trailing, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                            
                            Picker("Year", selection: $selectedYear) {
                                ForEach(years, id: \.self) {
                                    Text($0).foregroundColor(.black)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 100)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .padding(.bottom, 20)
                        Divider().background(Color.gray)
                        
                        // Profile Picture
                        Text("3. Profile Picture")
                            .font(.headline)
                        VStack {
                            HStack {
                                if let profileImage = profileImage {
                                    profileImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 150)
                                        .clipShape(Rectangle())
                                        .cornerRadius(10)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 200.0, height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .foregroundColor(.gray)
                                        )
                                }
                                Image("uploadimage")
                            }
                        }
                        .onTapGesture {
                            self.showingImagePicker = true
                        }
                        .padding(.bottom, 10)
                        
                        Text("Don't worry, your profile picture is only made visible to your matches")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.bottom, 20)
                        Divider().background(Color.gray)
                        
                        // Languages
                        Text("4. Languages")
                            .font(.headline)
                        SearchBar(text: $languageSearchText, options: languageOptions, selectedOptions: $languages)
                        
                        Divider().background(Color.gray)
                        
                        // Fields and Years Experience
                        Text("5. Fields and Years Experience")
                            .font(.headline)
                        ExperienceSearchBar(text: $experienceSearchText, options: experienceOptions, selectedOptions: $fieldsOfExperience, experienceYears: experienceYears)
                        
                        Divider().background(Color.gray)
                        
                        // Level of Education
                        Text("6. Level of Education")
                            .font(.headline)
                        SearchBar(text: $educationSearchText, options: educationOptions, selectedOptions: $levelOfEducation)
                        
                        Spacer()
                        if !fromEditProfile {
                            HStack {
                                Spacer()
                                // Next Button
                                NavigationLink(destination: ProfileSearchSettings(), isActive: $navigateToNextView) {
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
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func isFormComplete() -> Bool {
        return !firstName.isEmpty && profileImage != nil && !languages.isEmpty && fieldsOfExperience.allSatisfy { !$0.years.isEmpty } && !levelOfEducation.isEmpty
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
    }
    
    func calculateAge(from birthday: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        return ageComponents.year ?? 0
    }
    
    func saveProfile() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d yyyy"
        guard let birthday = dateFormatter.date(from: "\(selectedMonth) \(selectedDay) \(selectedYear)") else { return }

        let age = calculateAge(from: birthday)
        let experienceData = fieldsOfExperience.map { ProfileUpdater.Experience(field: $0.field, years: Int($0.years.replacingOccurrences(of: " yrs", with: "")) ?? 0) }

        do {
            isSaving = true
            
            guard let inputImage = inputImage else {
                try await ProfileUpdater.shared.updateEmployeeProfile(userId: userId, name: firstName, birthday: birthday, age: age, languages: languages, education: levelOfEducation, experiences: experienceData)
                isSaving = false
                navigateToNextView = true
                return
            }
            
            StorageManager.shared.uploadProfileImage(userId: userId, image: inputImage, folder: "pfp") { result in
                switch result {
                case .success(let photoURL):
                    Task {
                        do {
                            try await ProfileUpdater.shared.updateEmployeeProfile(userId: userId, name: firstName, birthday: birthday, age: age, languages: languages, education: levelOfEducation, experiences: experienceData, photoURL: photoURL)
                            isSaving = false
                            navigateToNextView = true
                        } catch {
                            // Handle error
                        }
                    }
                case .failure(let error):
                    // Handle error
                    print("Failed to upload image: \(error)")
                    isSaving = false
                }
            }
        } catch {
            isSaving = false
            // Handle error
        }
    }

}

struct SearchBar: View {
    @Binding var text: String
    var options: [String]
    @Binding var selectedOptions: [String]
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search or add", text: $text)
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
            
            ForEach(options.filter { $0.lowercased().contains(text.lowercased()) }, id: \.self) { option in
                Button(action: {
                    if !selectedOptions.contains(option) {
                        selectedOptions.append(option)
                    }
                    text = ""
                }) {
                    HStack {
                        Text(option)
                            .foregroundColor(Color.black)
                            .padding(5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(20)
                        Spacer()
                        Image(systemName: "plus").foregroundColor(.black)
                    }
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(20)
                }
                .padding(.horizontal)
            }
            
            FlowLayout(alignment: .leading) {
                ForEach(selectedOptions, id: \.self) { selectedOption in
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
                            selectedOptions.removeAll { $0 == selectedOption }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }.padding([.leading, .bottom], 20).padding(.top, 10)
                }
            }
        }
        .padding(.vertical)
    }
}

struct ExperienceSearchBar: View {
    @Binding var text: String
    var options: [String]
    @Binding var selectedOptions: [ProfileSetupViewEmployee.Experience]
    var experienceYears: [String]

    var body: some View {
        VStack {
            HStack {
                TextField("Search or add", text: $text)
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
            
            ForEach(options.filter { $0.lowercased().contains(text.lowercased()) }, id: \.self) { option in
                Button(action: {
                    if !selectedOptions.contains(where: { $0.field == option }) {
                        selectedOptions.append(ProfileSetupViewEmployee.Experience(field: option, years: ""))
                    }
                    text = ""
                }) {
                    HStack {
                        Text(option)
                            .foregroundColor(Color.black)
                        Spacer()
                        Image(systemName: "plus").foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            FlowLayout(alignment: .leading) {
                ForEach($selectedOptions) { $selectedOption in
                    HStack {
                        Text(selectedOption.field)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        Picker("Years", selection: $selectedOption.years) {
                            ForEach(experienceYears, id: \.self) { year in
                                Text(year).foregroundColor(.black)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 100)
                        .background(Color.white)
                        .cornerRadius(10)
                        Button(action: {
                            selectedOptions.removeAll { $0.id == selectedOption.id }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        Spacer()
                    }
                    .padding([.leading, .bottom], 20)
                }
            }
        }
        .padding(.vertical)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct ProfileSetupViewEmployee_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupViewEmployee(fromEditProfile: false)
    }
}

#Preview {
    ProfileSetupViewEmployee(fromEditProfile: false)
}
