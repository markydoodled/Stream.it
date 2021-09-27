//
//  Stream_itApp.swift
//  Stream.it
//
//  Created by Mark Howard on 26/09/2021.
//

import SwiftUI

@main
struct Stream_itApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 750, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
        }
        Settings {
            SettingsView()
        }
        .commands {
            SidebarCommands()
        }
    }
}
