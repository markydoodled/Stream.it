//
//  SettingsView.swift
//  Stream.it iOS
//
//  Created by Mark Howard on 26/09/2021.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
        Form {
            Section(header: Label("Info", systemImage: "info.circle")) {
            HStack {
                Text("Version")
                Spacer()
                Text("1.1")
            }
            HStack {
                Text("Build")
                Spacer()
                Text("3")
            }
            }
        }
        .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
