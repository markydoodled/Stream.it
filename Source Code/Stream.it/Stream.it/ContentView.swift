//
//  ContentView.swift
//  Stream.it
//
//  Created by Mark Howard on 26/09/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                    NavigationLink(destination: Video()) {
                        Label("Video", systemImage: "camera")
                    }
                    NavigationLink(destination: Audio()) {
                        Label("Audio", systemImage: "headphones")
                    }
            }
            .listStyle(SidebarListStyle())
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
        .toolbar {
            ToolbarItem(placement: .navigation) {
            Button(action: {NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)}) {
                Image(systemName: "sidebar.left")
            }
            .help("Toggle Sidebar")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
