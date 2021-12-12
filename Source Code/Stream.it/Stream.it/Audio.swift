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
    @State var showingDownload = false
    @State var downloadURLText = ""
    @State var downloadURLEntered = 0
    @State var downloadURL = URL(string: "/")
    @State var isDownloading = false
    @State var isDownloaded = false
    @State var showDownloadAlert = false
    var body: some View {
        let play = AVPlayer(url: (audioURL ?? URL(string: "/"))!)
        Form {
        AVPlayerViewControl(videoURL: $audioURL, player: play)
        }
        .alert(isPresented: $showDownloadAlert) {
            Alert(title: Text("Downloading..."), message: Text("Download has started. It's OK to dismiss this message."), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Audio")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {self.showingURL = true}) {
                    Image(systemName: "curlybraces")
                }
                .help("Enter Stream URL")
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
            ToolbarItem(placement: .automatic) {
                Button(action: {self.showingDownload = true}) {
                    Image(systemName: "arrow.down.circle")
                }
                .help("Enter Download URL")
                .sheet(isPresented: $showingDownload) {
                    download
                        .frame(width: 350)
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
    func downloadFile() {
        print("downloadFile")
        isDownloading = true

        let docsUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("AudioFile.mp3")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                print("File already exists")
                isDownloading = false
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
    var download: some View {
        VStack {
            HStack {
                Spacer()
                Text("Enter Download URL: ")
                Spacer()
                TextField("URL...", text: $downloadURLText)
                Spacer()
            }
            .padding()
            HStack {
            Button(action: {self.showingDownload = false}) {
                Text("Cancel")
            }
                Button(action: {self.showingDownload = false
                    downloadURLEntered = 1}) {
                    Text("Done")
                }
        }
            .padding()
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
