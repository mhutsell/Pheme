//
//  SplashView2.swift
//  StorageV1
//
//  Created by Kunal Suri on 11/14/21.
//

import SwiftUI

struct Logo3 : View {
    var body: some View {
        return VStack{
            Image("Icon")
            Text("Pheme")
                .foregroundColor(Color.init(red: 0.765, green: 0.783, blue: 0.858))
                .font(.largeTitle)
        }
    }
}

//struct SplashView2_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashView2()
//    }
//}

struct SplashView2: View {
    @EnvironmentObject private var identity: Identity
    var body: some View {
        NavigationView {
        ZStack {
            Color.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255).edgesIgnoringSafeArea(.all)
            VStack{
                Logo3()
                    .padding()
                NavigationLink("Login", destination: ContentView(username: "self.username"))
                    .environmentObject(identity)
                    .font(.headline)
                    .foregroundColor(Color.init(red: 53 / 255, green: 61 / 255, blue: 96 / 255))
                    .padding()
                    .background(Color.init(red: 0.765, green: 0.783, blue: 0.858))
                    .cornerRadius(15.0)
            }
        }
        .navigationBarBackButtonHidden(true)
        }
    }
}
