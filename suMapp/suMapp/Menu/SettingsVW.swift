//
//  SettingsVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 07/12/21.
//

import SwiftUI
import UserNotifications
import Darwin

//Resources: Logout
//https://stackoverflow.com/questions/52275684/how-can-i-restart-an-application-programmatically-in-swift-4-on-ios/52278301#52278301

struct SettingsVW: View {
    @State private var showConfirm = false
    
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
                restartApplication()
            },
            secondaryButton: .cancel(Text("No"))
        )
    }
    
    func restartApplication(){
        var localUserInfo: [AnyHashable : Any] = [:]
        localUserInfo["pushType"] = "restart"
        
        let content = UNMutableNotificationContent()
        content.title = "Configuration Update Complete"
        content.body = "Tap to reopen the application"
        content.sound = UNNotificationSound.default
        content.userInfo = localUserInfo
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)

        let identifier = "AetherSTD.suMapp"
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request)
        exit(0)
    }
}

struct SettingsVW_Previews: PreviewProvider {
    static var previews: some View {
        SettingsVW()
            .colorScheme(.dark)
    }
}
