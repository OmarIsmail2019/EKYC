//
//  ScanFace.swift
//  EKYC
//
//  Created by MacBookPro on 12/11/2025.
//

import SwiftUI

struct HomeScanFace: View {
    @EnvironmentObject var navigationManager: AppRouter
    var body: some View {
        VStack (alignment: .center ,spacing: 20){
            Spacer()
            // Head Image
            Image("face")
                .resizable()
                .frame(maxWidth:  140 , maxHeight: 140 , alignment: .center)
            
            Text("Your verification will be rejected for any the following")
                .font(.system(size: 14 , weight: .regular))
                .foregroundColor(Color(hex: 0xff313131))
                .padding(.bottom , 20)
            
            VStack(spacing: 12) {
                ForEach(faceScan) { item in
                    CustomeDescription(item: item)
                }
            }
            Spacer()
            CustomeBtn(width: .infinity, height: 55, textColor: .white, backColor: Color(hex: 0xff702283), title: "Continue", titleSize: 20, action: {
                navigationManager.push(.scanFace)
            })
        }
        .padding()
    }
}

struct ScanFace_Previews: PreviewProvider {
    static var previews: some View {
        HomeScanFace()
    }
}
