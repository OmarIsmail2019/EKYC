//
//  ScanImg.swift
//  EKYC
//
//  Created by MacBookPro on 12/11/2025.
//

import Foundation
import SwiftUI
import UIKit

struct ScanIDView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var isLoading: Bool = false
    @EnvironmentObject var navigationManager: AppRouter

    var body: some View {
        ZStack {
            // ✅ Background color covering full screen
            Color(red: 36/255, green: 19/255, blue: 50/255)
                .ignoresSafeArea()

            VStack {
                if isLoading {
                    VStack(spacing: 10) {
                        Image("idImg")
                        Text("Please Wait…")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .onAppear {
                           // Delay for 3 seconds, then navigate
                           DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                               isLoading = false
                               navigationManager.push(.homeFace)
                           }
                       }
                } else {
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Scan Your ID Card Front")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Lorem Ipsum text describes this step")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 44)

                            Spacer()
                        }

                        Spacer()

                        // ✅ Center placeholder rectangle
                        CustomeImgView(image: selectedImage)

                        Spacer()

                        if selectedImage != nil {
                            HStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color(hex: 0xff702283), lineWidth: 1)
                                    .frame(width: 165, height: 42)
                                    .overlay {
                                        CustomeBtn(
                                            width: 160,
                                            height: 40,
                                            textColor: Color(hex: 0xff702283),
                                            backColor: .white,
                                            title: "Re Take",
                                            titleSize: 14,
                                            action: {
                                                selectedImage = nil
                                            }
                                        )
                                        .padding(2)
                                    }

                                Spacer()

                                CustomeBtn(
                                    width: 160,
                                    height: 40,
                                    textColor: .white,
                                    backColor: Color(hex: 0xff702283),
                                    title: "Confirm",
                                    titleSize: 14,
                                    action: {
                                        isLoading = true
                                    }
                                )
                            }
                            .padding()
                        } else {
                            Button(action: {
                                showImagePicker = true
                            }) {
                                Image("camera")
                                    .font(.system(size: 24))
                                    .padding()
                                    .background(Color(hex: 0xff702283))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .padding(.top, 20)
        }
        // ✅ Image Picker Sheet
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}


// MARK: - Preview
struct ScanIDView_Previews: PreviewProvider {
    static var previews: some View {
        ScanIDView()
    }
}


struct CustomeImgView : View {
    var image: UIImage?
    var body : some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(Color.white.opacity(0.4), lineWidth: 1)
            .padding(-5)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(hex: 0xffBABABA)))
            .frame(height: 120)
            .padding(.horizontal, 28)
            .overlay {
                if let image = image {
                    // ✅ Show selected image
                    Image(uiImage: image)
                        .resizable()
                        .frame(height: 120)
                        .padding(.horizontal , 28)
                } else {
                    // ✅ Placeholder icon
                    Image("gallery")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                }
            }
        
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary // 🔁 تقدر تغيّرها إلى .camera لو عايز الكاميرا
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
