//
//  ToggleView.swift
//  Peeking
//
//  Created by Will kaminski on 6/11/24.
//

import SwiftUI

struct ToggleView: View {
    // Variables for distance, show views, and the current selected options
    @Environment(\.presentationMode) var presentationMode
    @State private var distance: Double = 30
    @State private var showLocationView = false
    
    @State private var selectedField1 = "Consulting"
    @State private var selectedField2 = "Medical Track"
    @State private var selectedField3 = "Healthcare"
    
    @State private var selectedEmployer1 = "Startup"
    @State private var selectedEmployer2 = "Small Business"
    @State private var selectedEmployer3 = "Independent Contractor"
    
    @State private var selectedSetting1 = "Remote"
    @State private var selectedSetting2 = "Hybrid"
    @State private var selectedSetting3 = "In-Person"
    
    @State private var selectedStatus1 = "Part-time"
    @State private var selectedStatus2 = "Full-Time"
    @State private var selectedStatus3 = "Temporary"
    
    @State private var selectedStart1 = "Fall"
    @State private var selectedStart2 = "Winter"
    @State private var selectedStart3 = "Any"

    // Options for all of the drop downs.
    var fieldOptions = ["Consulting", "IT Consulting", "Management Consulting"]
    var employerOptions = ["Startup", "Small Business", "Independent Client", "Corporate"]
    var workSettingOptions = ["Remote", "In-Person", "Hybrid"]
    var employmentStatusOptions = ["Part-time", "Full-Time", "Temporary", "Internship"]
    var StartOptions = ["Fall", "Winter", "Spring", "Summer", "Any"]

    var body: some View {
        //VStack with all content
        VStack(spacing: 20) {
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
                        Text("Distance")
                        Slider(value: $distance, in: 0...500)
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
                            DropdownMenuButton(title: $selectedField1, options: fieldOptions)
                            DropdownMenuButton(title: $selectedField2, options: fieldOptions)
                            DropdownMenuButton(title: $selectedField3, options: fieldOptions)
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
                            DropdownMenuButton(title: $selectedEmployer1, options: employerOptions)
                            DropdownMenuButton(title: $selectedEmployer2, options: employerOptions)
                            DropdownMenuButton(title: $selectedEmployer3, options: employerOptions)
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
                            DropdownMenuButton(title: $selectedSetting1, options: workSettingOptions)
                            DropdownMenuButton(title: $selectedSetting2, options: workSettingOptions)
                            DropdownMenuButton(title: $selectedSetting3, options: workSettingOptions)
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
                            DropdownMenuButton(title: $selectedStatus1, options: employmentStatusOptions)
                            DropdownMenuButton(title: $selectedStatus2, options: employmentStatusOptions)
                            DropdownMenuButton(title: $selectedStatus3, options: employmentStatusOptions)
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
                            DropdownMenuButton(title: $selectedStart1, options: StartOptions)
                            Spacer()
                            DropdownMenuButton(title: $selectedStart2, options: StartOptions)
                            Spacer()
                            DropdownMenuButton(title: $selectedStart3, options: StartOptions)
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Divider().background(Color.gray)
                    //Exit
                    Button(action: {
                        // Handle save and exit action
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save and Exit")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding(.bottom, 20) // Add some bottom padding to ensure the last item is fully visible
            }
        }
        .padding()
    }
}
//Drop down menu for each button with the custom items above
struct DropdownMenuButton: View {
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
                .background(Color.orange.opacity(0.7))
                .cornerRadius(10)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}
//New vier when expand location
struct LocationView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        //All of the content
        VStack(spacing: 20) {
            //Exit page
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black).font(.system(size: 25))
                }
                Spacer()
            }
            .padding()

            Text("Location Settings")
                .font(.title)
                .fontWeight(.bold)
            
            // Location settings
            Text("Location")
            Text("Map")
            //Exit
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save and Exit")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ToggleView()
}
