//
//  LoginVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 07/12/21.
//

import SwiftUI

private struct UserData: Decodable {
    var user:String = ""
    var pass:String = ""
}

struct LoginVW: View {
    @Environment(\.managedObjectContext) private var viewContext

    enum Field {
        case user
        case pass
    }
    
    @State private var userData = UserData()
    @FocusState private var focusField: Field?
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("BG")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }.edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .offset(x: 0, y: -60)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.linearGradient(Gradient(colors: [Color(#colorLiteral(red: 0.2190982836, green: 0.2480710534, blue: 0.3889210015, alpha: 1)), Color(#colorLiteral(red: 0.9602280259, green: 0.5539468527, blue: 0.2222737372, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 5)
                    ZStack {
                        Color.white
                        HStack {
                            Image(systemName: "person.fill")
                                .padding(.leading, 10)
                                .foregroundColor(.black)
                            TextField("Ingrese su usuario", text: $userData.user)
                                .foregroundColor(.black)
                                .placeholder(when: userData.user.isEmpty) {
                                    Text("Ingrese su usuario").foregroundColor(.gray)
                                }
                                .focused($focusField, equals: .user)
                                .submitLabel(.next)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                        }
                    }
                    Rectangle()
                        .fill(.linearGradient(Gradient(colors: [Color(#colorLiteral(red: 0.2190982836, green: 0.2480710534, blue: 0.3889210015, alpha: 1)), Color(#colorLiteral(red: 0.9602280259, green: 0.5539468527, blue: 0.2222737372, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 5)
                }.frame(width: 300, height: 50, alignment: .center)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.linearGradient(Gradient(colors: [Color(#colorLiteral(red: 0.2190982836, green: 0.2480710534, blue: 0.3889210015, alpha: 1)), Color(#colorLiteral(red: 0.9602280259, green: 0.5539468527, blue: 0.2222737372, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 5)
                    ZStack {
                        Color.white
                        HStack {
                            Image(systemName: "lock.fill")
                                .padding(.leading, 10)
                                .foregroundColor(.black)
                            SecureField("Ingrese su contraseña", text: $userData.pass)
                                .foregroundColor(.black)
                                .placeholder(when: userData.pass.isEmpty) {
                                    Text("Ingrese su contraseña").foregroundColor(.gray)
                                }
                                .focused($focusField, equals: .pass)
                                .submitLabel(.done)
                                .textContentType(.password)
                                .keyboardType(.default)
                        }
                    }
                    Rectangle()
                        .fill(.linearGradient(Gradient(colors: [Color(#colorLiteral(red: 0.2190982836, green: 0.2480710534, blue: 0.3889210015, alpha: 1)), Color(#colorLiteral(red: 0.9602280259, green: 0.5539468527, blue: 0.2222737372, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 5)
                }.frame(width: 300, height: 50, alignment: .center)
                
                Button(action: {
                    guard let url = URL(string: "https://run.mocky.io/v3/c788aa59-f970-49c3-8f18-7eac26b805d9") else {return}
                    URLSession.shared.dataTask(with: url) {(data, response, _) in
                        do {
                            guard let data = data else {return}
                            let decoded = try JSONDecoder().decode(UserData.self, from: data)
                            DispatchQueue.main.async {
                                if(decoded.user == userData.user && decoded.pass == userData.pass) {
                                    
                                }
                            }
                            
                        } catch let error as NSError {
                            print("DBG: API error: ",error.localizedDescription)
                        }
                    }.resume()
                    
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.linearGradient(Gradient(colors: [Color(#colorLiteral(red: 0.2190982836, green: 0.2480710534, blue: 0.3889210015, alpha: 1)), Color(#colorLiteral(red: 0.9602280259, green: 0.5539468527, blue: 0.2222737372, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                        
                        HStack {
                            Text("Ingresar")
                                .foregroundColor(.white)
                                .bold()
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                        }
                    }
                })
                    .frame(width: 120, height: 40, alignment: .center)
                    .offset(x: 0, y: 40)
                
            }
            .onSubmit {
                switch focusField {
                    case .user:
                        focusField = .pass
                    default:
                        print("DBG: ")
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

struct LoginVW_Previews: PreviewProvider {
    static var previews: some View {
        LoginVW()
    }
}
