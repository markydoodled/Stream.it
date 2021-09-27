//
//  ContentView.swift
//  Stream.it iOS
//
//  Created by Mark Howard on 26/09/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var tabSelection = 1
    @State var showingSettings = false
    @StateObject private var youtubeplayer = YouTubeControlState()
    var body: some View {
        if horizontalSizeClass == .compact {
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
                YouTube()
                    .tag(3)
                    .environmentObject(youtubeplayer)
                    .tabItem {
                        VStack {
                            Image(systemName: "tv.music.note")
                            Text("YouTube")
                        }
                    }
                SettingsView()
                    .tag(4)
                    .tabItem {
                        VStack {
                            Image(systemName: "gearshape")
                            Text("Settings")
                        }
                    }
            }
        } else {
            NavigationView {
                List {
                    NavigationLink(destination: Video()) {
                        Label("Video", systemImage: "camera")
                    }
                    NavigationLink(destination: Audio()) {
                        Label("Audio", systemImage: "headphones")
                    }
                    NavigationLink(destination: YouTube().environmentObject(youtubeplayer)) {
                        Label("YouTube", systemImage: "tv.music.note")
                    }
                }
                .listStyle(SidebarListStyle())
                .navigationTitle("Stream.it")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {self.showingSettings = true}) {
                            Image(systemName: "gearshape")
                        }
                        .sheet(isPresented: $showingSettings) {
                            settings
                        }
                    }
                }
                VStack {
                    Image("AppsIcon")
                        .resizable()
                        .cornerRadius(25)
                        .frame(width: 150, height: 150)
                    Text("Stream.it")
                        .font(.title2)
                        .bold()
                        .padding()
                }
            }
        }
    }
    var settings: some View {
        NavigationView {
        Form {
            Section(header: Label("Info", systemImage: "info.circle")) {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0")
            }
            HStack {
                Text("Build")
                Spacer()
                Text("1")
            }
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {self.showingSettings = false}) {
                    Text("Done")
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
