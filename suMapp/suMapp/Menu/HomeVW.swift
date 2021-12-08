//
//  HomeVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 07/12/21.
//

import SwiftUI

struct HomeVW: View {
    @State private var currentDate:String = ""
    @State private var currentTime:String = ""
    
    var body: some View {
        ZStack {
            Color("Color BG")
                .ignoresSafeArea()
            VStack {
                VStack {
                    Text("\(currentDate)")
                        .font(.system(size: 30))
                    Text("\(currentTime)")
                        .font(.system(size: 27))
                }
                .offset(x: 0, y: 150)
                
                Spacer()
                
                VStack {
                    Text("Resueltos Hoy")
                        .font(.system(size: 25))
                    Text("Acciones: 1")
                        .font(.system(size: 22))
                }
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .offset(x: 0, y: 150)
                
                Spacer()
            }
        }
        .onAppear {
            getDate()
        }
    }
    
    func getDate() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es")
        formatter.dateFormat = "EEEE d MMMM"

        var date = formatter.string(from: today).capitalized.components(separatedBy: " ")
        date.insert("de", at: 2)
        
        formatter.dateFormat = "h:mm:ss a"
        let time = formatter.string(from: Date()).uppercased()
        
        currentDate = date.joined(separator: " ")
        currentTime = time
    }
}

struct HomeVW_Previews: PreviewProvider {
    static var previews: some View {
        HomeVW()
            .preferredColorScheme(.dark)
    }
}
