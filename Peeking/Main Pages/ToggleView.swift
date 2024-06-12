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
    @State private var selectedConsultingOption = "Consulting"
    @State private var selectedMedicalTrackOption = "Medical Track"
    @State private var selectedHealthcareOption = "Healthcare"
    @State private var selectedStartupOption = "Startup"
    @State private var selectedSmallBusinessOption = "Small Business"
    @State private var selectedIndependentContractorOption = "Independent Contractor"
    @State private var selectedRemoteOption = "Remote"
    @State private var selectedHybridOption = "Hybrid"
    @State private var selectedInPersonOption = "In-Person"
    @State private var selectedPartTimeOption = "Part-time"
    @State private var selectedFullTimeOption = "Full-Time"
    @State private var selectedTemporaryOption = "Temporary"

    // Options for all of the drop downs.
    var jobOptions = ["Consulting", "IT Consulting", "Management Consulting"]
    var employerOptions = ["Startup", "Small Business", "Independent Contractor"]
    var workSettingOptions = ["Remote", "In-Person", "Hybrid"]
    var employmentStatusOptions = ["Part-time", "Full-Time", "Temporary"]

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
                            DropdownMenuButton(title: $selectedConsultingOption, options: jobOptions)
                            DropdownMenuButton(title: $selectedMedicalTrackOption, options: jobOptions)
                            DropdownMenuButton(title: $selectedHealthcareOption, options: jobOptions)
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
                            DropdownMenuButton(title: $selectedStartupOption, options: employerOptions)
                            DropdownMenuButton(title: $selectedSmallBusinessOption, options: employerOptions)
                            DropdownMenuButton(title: $selectedIndependentContractorOption, options: employerOptions)
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
                            DropdownMenuButton(title: $selectedRemoteOption, options: workSettingOptions)
                            DropdownMenuButton(title: $selectedHybridOption, options: workSettingOptions)
                            DropdownMenuButton(title: $selectedInPersonOption, options: workSettingOptions)
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
                            DropdownMenuButton(title: $selectedPartTimeOption, options: employmentStatusOptions)
                            DropdownMenuButton(title: $selectedFullTimeOption, options: employmentStatusOptions)
                            DropdownMenuButton(title: $selectedTemporaryOption, options: employmentStatusOptions)
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
