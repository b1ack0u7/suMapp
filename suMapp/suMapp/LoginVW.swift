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
    var api:String?
}

struct LoginVW: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: [], animation: .default) private var items: FetchedResults<Item>
    
    enum Field {
        case user
        case pass
    }
    
    @State private var userData:UserData = UserData()
    //@State private var dataForm:STCdataApi = STCdataApi()
    @State private var isLoading:Bool = false
    @State private var inteliBlock:Bool = false
    @State private var showError:Bool = false
    @Binding var showLoggin:Bool
    @FocusState private var focusField: Field?
    
    private let apiURL:String = "https://run.mocky.io/v3/1aae8b05-a093-433d-a9f2-366ca7742d82"
    
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
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .onTapGesture {showError = false}
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
                                .onTapGesture {showError = false}
                        }
                    }
                    Rectangle()
                        .fill(.linearGradient(Gradient(colors: [Color(#colorLiteral(red: 0.2190982836, green: 0.2480710534, blue: 0.3889210015, alpha: 1)), Color(#colorLiteral(red: 0.9602280259, green: 0.5539468527, blue: 0.2222737372, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 5)
                }.frame(width: 300, height: 50, alignment: .center)
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for:nil)
                    authenticateCredentials()
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
                    .disabled(inteliBlock)
                    .frame(width: 120, height: 40, alignment: .center)
                    .offset(x: 0, y: 40)
                
                if(isLoading) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(1.5)
                        .offset(x: 0, y: 80)
                }
                
                if(showError) {
                    Text("Credenciales invalidas")
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                        .bold()
                        .offset(x: 0, y: 100)
                }
            }
            .onSubmit {
                switch focusField {
                    case .user:
                        focusField = .pass
                    default:
                        authenticateCredentials()
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    private func authenticateCredentials() {
        inteliBlock = true
        isLoading = true
        showError = false
        guard let url = URL(string: apiURL) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, _) in
            do {
                guard let data = data else {return}
                let decoded = try JSONDecoder().decode(UserData.self, from: data)
                DispatchQueue.main.async {
                    isLoading = false
                    if(decoded.user == userData.user && decoded.pass == userData.pass) {
                        userData.api = decoded.api
                        fetchForm()
                    }
                    else {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                        userData.pass = ""
                        showError = true
                    }
                }
                
            } catch let error as NSError {
                print("DBG: API error: ",error.localizedDescription)
            }
        }.resume()
    }
    
    private func fetchForm() {
        guard let url = URL(string: userData.api!) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, _) in
            do {
                guard let data = data else {return}
                let decoded = try JSONDecoder().decode(STCdataApi.self, from: data)
                DispatchQueue.main.async {
                    UserDefaults.standard.set(true, forKey: "isLogged")
                    UserDefaults.standard.set(userData.api, forKey: "api")
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    saveData(dataForm: decoded)
                    withAnimation(.easeInOut) {
                        showLoggin.toggle()
                    }
                }
            } catch let error as NSError {
                print("DBG: API error: ",error.localizedDescription)
            }
        }.resume()
    }
    
    private func saveData(dataForm:STCdataApi) {
        DispatchQueue.global(qos: .utility).async {
            var newRegions:[Regions] = []
            var newForm:[Form] = []
            
            for i in 0..<dataForm.regions!.count {
                newRegions.append(Regions(name: dataForm.regions![i].name))
            }
            for i in 0..<dataForm.dataform!.count {
                newForm.append(Form(functype: dataForm.dataform![i].functype, parameters: dataForm.dataform![i].parameters))
            }
            
            let newItem = Item(context: viewContext)
            newItem.regions = newRegions
            newItem.form = newForm
            do {
                try viewContext.save()
                print("Data saved")
            } catch {
                let nsError = error as NSError
                fatalError("DBGE: Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct LoginVW_Previews: PreviewProvider {
    static var previews: some View {
        LoginVW(showLoggin: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
