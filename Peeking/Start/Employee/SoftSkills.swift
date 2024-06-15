//
//  SoftSkills.swift
//  Peeking
//
//  Created by Will kaminski on 6/15/24.
//

import SwiftUI

struct SoftSkills: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            BackgroundView()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                // Custom back arrow
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.leading)
                
                Spacer()
                
                Text("Hello, World!")
                    .font(.largeTitle)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SoftSkills_Previews: PreviewProvider {
    static var previews: some View {
        SoftSkills()
    }
}
