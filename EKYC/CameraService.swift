import SwiftUI
import AVFoundation

// MARK: - CameraViewModel
final class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var capturedImage: UIImage?
    @Published var session = AVCaptureSession()
    @Published var isSessionRunning = false
    @Published var errorMessage: String?

    private let output = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    override init() {
        super.init()
        checkPermissions()
    }

    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { self.configureSession() }
                else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Camera access denied."
                    }
                }
            }
        case .denied, .restricted:
            errorMessage = "Camera permission is denied. Please enable it in settings."
        @unknown default:
            errorMessage = "Unknown authorization status."
        }
    }

    func configureSession() {
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo

            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: device),
                  self.session.canAddInput(input)
            else {
                DispatchQueue.main.async {
                    self.errorMessage = "Cannot access the camera."
                }
                return
            }

            self.session.addInput(input)

            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }

            self.session.commitConfiguration()
            self.startSession()
        }
    }

    func startSession() {
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = true
                }
            }
        }
    }

    func stopSession() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = false
                }
            }
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        output.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard error == nil, let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}

// MARK: - CameraPreview
struct CameraPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }

    @ObservedObject var viewModel: CameraViewModel

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.videoPreviewLayer.session = viewModel.session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) { }
}

// MARK: - ScanIDView
struct ScanIDView2: View {
    @StateObject private var cameraViewModel = CameraViewModel()

    var body: some View {
        ZStack {
            if let image = cameraViewModel.capturedImage {
                // ✅ After Capture — Show Preview
                VStack {
                    Spacer()
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(12)
                        .padding(.horizontal, 30)

                    Spacer()

                    HStack(spacing: 16) {
                        Button(action: {
                            cameraViewModel.capturedImage = nil
                            cameraViewModel.startSession()
                        }) {
                            Text("Re Take")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(Color.purple)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.purple, lineWidth: 1))
                        }

                        Button(action: {
                            print("✅ Confirmed ID photo.")
                        }) {
                            Text("Confirm")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            } else {
                // ✅ Live Camera View
                VStack(spacing: 20) {
                    Text("Scan Your ID Card Front")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, 60)

                    Text("Lorem Ipsum text describes this step")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))

                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 220)
                            .cornerRadius(12)
                            .overlay(CameraPreview(viewModel: cameraViewModel)
                                        .cornerRadius(12))
                    }
                    .padding(.horizontal, 30)

                    Spacer()

                    Button(action: {
                        cameraViewModel.capturePhoto()
                        cameraViewModel.stopSession()
                    }) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 24))
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 40)
                }
                .background(Color(red: 0.4, green: 0.3, blue: 0.5))
                .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            cameraViewModel.startSession()
        }
        .onDisappear {
            cameraViewModel.stopSession()
        }
    }
}


struct ScanIDView2_Previews: PreviewProvider {
    static var previews: some View {
        ScanIDView2()
    }
}

