//
//  AlertsVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import SwiftUI

struct AlertsVW: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            ProgressView()
                .progressViewStyle(LinearProgressViewStyle(tint: .red))
            Spacer()
        }
        
    }
}

struct AlertsVW_Previews: PreviewProvider {
    static var previews: some View {
        AlertsVW()
    }
}
