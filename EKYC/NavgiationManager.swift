//
//  NavgiationManager.swift
//  EKYC
//
//  Created by MacBookPro on 12/11/2025.
//

import Foundation
import SwiftUI
import Combine

final class AppRouter: ObservableObject {
    // This is the path used by NavigationStack
    @Published var path: [AppNavigationPath] = []

    // Push a new screen
    func push(_ destination: AppNavigationPath) {
        path.append(destination)
    }

    // Pop the last screen
    func pop() {
        _ = path.popLast()
    }
    // Pop to root (home)
    func popToRoot() {
        path.removeAll()
    }

    // Set full navigation path (for deep links etc.)
    func setPath(_ newPath: [AppNavigationPath]) {
        path = newPath
    }
}

enum AppNavigationPath: Hashable  {
    case homeId
    case scanID
    case scanFace
    case homeFace
}
