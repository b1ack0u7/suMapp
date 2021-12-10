//
//  SettingsVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 07/12/21.
//

import SwiftUI
import UserNotifications

//Resources: Logout
//https://stackoverflow.com/questions/52275684/how-can-i-restart-an-application-programmatically-in-swift-4-on-ios/52278301#52278301

struct SettingsVW: View {
    @Binding var isLogged:Bool
    @State private var showConfirm:Bool = false
    
    
    var body: some View {
        ZStack {
            Color("ITF BG")
                .ignoresSafeArea()
            Button(action: {
                UserDefaults.standard.removeObject(forKey: "isLogged")
                UserDefaults.standard.removeObject(forKey: "api")
                showConfirm = true
            }, label: {
                VStack {
                    Text("Cerrar sesión")
                }
            })
        }
        .alert(isPresented: $showConfirm, content: { confirmChange })
    }
    
    var confirmChange: Alert {
        Alert(title: Text("¿Desea cerrar sesión?"), message: Text("La aplicacion se cerrara y se guardara todos los datos"),
            primaryButton: .default (Text("Si")) {
            withAnimation(.easeInOut) {
                isLogged = false
            }
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
}

struct SettingsVW_Previews: PreviewProvider {
    static var previews: some View {
        SettingsVW(isLogged: .constant(true))
            .colorScheme(.dark)
    }
}
