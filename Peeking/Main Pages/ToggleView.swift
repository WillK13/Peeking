//
//  ToggleView.swift
//  Peeking
//
//  Created by Will kaminski on 6/11/24.
//

import SwiftUI

struct ToggleView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var distance: Double = 30
    @State private var showLocationView = false
    @State private var selectedConsultingOption = "Consulting"
    @State private var selectedMedicalTrackOption = "Medical Track"
    @State private var selectedHealthcareOption = "Healthcare"
    @State private var selectedStartupOption = "Startup"
    @State private var selectedSmallBusinessOption = "Small Business"
    @State private var selectedIndependentContractorOption = "Independent Contractor"
    @State private var selectedPartTimeOption = "Part-time"
    @State private var selectedFullTimeOption = "Full-Time"
    @State private var selectedTemporaryOption = "Temporary"

    var jobOptions = ["Consulting", "IT Consulting", "Management Consulting"]
    var employerOptions = ["Startup", "Small Business", "Independent Contractor"]
    var workSettingOptions = ["Remote", "Hybrid", "In-Person"]
    var employmentStatusOptions = ["Part-time", "Full-Time", "Temporary"]

    var body: some View {
        VStack(spacing: 20) {
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

            ScrollView {
                VStack(spacing: 20) {
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
                    
                    VStack(spacing: 10) {
                        Text("Distance")
                        Slider(value: $distance, in: 0...500)
                        Text("Up to \(Int(distance)) miles")
                    }
                    .padding(.horizontal)
                    
                    Divider().background(Color.gray)

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
                            SearchSettingButton(title: "Remote")
                            SearchSettingButton(title: "Hybrid")
                            SearchSettingButton(title: "In-Person")
                        }
                    }
                    .padding()
                    
                    Divider().background(Color.gray)

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

struct LocationView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
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
            
            // Your Location settings UI here
            Text("Location")
            Text("Map")

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

struct SearchSettingButton: View {
    let title: String

    var body: some View {
        Text(title)
            .foregroundColor(.black)
            .padding()
            .background(Color.orange.opacity(0.7))
            .cornerRadius(10)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

#Preview {
    ToggleView()
}
