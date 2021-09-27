//
//  Video.swift
//  Stream.it iOS
//
//  Created by Mark Howard on 26/09/2021.
//

import SwiftUI
import AVKit

struct Video: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var vidURL = URL(string: "/")
    @State var showingURL = false
    @State var urlText = ""
    @State var urlEntered = 0
    var body: some View {
        let play = AVPlayer(url: (vidURL ?? URL(string: "/"))!)
        if horizontalSizeClass == .compact {
            NavigationView {
                AVPlayerVieww(videoURL: $vidURL, player: play)
                    .onDisappear() {
                        play.pause()
                    }
                    .navigationTitle("Video")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {self.showingURL = true}) {
                                Image(systemName: "curlybraces")
                            }
                            .sheet(isPresented: $showingURL) {
                                url
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
        } else {
            AVPlayerVieww(videoURL: $vidURL, player: play)
                .onDisappear() {
                    play.pause()
                }
                .navigationTitle("Video")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {self.showingURL = true}) {
                            Image(systemName: "curlybraces")
                        }
                        .sheet(isPresented: $showingURL) {
                            url
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
    }
    var url: some View {
        NavigationView {
            ScrollView {
            VStack {
            GroupBox {
        HStack {
            Spacer()
            Text("Enter URL: ")
            Spacer()
        TextField("URL...", text: $urlText)
            Spacer()
    }
        .padding()
        }
            .padding()
                Button(action: {UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)}) {
                    Label("Dismiss Keyboard", systemImage: "keyboard.chevron.compact.down")
                        .foregroundColor(.white)
                        .padding()
                }
                .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)).foregroundColor(.accentColor))
                .padding()
        }
        .navigationTitle("URL")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {self.showingURL = false}) {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {self.showingURL = false
                    urlEntered = 1
                }) {
                    Text("Done")
                }
            }
        }
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
        playerController.updatesNowPlayingInfoCenter = true
        playerController.allowsPictureInPicturePlayback = true
        playerController.canStartPictureInPictureAutomaticallyFromInline = true
        playerController.player = player
        //playerController.player?.play()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}
