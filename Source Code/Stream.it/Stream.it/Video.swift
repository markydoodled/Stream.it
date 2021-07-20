//
//  Video.swift
//  Stream.it
//
//  Created by Mark Howard on 19/06/2021.
//

import SwiftUI
import AVFoundation
import AVKit

struct Video: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var showingPlayer = false
    @State var showingFileImported = false
    @State var disabledDone = true
    @State var vidURL = URL(string: "/")
    @State var vidURL2 = URL(string: "/")
    @State var urlText = "Enter URL..."
    @State var activeSheet: ActiveSheet?
    @State var titleAttribute = "None"
    @State var durationAttribute = Double()
    @State var extensionAttribute = "None"
    @State var sizeAttribute = "None"
    @State var thumbnailImage = UIImage(named: "None")
    @State var fileURL: URL
    var body: some View {
        if horizontalSizeClass == .compact {
        NavigationView {
            videoCompact
        }
        } else {
            videoRegular
        }
        }
    private var urlFullScreenSheet: some View {
        NavigationView {
            VStack {
            Text("Please Enter The URL Of The Video You Wish To Stream.")
                .bold()
                .font(.title3)
                .padding(.horizontal)
        TextField("Enter A URL...", text: $urlText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: urlText) { newValue in
                if urlText == "" {
                    disabledDone = true
                } else {
                    disabledDone = false
                }
            }
            .padding()
                Button(action: {hideKeyboard()}) {
                    HStack {
                        Spacer()
                    Text("Hide Keyboard")
                        .foregroundColor(.white)
                        Spacer()
                }
                        .padding()
                }
                .background(Color.accentColor.cornerRadius(10))
                .padding()
            }
            .padding(.vertical)
            .navigationTitle("Enter A URL")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {activeSheet = nil}) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {self.showingPlayer = true
                        vidURL = URL(string: "\(urlText)")
                    }) {
                        Text("Done")
                    }
                    .disabled(disabledDone)
                }
            }
    }
    .fullScreenCover(isPresented: $showingPlayer) {
            AVPlayerView(videoURL: self.$vidURL)
                .transition(.move(edge: .bottom))
                .edgesIgnoringSafeArea(.all)
    }
    }
    private var info: some View {
        Form {
            Section(header: Label("Metadata - Press Thumbnail To Play Local Files", systemImage: "info.circle")) {
                Group {
                HStack {
                    Spacer()
                    Image(uiImage: thumbnailImage!)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(width: 250, height: 150)
                        .onTapGesture {
                            activeSheet = .files
                        }
                    Spacer()
                }
                HStack {
            Text("Title")
                    Spacer()
                    Text("\(titleAttribute)")
                }
                HStack {
            Text("Duration")
                    Spacer()
                    Text("\(durationAttribute) Seconds")
                }
                HStack {
            Text("Extension")
                    Spacer()
                    Text("\(extensionAttribute)")
                }
                HStack {
                    Text("Size")
                    Spacer()
                    Text("\(sizeAttribute)")
                }
                }
    }
        }
    }
    private var videoCompact: some View {
        info
            .navigationTitle("Video")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {self.showingFileImported = true}) {
                    Image(systemName: "folder")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {activeSheet = .url}) {
                    Image(systemName: "curlybraces")
                }
            }
        }
            .fileImporter(
                isPresented: $showingFileImported,
                allowedContentTypes: [.appleProtectedMPEG4Video, .movie, .mpeg, .mpeg2TransportStream, .mpeg2Video, .mpeg4Movie, .quickTimeMovie, .video],
                allowsMultipleSelection: false
            ) { result in
                do {
                    let fileUrl = try result.get().first!
                    print(fileUrl)
                                
                        guard fileUrl.startAccessingSecurityScopedResource() else { return }
                    fileURL = fileUrl
                    let vidData = try Data(contentsOf: fileUrl)
                    let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    print("tt: \(urlPath)")
                    do {
                        try vidData.write(to: urlPath!)
                        print("Test: \(urlPath)")
                    } catch {
                        print(error)
                    }
                    vidURL2 = fileUrl
                    getAttributes()
                    generateThumbnail(path: fileURL)
                        fileUrl.stopAccessingSecurityScopedResource()
                                
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
            }
            .fullScreenCover(item: $activeSheet) { item in
        switch item {
        case .url:
                urlFullScreenSheet
        case .files:
            AVPlayerView(videoURL: self.$vidURL2)
                .transition(.move(edge: .bottom))
                .edgesIgnoringSafeArea(.all)
            }
            }
    }
    private var videoRegular: some View {
        info
        .navigationTitle("Video")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {self.showingFileImported = true}) {
                    Image(systemName: "folder")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {activeSheet = .url}) {
                    Image(systemName: "curlybraces")
                }
            }
        }
        .fileImporter(
            isPresented: $showingFileImported,
            allowedContentTypes: [.appleProtectedMPEG4Video, .movie, .mpeg, .mpeg2TransportStream, .mpeg2Video, .mpeg4Movie, .quickTimeMovie, .video],
            allowsMultipleSelection: false
        ) { result in
            do {
                let fileUrl = try result.get().first!
                print(fileUrl)
                            
                    guard fileUrl.startAccessingSecurityScopedResource() else { return }
                fileURL = fileUrl
                vidURL2 = fileUrl
                getAttributes()
                generateThumbnail(path: fileURL)
                    fileUrl.stopAccessingSecurityScopedResource()
                            
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
        }
        .fullScreenCover(item: $activeSheet) { item in
    switch item {
    case .url:
        urlFullScreenSheet
    case .files:
        AVPlayerView(videoURL: self.$vidURL2)
            .transition(.move(edge: .bottom))
            .edgesIgnoringSafeArea(.all)
            .onDisappear() {
                print("gone")
            }
        }
        }
    }
    func getAttributes() {
            let fileextension = fileURL.pathExtension
            let fileName = fileURL.lastPathComponent
        let fileSizeString = fileURL.fileSizeString
            titleAttribute = fileName
            extensionAttribute = fileextension
            sizeAttribute = fileSizeString
        }
    @discardableResult func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let duration = asset.duration
            durationAttribute = duration.seconds
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            thumbnailImage = thumbnail
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    }


struct Video_Previews: PreviewProvider {
    static var previews: some View {
        Video(fileURL: URL(string: "/")!)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AVPlayerView: UIViewControllerRepresentable {

    @Binding var videoURL: URL?

    private var player: AVPlayer {
        return AVPlayer(url: videoURL!)
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.modalPresentationStyle = .fullScreen
        playerController.player = player
        playerController.player?.play()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}

enum ActiveSheet: Identifiable {
    case url, files
    
    var id: Int {
        hashValue
    }
}

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
}
