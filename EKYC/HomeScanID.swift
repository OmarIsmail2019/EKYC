//
//  ContentView.swift
//  EKYC
//
//  Created by MacBookPro on 12/11/2025.
//

import SwiftUI

struct HomeScanID: View {
    @EnvironmentObject var navigationManager: AppRouter
    var body: some View {
        VStack (alignment: .center ,spacing: 20){
            Spacer()
            // Head Image
            Image("idImg")
                .resizable()
                .frame(maxWidth:  215 , maxHeight: 120 , alignment: .center)
            
            Text("Your scan will be rejected for any the following")
                .font(.system(size: 14 , weight: .regular))
                .foregroundColor(Color(hex: 0xff313131))
                .padding(.bottom , 20)
            
            VStack(spacing: 12) {
                ForEach(documentScan) { item in
                    CustomeDescription(item: item)
                }
            }
            Spacer()
            CustomeBtn(width: .infinity, height: 55, textColor: .white, backColor: Color(hex: 0xff702283), title: "Continue", titleSize: 20, action: {
                navigationManager.push(.scanID)
            })
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScanID()
    }
}

struct DescriptionItem : Identifiable ,Hashable {
    let id: UUID
    let image: String
    let description: String
    
    init(id: UUID = UUID(), image: String, description: String) {
        self.id = id
        self.image = image
        self.description = description
    }
}

struct CustomeDescription : View {
    let item : DescriptionItem
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(Color(hex: 0xff962071))
                .frame(width: 50 , height: 50)
                .overlay{
                    Image(item.image)
                        .resizable()
                        .frame(width: 30 , height: 30)
                }
            
            Text(item.description)
                .font(.system(size: 14 , weight: .regular))
                .foregroundColor(Color(hex: 0xff313131))
            
        }
        .frame(maxWidth: .infinity , alignment: .leading)
    }
}

enum CaseScan {
    case documnt
    case face
}


extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}

var documentScan: [DescriptionItem] {
    return [
        DescriptionItem(
            image: "light",
            description: "Photo lighting is not clear"
        ),
        DescriptionItem(
            image: "angle",
            description: "Photo angle is not correct"
        ),
        DescriptionItem(
            image: "scanImg",
            description: "Photo not fixed in the scan box"
        )
    ]
}

var faceScan: [DescriptionItem] {
    return [
        DescriptionItem(
            image: "mask",
            description: "Headgear or Mask"
        ),
        DescriptionItem(
            image: "glass",
            description: "Sunglasses"
        ),
        DescriptionItem(
            image: "scanFace",
            description: "Face Cut of Frame"
        )
    ]
}


struct CustomeBtn : View {
    var width : CGFloat
    var height : CGFloat
    var textColor : Color
    var backColor : Color
    var title : String
    var titleSize : CGFloat
    var action : () -> Void
    
    var body: some View {
        Button {
          action()
        } label: {
            Text(title)
                .foregroundColor(textColor)
                .font(.system(size: titleSize , weight: .semibold))
        }
        .frame(maxWidth: width , maxHeight: height)
        .background(backColor)
        .cornerRadius(8)
    }
}
