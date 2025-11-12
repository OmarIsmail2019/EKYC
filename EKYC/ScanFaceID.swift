//
//  ScanFaceID.swift
//  EKYC
//
//  Created by MacBookPro on 12/11/2025.
//

import SwiftUI

struct ScanFaceID: View {
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
                        Image("face")
                        Text("Matching Selfie With ID")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .onAppear {
                           // Delay for 3 seconds, then navigate
                           DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                               isLoading = false
                               navigationManager.push(.scanFace)
                           }
                       }
                } else {
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Scan Your Face")
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

struct ScanFaceID_Previews: PreviewProvider {
    static var previews: some View {
        ScanFaceID()
    }
}
