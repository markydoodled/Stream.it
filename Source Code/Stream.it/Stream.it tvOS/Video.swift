//
//  Video.swift
//  Stream.it tvOS
//
//  Created by Mark Howard on 27/09/2021.
//

import SwiftUI
import AVKit
import AVFoundation

struct Video: View {
    @State var vidURL = URL(string: "/")
    @State var urlText = ""
    @State var show = false
    var body: some View {
        let play = AVPlayer(url: (vidURL ?? URL(string: "/"))!)
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Enter URL: ")
                Spacer()
            TextField("URL...", text: $urlText)
                Spacer()
        }
            .padding()
            Button(action: {vidURL = URL(string: urlText)
                self.show = true
            }) {
                Text("Done")
            }
            Spacer()
        }
            .sheet(isPresented: $show) {
                AVPlayerVieww(videoURL: $vidURL, player: play)
                    .edgesIgnoringSafeArea(.all)
                    .onDisappear() {
                        play.pause()
                    }
            }
    }
}

struct Video_Previews: PreviewProvider {
    static var previews: some View {
        Video()
    }
}


struct AVPlayerVieww: UIViewControllerRepresentable {

    @Binding var videoURL: URL?
    var player: AVPlayer
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.modalPresentationStyle = .fullScreen
        playerController.allowsPictureInPicturePlayback = true
        playerController.player = player
        playerController.player?.play()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}
