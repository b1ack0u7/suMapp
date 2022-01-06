//
//  LoginVW.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import SwiftUI

private struct UserData: Decodable {
    var user:String = "axel"
    var pass:String = "123"
    var api:String?
}

struct LoginVW: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: [], animation: .default) private var items: FetchedResults<Item>
    
    private enum Field {
        case user
        case pass
    }
    
    @Binding var isLogged:Bool
    @Binding var showLogin:Bool
    @Binding var dataToPass:STCdataTrans
    @FocusState private var focusField: Field?
    
    @State private var userData:UserData = UserData()
    @State private var isLoading:Bool = false
    @State private var inteliBlock:Bool = false
    @State private var showError:Bool = false
    @State private var verboseLoading:String = ""
    
    private let apiURL:String = "https://run.mocky.io/v3/e7256f8c-2949-4cfb-9d7f-af062236f648"
    
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
                    .offset(x: 0, y: isLogged ? 0 : -60)
                
                if(!isLogged) {
                    //User
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
                    }
                    .frame(width: 300, height: 50, alignment: .center)
                    
                    //Password
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
                    }
                    .frame(width: 300, height: 50, alignment: .center)
                    
                    //Button access
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
                }
                
                if(isLoading) {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(1.5)
                            .padding(.bottom, 5)
                        Text("\(verboseLoading)")
                            .foregroundColor(.gray)
                    }
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
        .onAppear {
            if(isLogged) {
                isLoading = true
                verboseLoading = "Cargando"
                setTransferableData()
            }
            
        }
    }
    
    private func authenticateCredentials() {
        inteliBlock = true
        isLoading = true
        showError = false
        verboseLoading = "Iniciando Sesión"
        guard let url = URL(string: apiURL) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, _) in
            do {
                guard let data = data else {return}
                let decoded = try JSONDecoder().decode(UserData.self, from: data)
                DispatchQueue.main.async {
                    if(decoded.user == userData.user && decoded.pass == userData.pass) {
                        userData.api = decoded.api
                        fetchForm()
                    }
                    else {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                        userData.pass = ""
                        isLoading = false
                        showError = true
                    }
                }
                
            } catch let error as NSError {
                print("DBG: API error: ",error.localizedDescription)
            }
        }.resume()
    }
    
    private func fetchForm() {
        verboseLoading = "Descargando formularios"
        guard let url = URL(string: userData.api!) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, _) in
            do {
                guard let data = data else {return}
                let decoded = try JSONDecoder().decode(myTest.self, from: data)
                DispatchQueue.main.async {
                    //saveData(dataForm: decoded)
                    for i in 0..<decoded.sections.count {
                        print("DBG: \(decoded.sections[i].name)")
                    }
                }
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }.resume()
    }
    
    private func saveData(dataForm:STCdataApi) {
        verboseLoading = "Guardando formularios"
        DispatchQueue.global(qos: .utility).async {
            var tmpRegions:[String] = []
            for i in 0..<dataForm.regions!.count {
                tmpRegions.append(dataForm.regions![i].name)
            }
            
            var tmpSection:[mySection] = []
            var tmpDataForm:[myForm] = []
            for i in 0..<dataForm.sections!.count {
                for j in 0..<dataForm.sections![i].dataform.count {
                    tmpDataForm.append(myForm(functype: dataForm.sections![i].dataform[j].functype, parameters: dataForm.sections![i].dataform[j].parameters))
                }
                tmpSection.append(mySection(name: dataForm.sections![i].name, form: tmpDataForm))
                tmpDataForm = []
            }
            
            let newRegions:Regions = Regions(region: tmpRegions)
            let newSections:Sections = Sections(sections: tmpSection)
            
            let newItem = Item(context: viewContext)
            newItem.regions = newRegions
            newItem.sections = newSections
            
            do {
                try viewContext.save()
                print("Data saved")
                
                UserDefaults.standard.set(true, forKey: "isLogged")
                UserDefaults.standard.set(userData.api, forKey: "api")
                setTransferableData()
            } catch {
                let nsError = error as NSError
                print("DBGE: Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func setTransferableData() {
        verboseLoading = "Cargando"
        DispatchQueue.global(qos: .background).async {
            var tmpRegions:[String] = []
            var tmpSections:[String] = []
            var tmpDataFormAUX:[STCform] = []
            var tmpDataForm:[[STCform]] = []
            
            for i in 0..<items[0].regions!.region.count {
                tmpRegions.append(items[0].regions!.region[i])
            }
            
            for i in 0..<(items[0].sections?.sections.count)! {
                tmpSections.append((items[0].sections?.sections[i].name)!)
                for j in 0..<(items[0].sections?.sections[i].form.count)! {
                    tmpDataFormAUX.append(STCform(functype: items[0].sections!.sections[i].form[j].functype, parameters: items[0].sections!.sections[i].form[j].parameters))
                }
                tmpDataForm.append(tmpDataFormAUX)
                tmpDataFormAUX = []
            }
            DispatchQueue.main.async {
                dataToPass.regions = tmpRegions
                dataToPass.sections = tmpSections
                dataToPass.dataForm = tmpDataForm
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                isLoading = false
                withAnimation(.easeInOut) {
                    showLogin.toggle()
                }
            }
        }
    }
}

struct LoginVW_Previews: PreviewProvider {
    static var previews: some View {
        LoginVW(isLogged: .constant(false), showLogin: .constant(true), dataToPass: .constant(STCdataTrans()))
            .environmentObject(CLSDataTrans())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
