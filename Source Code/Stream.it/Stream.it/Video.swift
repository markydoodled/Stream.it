//
//  Video.swift
//  Stream.it
//
//  Created by Mark Howard on 26/09/2021.
//

import SwiftUI
import AVKit
import AVFoundation

struct Video: View {
    @State var vidURL = URL(string: "/")
    @State var showingURL = false
    @State var urlText = ""
    @State var urlEntered = 0
    var body: some View {
        let play = AVPlayer(url: (vidURL ?? URL(string: "/"))!)
        Form {
            AVPlayerViewControl(videoURL: $vidURL, player: play)
        }
            .navigationTitle("Video")
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
                            vidURL = URL(string: urlText)
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

struct Video_Previews: PreviewProvider {
    static var previews: some View {
        Video()
    }
}

struct AVPlayerViewControl: NSViewRepresentable {

    @Binding var videoURL: URL?
    var player: AVPlayer

    func makeNSView(context: Context) -> AVPlayerView {
        return AVPlayerView()
    }
    
    func updateNSView(_ playerController: AVPlayerView, context: Context) {
        playerController.player = player
        player.automaticallyWaitsToMinimizeStalling = true
        playerController.showsFullScreenToggleButton = true
        playerController.showsSharingServiceButton = true
        playerController.showsFrameSteppingButtons = true
        playerController.updatesNowPlayingInfoCenter = true
        //playerController.player?.play()
    }
}
