//
//  DetailedFormVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 08/12/21.
//

import SwiftUI

struct DetailedFormVW: View {
    let dataForm:[STCform]
    
    var body: some View {
        ZStack {
            Color("Color BG")
                .ignoresSafeArea()
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

struct DetailedFormVW_Previews: PreviewProvider {
    static var previews: some View {
        DetailedFormVW(dataForm: [STCform(functype: "checkBox", parameters: "1")])
    }
}
