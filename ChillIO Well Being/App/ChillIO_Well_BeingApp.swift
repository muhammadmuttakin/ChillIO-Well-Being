//
//  ChillIO_Well_BeingApp.swift
//  ChillIO Well Being
//
//  Created by Muhammad Muttakin on 12/03/26.
//

import SwiftUI

@main
struct ChillIO_Well_BeingApp: App {
    @StateObject private var router = AppRouter()
        
        var body: some Scene {
            WindowGroup {
                RootView()
                    .environmentObject(router)
            }
        }
}
