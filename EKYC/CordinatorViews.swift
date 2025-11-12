//
//  CordinatorViews.swift
//  EKYC
//
//  Created by MacBookPro on 12/11/2025.
//

import Foundation
import SwiftUI

struct NavigationCoordinator: View {
    @StateObject private var navigationManager = AppRouter()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            HomeScanID()
                .navigationDestination(for: AppNavigationPath.self) { destination in
                    switch destination {
                    case .homeId:
                        HomeScanID()
                            .navigationBarBackButtonHidden(true)
                    case .scanID:
                        ScanIDView()
                            .navigationBarBackButtonHidden(true)
                    case .scanFace:
                        ScanFaceID()
                            .navigationBarBackButtonHidden(true)
                    case .homeFace:
                        HomeScanFace()
                            .navigationBarBackButtonHidden(true)
                    }
                }
        }
        .environmentObject(navigationManager)
    }
}
