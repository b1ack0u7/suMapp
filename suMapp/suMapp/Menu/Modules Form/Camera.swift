//
//  Camera.swift
//  Banco de tiempo
//
//  Created by Axel Montes de Oca on 09/09/21.
//

import SwiftUI
import AVFoundation

struct CameraLayout: View {
    @StateObject var camera = CameraModel()
    @Binding var isShowingCamera:Bool
    @Binding var pic:String
    @Binding var picState:Bool
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                if(camera.isTaken) {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            camera.reTake()
                        }, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                    }
                    .padding([.top, .trailing], 20)
                }
                
                Spacer()
                
                HStack {
                    if(camera.isTaken) {
                        Button(action: {
                            pic = camera.picDataEncoded64
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                withAnimation(.easeInOut){
                                    picState = true
                                }
                            }
                            isShowingCamera = false
                        }, label: {
                            Text("Guardar")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        
                        Spacer()
                    }
                    else {
                        Button(action: camera.takePic, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65, alignment: .center)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75, alignment: .center)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear {
            camera.Check()
        }
    }
}


class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    @Published var preview = AVCaptureVideoPreviewLayer()
    
    @Published var picData = Data(count: 0)
    @Published var picDataEncoded64 = ""
    
    func Check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if(status) {
                    self.setUp()
                }
            }
            
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
    }

    func setUp(){
        do {
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            if(self.session.canAddInput(input)) {
                self.session.addInput(input)
            }
            
            if(self.session.canAddOutput(self.output)) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func takePic(){
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation {self.isTaken.toggle()}
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if(error != nil) {
            return
        }
        
        //Stop image preview
        self.session.stopRunning()
        DispatchQueue.main.async {
            withAnimation{self.isTaken.toggle()}
        }

        
        guard let imageData = photo.fileDataRepresentation() else{return}
        self.picData = imageData
        
        compressImage(dataPassed: self.picData)
    }
    
    private func compressImage(dataPassed:Data){
        let uiImage:UIImage = UIImage(data: dataPassed)!
        let imagePNG:Data = uiImage.pngData()!
        let imageSTR:String = imagePNG.base64EncodedString()
        
        self.picDataEncoded64 = imageSTR
    }
}

private struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
