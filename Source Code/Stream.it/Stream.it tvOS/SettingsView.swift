//
//  SettingsView.swift
//  Stream.it tvOS
//
//  Created by Mark Howard on 27/09/2021.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
