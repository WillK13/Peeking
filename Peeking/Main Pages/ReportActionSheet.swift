//
//  ReportActionSheet.swift
//  Peeking
//
//  Created by Will kaminski on 10/13/24.
//

import SwiftUI

struct ReportActionSheet: View {
    @Binding var showReportSheet: Bool  // Binding to control when the sheet is shown
        
        var body: some View {
            VStack {
                Spacer()
                
                VStack {
                    Button(action: {
                        // Handle the report action
                        print("User reported")
                        showReportSheet = false  // Close the sheet after reporting
                    }) {
                        Text("Report")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .padding(.vertical, 20)
                            .shadow(radius: 1)
                    }
                    
                    Button(action: {
                        showReportSheet = false  // Close the sheet
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                            .shadow(radius: 1)
                    }
                }
//                .padding(.top, 20)
                .background(Color.white)
                .cornerRadius(10)
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color.black.opacity(0.4).onTapGesture {
                showReportSheet = false  // Close the sheet when the background is tapped
            })
        }
}

#Preview {
    ReportActionSheet(showReportSheet: .constant(true))
}
