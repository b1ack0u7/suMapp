//
//  Camera.swift
//  suMapp
//
//  Created by Axel Montes de Oca on 28/12/21.
//

import SwiftUI
import AVFoundation

struct CameraLayout: View {
    @StateObject var camera = CameraModel()
    @Binding var isShowingCamera:Bool
    @Binding var pic:String
    @Binding var picState:Bool
    
    @State private var isActiveTorch:Bool = false
    @State private var inteliLockTorch:Bool = false //Disable torch?
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Spacer()
                
                ZStack {
                    if(camera.isTaken) {
                        //Save Button
                        Button(action: {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
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
                                .opacity(0.85)
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        
                        //Retake Button
                        Button(action: {
                            camera.reTake()
                            inteliLockTorch = false
                        }, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.85))
                                    .frame(width: 65, height: 65, alignment: .center)
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                    .padding()
                            }
                        })
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    else {
                        //Button Take Picture
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            camera.takePic()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isActiveTorch = false
                                camera.toggleTorch(on: isActiveTorch)
                                inteliLockTorch = true
                            }
                        }, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65, alignment: .center)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75, alignment: .center)
                            }
                            .opacity(0.85)
                        })
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    //Button torch
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        isActiveTorch.toggle()
                        camera.toggleTorch(on: isActiveTorch)
                    }, label: {
                        Image(systemName: isActiveTorch ? "flashlight.on.fill" : "flashlight.off.fill")
                            .foregroundColor(isActiveTorch ? .black : .white)
                            .padding()
                            .background(isActiveTorch ? Color.white.opacity(0.75) : Color.gray.opacity(0.75))
                            .clipShape(Circle())
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20)
                    .disabled(inteliLockTorch)
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
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("DBGE: Torch could not be used")
            }
        } else {
            print("DBGE: Torch is not available")
        }
    }
    
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
