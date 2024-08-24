//
//  EmployeeTierView.swift
//  Peeking
//
//  Created by Will kaminski on 6/7/24.
//

import SwiftUI

struct EmployeeTierView: View {
    //Vars for all of the sviews and plans and pages and a timer.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedPage = 0
    @State private var selectedPlan = "with Floater"
    @State private var showPicker = false
//    @State private var timer: Timer? = nil
    //Possible plans
    private let plans = ["with Floater", "with Glider", "with Diver"]
    //All of the content for each page.
    private let pagesFloater = [
        PlanPage(title: "3 Like Capacity", description: "Refilled every 24 hours", imageName: "heart", iconText: "3"),
        PlanPage(title: "Bookmark", description: "A bookmark for your search", imageName: "bookmark", iconText: "1")
    ]

    private let pagesGlider = [
        PlanPage(title: "Recharge", description: "Likes recharge 1 every hour", imageName: "Battery", iconText: ""),
        PlanPage(title: "Roam", description: "Set location anywhere", imageName: "Car", iconText: ""),
        PlanPage(title: "Bookmark +", description: "2 bookmarks for searching", imageName: "bookmark", iconText: "2")
    ]

    private let pagesDiver = [
        PlanPage(title: "Liked You", description: "See employers who like you", imageName: "Lookeye", iconText: ""),
        PlanPage(title: "5 Like Capacity", description: "Wake up with 5 likes", imageName: "heart", iconText: "5"),
        PlanPage(title: "Recharge", description: "Likes recharge 1 every hour", imageName: "Battery", iconText: ""),
        PlanPage(title: "Roam", description: "Set location anywhere", imageName: "Car", iconText: ""),
        PlanPage(title: "Bookmark ++", description: "3 bookmarks for searching", imageName: "bookmark", iconText: "3")
    ]

    var body: some View {
        //Background
        ZStack {
            BackgroundView()
            //Content behind
            VStack {
                Image("Duck_Head").resizable().aspectRatio(contentMode: .fit).frame(width: 120).padding(.top, 10)
                Spacer()
            }
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)

            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 373, height: 650)
                .padding(.top, 120)
            //Main content
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                //Disclaimer
                Text("Billing disclaimer")
                    .font(.title2)
                    .foregroundColor(Color.white)

                Text("Payment will be charged to your Apple account, and subscription will automatically renew. You agree to our Terms of Agreement/Privacy Policy.")
                    .font(.footnote)
                    .fontWeight(.light)
                    .foregroundColor(Color("UnimportantText"))
                    .multilineTextAlignment(.center)
                    .frame(width: 300.0)
                //Changing info
                VStack {
                    //If it works it works
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    //Custom title
                    Text(getPlanTitle())
                        .font(.largeTitle)
                    //Change plan
                    Button(action: {
                        showPicker.toggle()
                    }) {
                        HStack {
                            Text(selectedPlan)
                                .font(.title2)
                                .foregroundColor(Color.black)
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.black)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(getPickerBackgroundColor()))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    }
                    .padding()
                    //Click through features
                    HStack {
                        Button(action: {
                            if selectedPage > 0 {
                                selectedPage -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color.black)
                                .padding(.leading, 50.0)
                                .font(.largeTitle)
                        }
                        .padding(.leading)

                        Spacer()
                        //The features of each plan
                        VStack {
                            let currentPage = getCurrentPages()[selectedPage]
                            if currentPage.imageName == "Battery" {
                                Image(currentPage.imageName + currentPage.iconText)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150, height: 60)
                            } else {
                                Image(currentPage.imageName + currentPage.iconText)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                            }
                            Text(currentPage.title)
                                .font(.title2)

                            Text(currentPage.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            HStack {
                                ForEach(Array(getCurrentPages().indices), id: \.self) { index in
                                    Circle()
                                        .fill(index == selectedPage ? Color.black : Color.gray)
                                        .frame(width: 10, height: 10)
                                }
                            }
                            .padding(.top)
                        }.padding(.vertical)

                        Spacer()

                        Button(action: {
                            if selectedPage < getCurrentPages().count - 1 {
                                selectedPage += 1
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.black)
                                .padding(.trailing, 50.0)
                                .font(.largeTitle)
                        }
                        .padding(.trailing)
                    }
                    //Custom info on pricing
                    if selectedPlan == "with Floater" {
                        VStack(spacing: 0) {
                            VStack {
                                Image("Infinity").resizable().aspectRatio(contentMode: .fill).frame(width: 50)

                                Text("Months")
                                    .font(.title2)
                                    .padding(.top, -20.0)
                            }
                            .frame(height: 80)
                            .background(Color.white)

                            VStack {
                                Text("Free")
                                    .font(.title)
                                    .padding(.top, 2)
                                    .padding(.bottom, 20)
                            }
                            .frame(width: 100.0, height: 60)
                            .background(Color.gray.opacity(0.2))
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color.black),
                                alignment: .top
                            )
                            .padding(.top, 10)
                        }
                        .frame(width: 100, height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    } else {
                        PaymentOptionsView(selectedPlan: selectedPlan)
                            .padding()
                    }

                    Button(action: {
                        // Handle button action
                    }) {
                        Text(getButtonText())
                            .font(.title2)
                            .foregroundColor(Color.black)
                            .padding()
                            .background(getButtonBackgroundColor())
                            .cornerRadius(100)
                    }
                    .padding(.top, 10)
                    //Exit
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Exit")
                            .font(.title2)
                            .padding(.bottom)
                            .foregroundColor(Color("UnimportantText"))
                    }
                    .padding(.bottom, 20)
                }
            }
            //Logic for showing pages
            if showPicker {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showPicker = false
                    }

                VStack {
                    Spacer()
                    PickerView(selectedPlan: $selectedPlan, plans: plans, showPicker: $showPicker)
                        .frame(width: 300, height: 200)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 20)
                        .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true) //Hide the default back button
//        .onAppear {
//            startTimer()
//        }
//        .onDisappear {
//            stopTimer()
//        }
        .onChange(of: selectedPlan) { newPlan, _ in
            selectedPage = 0 //Reset to first page when plan changes
        }
    }
    //Get timer working
//    private func startTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
//            withAnimation {
//                selectedPage = (selectedPage + 1) % getCurrentPages().count
//            }
//        }
//    }
//    //Stop the timer
//    private func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
    //Get current page based on plan
    private func getCurrentPages() -> [PlanPage] {
        switch selectedPlan {
        case "with Glider":
            return pagesGlider
        case "with Diver":
            return pagesDiver
        default:
            return pagesFloater
        }
    }
    //All of the titles
    private func getPlanTitle() -> String {
        switch selectedPlan {
        case "with Glider":
            return "Find Matches Faster"
        case "with Diver":
            return "Unlimited Access"
        default:
            return "Just the Basics"
        }
    }
    //Custom background colors
    private func getPickerBackgroundColor() -> Color {
        switch selectedPlan {
        case "with Glider":
            return Color.blue.opacity(0.2)
        case "with Diver":
            return Color.purple.opacity(0.2)
        default:
            return Color.gray.opacity(0.2)
        }
    }
    //Custom text per plan
    private func getButtonText() -> String {
        switch selectedPlan {
        case "with Glider":
            return "Buy Glider"
        case "with Diver":
            return "Buy Diver"
        default:
            return "All users get full access"
        }
    }
    //Custom buttons per plan
    private func getButtonBackgroundColor() -> Color {
        switch selectedPlan {
        case "with Glider":
            return Color("TopOrange")
        case "with Diver":
            return Color("TopOrange")
        default:
            return Color("FadedTopOrange")
        }
    }
}
//PlanPage object with info for each page
struct PlanPage {
    let title: String
    let description: String
    let imageName: String
    let iconText: String
}
//Pick the right view based on each plan
struct PickerView: View {
    @Binding var selectedPlan: String
    let plans: [String]
    @Binding var showPicker: Bool

    var body: some View {
        VStack {
            Picker("Select Plan", selection: $selectedPlan) {
                ForEach(plans, id: \.self) { plan in
                    Text(plan)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            Button("Done") {
                showPicker = false
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 20)
    }
}
//View for payment options for glider and diver depending on each one picked.
struct PaymentOptionsView: View {
    let selectedPlan: String
    @State private var selectedOption = "1 Month" //Default selected option

    var body: some View {
        HStack(spacing: 10) {
            //Year
            VStack {
                Text("BEST VALUE")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, -20.0)
                VStack {
                    Text("12")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Months")
                        .font(.subheadline)
                    Text("Save 58%")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(/*@START_MENU_TOKEN@*/.all, 3.0/*@END_MENU_TOKEN@*/)
                        .background(Color("TopOrange"))
                        .cornerRadius(5)
                    Text(getPrice(for: "12 Months"))
                        .font(.title2)
                    Text(getMonthlyPrice(for: "12 Months"))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(width: 80, height: 150)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selectedOption == "12 Months" ? Color.blue : Color.black, lineWidth: selectedOption == "12 Months" ? 2 : 1)
                )
                .onTapGesture {
                    selectedOption = "12 Months"
                }
            }

            VStack {
                //6 Months
                Text("MOST POPULAR")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, -20.0)
                VStack {
                    Text("6")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Months")
                        .font(.subheadline)
                    Text("Save 33%")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(3)
                        .background(Color("TopOrange"))
                        .cornerRadius(5)
                    Text(getPrice(for: "6 Months"))
                        .font(.title2)
                    Text(getMonthlyPrice(for: "6 Months"))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(width: 80, height: 150)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selectedOption == "6 Months" ? Color.blue : Color.black, lineWidth: selectedOption == "6 Months" ? 2 : 1)
                )
                .onTapGesture {
                    selectedOption = "6 Months"
                }
            }

            VStack {
                //Month
                Text("")
                    .font(.caption)
                    .padding(.top, -20.0)
                VStack {
                    Text("1")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Month")
                        .font(.subheadline)
                    Text(getPrice(for: "1 Month"))
                        .font(.title2)
                    Text(getMonthlyPrice(for: "1 Month"))
                        .font(.caption)
                }
                .frame(width: 80, height: 150)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selectedOption == "1 Month" ? Color.blue : Color.black, lineWidth: selectedOption == "1 Month" ? 2 : 1)
                )
                .onTapGesture {
                    selectedOption = "1 Month"
                }
            }
        }
    }
    //Change prices for each plan, need to make dynamic potentially
    private func getPrice(for duration: String) -> String {
        switch selectedPlan {
        case "with Diver":
            switch duration {
            case "12 Months":
                return "$99.95"
            case "6 Months":
                return "$79.95"
            case "1 Month":
                return "$19.95"
            default:
                return ""
            }
        default:
            switch duration {
            case "12 Months":
                return "$49.95"
            case "6 Months":
                return "$39.95"
            case "1 Month":
                return "$9.95"
            default:
                return ""
            }
        }
    }
    //Change prices for each plan, need to make dynamic potentially
    private func getMonthlyPrice(for duration: String) -> String {
        switch selectedPlan {
        case "with Diver":
            switch duration {
            case "12 Months":
                return "$8.33/mo"
            case "6 Months":
                return "$13.33/mo"
            case "1 Month":
                return ""
            default:
                return ""
            }
        default:
            switch duration {
            case "12 Months":
                return "$4.16/mo"
            case "6 Months":
                return "$6.66/mo"
            case "1 Month":
                return ""
            default:
                return ""
            }
        }
    }
}

#Preview {
    EmployeeTierView()
}
