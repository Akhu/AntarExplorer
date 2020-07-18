//
//  iOSAntarExplorerApp.swift
//  iOSAntarExplorer
//
//  Created by Anthony Da Cruz on 26/06/2020.
//

import SwiftUI

@main
struct iOSAntarExplorerApp: App {
    
    @StateObject var appState: AppData = AppData()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState)
        }
    }
}
