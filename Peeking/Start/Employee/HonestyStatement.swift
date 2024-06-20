import SwiftUI

struct HonestyStatement: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isChecked = false

    var body: some View {
        NavigationStack {
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
                    
                    HStack {
                        Spacer()
                        Text("Honesty Statement")
                            .font(.largeTitle)
                        Spacer()
                    }
                    .padding(.bottom, 40)
                    
                    VStack(spacing: 20) {
                        Text("Next, we need to understand who you are, and what you want...")
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))

                        Text("We ask that you be true to yourself for the most compatible matches.")
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))

                        HStack {
                            Button(action: {
                                isChecked.toggle()
                            }) {
                                Image(systemName: isChecked ? "checkmark.square" : "square")
                                    .foregroundColor(.black)
                                    .padding(.leading, 10)
                                    .font(.system(size: 25))
                            }
                            Text("I'm ready to be honest!")
                                .padding(.trailing, 10)
                                .cornerRadius(10)
                        }
                        .padding(10)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))

                        Text("By ticking the box, you confirm the above")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .italic()
                    }
                    .padding(.bottom, 40)
                    
                    Spacer()

                    HStack {
                        Spacer()
                        // Next Button
                        NavigationLink(destination: SoftSkills().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(25)
                                .shadow(radius: 10)
                                .opacity(isChecked ? 1.0 : 0.5)
                        }
                        .disabled(!isChecked)
                        .padding(.top, 30)
                        .padding(.bottom, 50)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct HonestyStatement_Previews: PreviewProvider {
    static var previews: some View {
        HonestyStatement()
    }
}
