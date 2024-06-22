//
//  ProfileSearchSettings.swift
//  Peeking
//
//  Created by Will kaminski on 6/14/24.
//

import SwiftUI

struct ProfileSearchSettings: View {
    // Variables for distance, show views, and the current selected options
    @Environment(\.presentationMode) var presentationMode
    @State private var distance: Double = 30
    @State private var showLocationView = false
    
    @State private var selectedField1 = "Choose"
    @State private var selectedField2 = "Choose"
    @State private var selectedField3 = "Choose"
    
    @State private var selectedEmployer1 = "Choose"
    @State private var selectedEmployer2 = "Choose"
    @State private var selectedEmployer3 = "Choose"
    
    @State private var selectedSetting1 = "Choose"
    @State private var selectedSetting2 = "Choose"
    @State private var selectedSetting3 = "Choose"
    
    @State private var selectedStatus1 = "Choose"
    @State private var selectedStatus2 = "Choose"
    @State private var selectedStatus3 = "Choose"
    
    @State private var selectedStart1 = "Choose"
    @State private var selectedStart2 = "Choose"
    @State private var selectedStart3 = "Choose"

    // Options for all of the drop downs.
    var fieldOptions = ["Consulting", "IT Consulting", "Management Consulting"]
    var employerOptions = ["Startup", "Small Business", "Independent Client", "Corporate"]
    var workSettingOptions = ["Remote", "In-Person", "Hybrid"]
    var employmentStatusOptions = ["Part-time", "Full-Time", "Temporary", "Internship"]
    var StartOptions = ["Fall", "Winter", "Spring", "Summer", "Any"]

    var body: some View {
        //VStack with all content
        VStack(spacing: 20) {
            VStack {
                //Back arrow
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black).font(.system(size: 25))
                    }
                    Spacer()
                }
                .padding([.top, .leading, .trailing])
                
                Text("Search Settings")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom)
            }.background(Color("TopOrange")).cornerRadius(10)
            //The main view area
            ScrollView {
                VStack(spacing: 20) {
                    //Location
                    HStack {
                        Text("Location")
                        Spacer()
                        Button(action: {
                            showLocationView.toggle()
                        }) {
                            HStack {
                                Text("Position Location\nBoston, MA")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.trailing)
                                Image(systemName: "chevron.right")
                            }
                        }
                        .fullScreenCover(isPresented: $showLocationView) {
                            LocationView()
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().background(Color.gray)
                    //Distance toggle
                    VStack(spacing: 10) {
                        HStack {
                            Text("Distance")
                            Spacer()
                        }
                        Slider(value: $distance, in: 0...100)
                        Text("Up to \(Int(distance)) miles")
                    }
                    .padding(.horizontal)
                    
                    Divider().background(Color.gray)
                    //The fields
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Field/Niche")
                        HStack {
                            Text("1st Choice").foregroundColor(.gray).padding(.leading)
                            Spacer()
                            Text("2nd Choice").foregroundColor(.gray)
                            Spacer()
                            Text("3rd Choice").foregroundColor(.gray).padding(.trailing)
                        }
                        HStack {
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedField1, options: fieldOptions)
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedField2, options: fieldOptions)
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedField3, options: fieldOptions)
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Divider().background(Color.gray)
                    //The employers
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Type of Employer")
                        HStack {
                            Text("1st Choice").foregroundColor(.gray).padding(.leading)
                            Spacer()
                            Text("2nd Choice").foregroundColor(.gray)
                            Spacer()
                            Text("3rd Choice").foregroundColor(.gray).padding(.trailing)
                        }
                        HStack {
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedEmployer1, options: employerOptions)
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedEmployer2, options: employerOptions)
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedEmployer3, options: employerOptions)
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Divider().background(Color.gray)
                    //The work setting
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Work Setting")
                        HStack {
                            Text("1st Choice").foregroundColor(.gray).padding(.leading)
                            Spacer()
                            Text("2nd Choice").foregroundColor(.gray)
                            Spacer()
                            Text("3rd Choice").foregroundColor(.gray).padding(.trailing)
                        }
                        HStack(spacing: 10) {
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedSetting1, options: workSettingOptions)
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedSetting2, options: workSettingOptions)
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedSetting3, options: workSettingOptions)
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Divider().background(Color.gray)
                    //The employment status
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Employment Status")
                        HStack {
                            Text("1st Choice").foregroundColor(.gray).padding(.leading)
                            Spacer()
                            Text("2nd Choice").foregroundColor(.gray)
                            Spacer()
                            Text("3rd Choice").foregroundColor(.gray).padding(.trailing)
                        }
                        HStack {
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedStatus1, options: employmentStatusOptions)
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedStatus2, options: employmentStatusOptions)
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedStatus3, options: employmentStatusOptions)
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Divider().background(Color.gray)
                    //The start time
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Start Time")
                        HStack {
                            Text("1st Choice").foregroundColor(.gray).padding(.leading)
                            Spacer()
                            Text("2nd Choice").foregroundColor(.gray)
                            Spacer()
                            Text("3rd Choice").foregroundColor(.gray).padding(.trailing)
                        }
                        HStack {
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedStart1, options: StartOptions)
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedStart2, options: StartOptions)
                            Spacer()
                            DropdownMenuButtonStart(title: $selectedStart3, options: StartOptions)
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Divider().background(Color.gray)
                    //Exit
                    HStack {
                        Spacer()
                        NavigationLink(destination: TechnicalsEmployee( fromEditProfile: false)) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("BottomOrange"))
                                .cornerRadius(25)
                                .opacity(isFormComplete() ? 1.0 : 0.5)
                        }
                        .disabled(!isFormComplete())
                        .padding(.top, 20)
                    }.padding(.trailing, 20)
                }
                .padding(.bottom, 20) // Add some bottom padding to ensure the last item is fully visible
            }.navigationBarBackButtonHidden(true)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    func isFormComplete() -> Bool {
        return selectedField1 != "Choose" && selectedField2 != "Choose" && selectedField3 != "Choose" &&
               selectedEmployer1 != "Choose" && selectedEmployer2 != "Choose" && selectedEmployer3 != "Choose" &&
               selectedSetting1 != "Choose" && selectedSetting2 != "Choose" && selectedSetting3 != "Choose" &&
               selectedStatus1 != "Choose" && selectedStatus2 != "Choose" && selectedStatus3 != "Choose" &&
               selectedStart1 != "Choose" && selectedStart2 != "Choose" && selectedStart3 != "Choose"
    }
}

// Drop down menu for each button with the custom items above
struct DropdownMenuButtonStart: View {
    @Binding var title: String
    let options: [String]

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    title = option
                }) {
                    Text(option)
                }
            }
        } label: {
            Text(title)
                .foregroundColor(.black)
                .padding()
                .background(Color.orange.opacity(title == "Choose" ? 0.5 : 0.7))
                .cornerRadius(10)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

struct ProfileSearchSettings_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSearchSettings()
    }
}
