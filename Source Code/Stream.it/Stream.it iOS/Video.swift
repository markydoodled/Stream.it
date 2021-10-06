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
    @State var showingDownload = false
    @State var downloadURLText = ""
    @State var downloadURLEntered = 0
    @State var downloadURL = URL(string: "/")
    @State var isDownloading = false
    @State var isDownloaded = false
    @State var showDownloadAlert = false
    var body: some View {
        let play = AVPlayer(url: (vidURL ?? URL(string: "/"))!)
        if horizontalSizeClass == .compact {
            NavigationView {
                AVPlayerVieww(videoURL: $vidURL, player: play)
                    .onDisappear() {
                        play.pause()
                    }
                    .alert(isPresented: $showDownloadAlert) {
                        Alert(title: Text("Downloading..."), message: Text("Download has started. It's OK to dismiss this message."), dismissButton: .default(Text("OK")))
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
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {self.showingDownload = true}) {
                                Image(systemName: "arrow.down.circle")
                            }
                            .sheet(isPresented: $showingDownload) {
                                download
                                    .onDisappear() {
                                        if downloadURLEntered == 1 {
                                            downloadURL = URL(string: downloadURLText)
                                            self.showDownloadAlert = true
                                            if showDownloadAlert == true {
                                            downloadFile()
                                            }
                                        } else {
                                            print("No URL Entered")
                                        }
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
                .alert(isPresented: $showDownloadAlert) {
                    Alert(title: Text("Downloading..."), message: Text("Download has started. It's OK to dismiss this message."), dismissButton: .default(Text("OK")))
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
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {self.showingDownload = true}) {
                            Image(systemName: "arrow.down.circle")
                        }
                        .sheet(isPresented: $showingDownload) {
                            download
                                .onDisappear() {
                                    if downloadURLEntered == 1 {
                                        downloadURL = URL(string: downloadURLText)
                                        self.showDownloadAlert = true
                                        if showDownloadAlert == true {
                                        downloadFile()
                                        }
                                    } else {
                                        print("No URL Entered")
                                    }
                                }
                        }
                    }
                }
        }
    }
    func downloadFile() {
        print("downloadFile")
        isDownloading = true

        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("VideoFile.mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                print("File already exists")
                isDownloading = false
                self.showDownloadAlert = false
                deleteFile()
                downloadFile()
                self.showDownloadAlert = true
            } else {
                let urlRequest = URLRequest(url: downloadURL!)

                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

                    if let error = error {
                        print("Request error: ", error)
                        self.isDownloading = false
                        return
                    }

                    guard let response = response as? HTTPURLResponse else { return }

                    if response.statusCode == 200 {
                        guard let data = data else {
                            self.isDownloading = false
                            return
                        }
                        DispatchQueue.main.async {
                            do {
                                try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)

                                DispatchQueue.main.async {
                                    self.isDownloading = false
                                    self.isDownloaded = true
                                    self.showDownloadAlert = false
                                }
                            } catch let error {
                                print("Error decoding: ", error)
                                self.isDownloading = false
                            }
                        }
                    }
                }
                dataTask.resume()
            }
        }
    }
    func deleteFile() {
            let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

            let destinationUrl = docsUrl?.appendingPathComponent("VideoFile.mp4")
            if let destinationUrl = destinationUrl {
                guard FileManager().fileExists(atPath: destinationUrl.path) else { return }
                do {
                    try FileManager().removeItem(atPath: destinationUrl.path)
                    print("File deleted successfully")
                    isDownloaded = false
                } catch let error {
                    print("Error while deleting video file: ", error)
                }
            }
        }
    var download: some View {
        NavigationView {
            ScrollView {
            VStack {
            GroupBox {
        HStack {
            Spacer()
            Text("Enter Download URL: ")
            Spacer()
        TextField("URL...", text: $downloadURLText)
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
        .navigationTitle("Download URL")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {self.showingDownload = false}) {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {self.showingDownload = false
                    downloadURLEntered = 1
                }) {
                    Text("Done")
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
