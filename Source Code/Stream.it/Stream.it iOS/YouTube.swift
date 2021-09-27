//
//  YouTube.swift
//  Stream.it iOS
//
//  Created by Mark Howard on 26/09/2021.
//

import SwiftUI
import UIKit
import Combine
import YouTubePlayer

struct YouTube: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var playerState: YouTubeControlState
    @State var showingURL = false
    @State var urlText = ""
    @State var urlEntered = 0
    var body: some View {
        if horizontalSizeClass == .compact {
            NavigationView {
                YouTubeView(playerState: playerState)
                    .navigationTitle("YouTube")
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
                                            playerState.videoID = urlText
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
         YouTubeView(playerState: playerState)
            .navigationTitle("YouTube")
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
                                    playerState.videoID = urlText
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
            Text("Enter ID: ")
            Spacer()
        TextField("ID...", text: $urlText)
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
        .navigationTitle("YouTube ID")
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

struct YouTube_Previews: PreviewProvider {
    static var previews: some View {
        YouTube()
    }
}

enum playerSizeState {
    case hidden
    case inline
    case miniplayer
    case fullscreen
}

enum playerCommandToExecute {
    case loadNewVideo
    case play
    case pause
    case forward
    case backward
    case stop
    case idle
}

class YouTubeControlState: ObservableObject {
    
    private var previousPlayerSize: playerSizeState = .inline
    @Published var videoState: playerCommandToExecute = .loadNewVideo
    
    @Published var videoID: String?
    {
        didSet {
            self.executeCommand = .loadNewVideo
        }
    }
    
    @Published var playerSize: playerSizeState = .inline
    
    @Published var minimiseAlignment: Alignment = .topLeading
    
    @Published var executeCommand: playerCommandToExecute = .idle
    
    
    func showVideo() {
        minimiseAlignment = .topLeading
        playerSize = .inline
    }
    
    func hideVideo() {
        playerSize = .hidden
    }
    
    func fullScreenButtonTapped() {
        if playerSize == .fullscreen {
            exitFullScreen()
        } else {
            makeFullScreen()
        }
    }
    
    func makeFullScreen() {
        previousPlayerSize = playerSize
        playerSize = .fullscreen
    }
    
    func exitFullScreen() {
        playerSize = previousPlayerSize
    }
    
    func makeMiniPlayer() {
        minimiseAlignment = .bottomTrailing
        playerSize = .miniplayer
    }
    
    func playPauseButtonTapped() {
        if videoState == .play {
            pauseVideo()
        } else if videoState == .pause {
            playVideo()
        } else {
            print("Unknown player state, attempting playing")
            playVideo()
        }
    }
    
    func playVideo() {
        executeCommand = .play
    }
    
    func pauseVideo() {
        executeCommand = .pause
    }
    
    func forwardDoubleTapped() {
        executeCommand = .forward
    }
    
    func backwardDoubleTapped() {
        executeCommand = .backward
    }
}

struct YouTubeView: UIViewRepresentable {
    
    typealias UIViewType = YouTubePlayerView
    
    @ObservedObject var playerState: YouTubeControlState
    
    init(playerState: YouTubeControlState) {
        self.playerState = playerState
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(playerState: playerState)
    }
                
    func makeUIView(context: Context) -> UIViewType {
        let playerVars = [
            "controls": "1",
            "playsinline": "0",
            "autohide": "0",
            "autoplay": "0",
            "fs": "1",
            "rel": "0",
            "loop": "0",
            "enablejsapi": "1",
            "modestbranding": "1"
        ]
        
        let ytVideo = YouTubePlayerView()
        
        ytVideo.playerVars = playerVars as YouTubePlayerView.YouTubePlayerParameters
        ytVideo.delegate = context.coordinator
        
        return ytVideo
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        guard let videoID = playerState.videoID else { return }
        
        if !(playerState.executeCommand == .idle) && uiView.ready {
            switch playerState.executeCommand {
            case .loadNewVideo:
                playerState.executeCommand = .idle
                uiView.loadVideoID(videoID)
            case .play:
                playerState.executeCommand = .idle
                uiView.play()
            case .pause:
                playerState.executeCommand = .idle
                uiView.pause()
            case .forward:
                playerState.executeCommand = .idle
                uiView.getCurrentTime { (time) in
                    guard let time = time else {return}
                    uiView.seekTo(Float(time) + 10, seekAhead: true)
                }
            case .backward:
                playerState.executeCommand = .idle
                uiView.getCurrentTime { (time) in
                    guard let time = time else {return}
                    uiView.seekTo(Float(time) - 10, seekAhead: true)
                }
            default:
                playerState.executeCommand = .idle
                print("\(playerState.executeCommand) not yet implemented")
            }
        } else if !uiView.ready {
            uiView.loadVideoID(videoID)
        }
        
    }
    
    class Coordinator: YouTubePlayerDelegate {
        @ObservedObject var playerState: YouTubeControlState
        
        init(playerState: YouTubeControlState) {
            self.playerState = playerState
        }
        
        func playerReady(_ videoPlayer: YouTubePlayerView) {
            videoPlayer.play()
            playerState.videoState = .play
        }
        
        func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
            
            switch playerState {
            case .Playing:
                self.playerState.videoState = .play
            case .Paused, .Ended, .Buffering, .Unstarted:
                self.playerState.videoState = .pause
            default:
                print("\(playerState) not implemented")
            }
            

        }
    }

}

