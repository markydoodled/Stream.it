//
//  Audio.swift
//  Stream.it
//
//  Created by Mark Howard on 26/09/2021.
//

import SwiftUI
import AVKit
import AVFoundation

struct Audio: View {
    @State var audioURL = URL(string: "/")
    @State var showingURL = false
    @State var urlText = ""
    @State var urlEntered = 0
    var body: some View {
        let play = AVPlayer(url: (audioURL ?? URL(string: "/"))!)
        Form {
        AVPlayerViewControl(videoURL: $audioURL, player: play)
        }
        .navigationTitle("Audio")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {self.showingURL = true}) {
                    Image(systemName: "curlybraces")
                }
                .sheet(isPresented: $showingURL) {
                    url
                        .frame(width: 350)
                        .onDisappear() {
                            if urlEntered == 1 {
                            audioURL = URL(string: urlText)
                            } else {
                                print("No URL Entered")
                            }
                            urlEntered = 0
                        }
                }
            }
        }
    }
    var url: some View {
        VStack {
            HStack {
                Spacer()
                Text("Enter URL: ")
                Spacer()
                TextField("URL...", text: $urlText)
                Spacer()
            }
            .padding()
            HStack {
            Button(action: {self.showingURL = false}) {
                Text("Cancel")
            }
                Button(action: {self.showingURL = false
                    urlEntered = 1}) {
                    Text("Done")
                }
        }
            .padding()
        }
    }
}

struct Audio_Previews: PreviewProvider {
    static var previews: some View {
        Audio()
    }
}
