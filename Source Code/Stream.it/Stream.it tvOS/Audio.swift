//
//  Audio.swift
//  Stream.it tvOS
//
//  Created by Mark Howard on 27/09/2021.
//

import SwiftUI
import AVKit
import AVFoundation

struct Audio: View {
    @State var audioURL = URL(string: "/")
    @State var urlText = ""
    @State var show = false
    var body: some View {
        let play = AVPlayer(url: (audioURL ?? URL(string: "/"))!)
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
            Button(action: {audioURL = URL(string: urlText)
                self.show = true
            }) {
                Text("Done")
            }
            Spacer()
        }
            .sheet(isPresented: $show) {
                AVPlayerVieww(videoURL: $audioURL, player: play)
                    .edgesIgnoringSafeArea(.all)
                    .onDisappear() {
                        play.pause()
                    }
            }
    }
}

struct Audio_Previews: PreviewProvider {
    static var previews: some View {
        Audio()
    }
}
