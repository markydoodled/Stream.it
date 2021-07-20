//
//  ContentView.swift
//  Stream.it
//
//  Created by Mark Howard on 19/06/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var tabSelction = 1
    @State var showingSettings = false
    var body: some View {
        if horizontalSizeClass == .compact {
            TabView(selection: $tabSelction) {
                Video(fileURL: URL(string: "/")!)
                    .tag(1)
                    .tabItem {
                        VStack {
                            Image(systemName: "camera")
                            Text("Video")
                        }
                    }
                Audio(fileURL: URL(string: "/")!)
                    .tag(2)
                    .tabItem {
                        VStack {
                            Image(systemName: "headphones")
                            Text("Audio")
                        }
                    }
                NavigationView {
                    Text("Tset")
                        .navigationTitle("More")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {self.showingSettings = true}) {
                                    Image(systemName: "gearshape")
                                }
                                .sheet(isPresented: $showingSettings) {
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
                        }
                }
                .tag(3)
                .tabItem {
                    VStack {
                        Image(systemName: "ellipsis.circle")
                        Text("More")
                    }
                }
            }
        } else {
            NavigationView {
                List {
                    NavigationLink(destination: Video(fileURL: URL(string: "/")!)) {
                        Label("Video", systemImage: "camera")
                    }
                    NavigationLink(destination: Audio(fileURL: URL(string: "/")!)) {
                        Label("Audio", systemImage: "headphones")
                    }
                    NavigationLink(destination: Youtube()) {
                        Label("YouTube", systemImage: "play.rectangle")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
