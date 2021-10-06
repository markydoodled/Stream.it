//
//  ContentView.swift
//  Stream.it tvOS
//
//  Created by Mark Howard on 27/09/2021.
//

import SwiftUI

struct ContentView: View {
    @State var tabSelection = 1
    var body: some View {
        NavigationView {
        TabView(selection: $tabSelection) {
         Video()
                .tag(1)
                .tabItem {
                    VStack {
                    Image(systemName: "camera")
                    Text("Video")
                    }
                }
            Audio()
                .tag(2)
                .tabItem {
                    VStack {
                        Image(systemName: "headphones")
                        Text("Audio")
                    }
                }
            SettingsView()
                .tag(3)
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                }
        }
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
