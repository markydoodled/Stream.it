//
//  Audio.swift
//  Stream.it
//
//  Created by Mark Howard on 19/06/2021.
//

import SwiftUI
import AVFoundation
import AVKit

struct Audio: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var showingPlayer = false
    @State var showingFileImported = false
    @State var disabledDone = true
    @State var vidURL = URL(string: "/")
    @State var urlText = "Enter URL..."
    @State var activeSheet: ActiveSheet?
    @State var titleAttribute = "None"
    @State var durationAttribute = Double()
    @State var extensionAttribute = "None"
    @State var sizeAttribute = "None"
    @State var fileURL: URL
    var body: some View {
        if horizontalSizeClass == .compact {
            NavigationView {
            audioCompact
        }
        } else {
            audioRegular
        }
    }
    private var mainView: some View {
        Form {
            Section(header: Label("Metadata", systemImage: "info.circle")) {
                Group {
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
                    Button(action: {activeSheet = .files
                        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    }) {
                        Label("Play", systemImage: "play.fill")
                    }
                }
    }
        }
    }
    private var audioRegular: some View {
        mainView
            .navigationTitle("Audio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {activeSheet = .url}) {
                        Image(systemName: "curlybraces")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {self.showingFileImported = true}) {
                        Image(systemName: "folder")
                    }
                }
            }
            .fileImporter(
                isPresented: $showingFileImported,
                allowedContentTypes: [.audio, .mp3, .mpeg4Audio, .appleProtectedMPEG4Audio, .aiff, .wav, .midi],
                allowsMultipleSelection: false
            ) { result in
                do {
                    let fileUrl = try result.get().first!
                    print(fileUrl)
                                
                        guard fileUrl.startAccessingSecurityScopedResource() else { return }
                    fileURL = fileUrl
                    vidURL = fileUrl
                    getAttributes()
                        fileUrl.stopAccessingSecurityScopedResource()
                                
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
            }
        
    }
    private var audioCompact: some View {
                    mainView
                .navigationTitle("Audio")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {activeSheet = .url}) {
                            Image(systemName: "curlybraces")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {self.showingFileImported = true}) {
                            Image(systemName: "folder")
                        }
                    }
                }
                .fileImporter(
                    isPresented: $showingFileImported,
                    allowedContentTypes: [.audio, .mp3, .mpeg4Audio, .appleProtectedMPEG4Audio, .aiff, .wav, .midi],
                    allowsMultipleSelection: false
                ) { result in
                    do {
                        let fileUrl = try result.get().first!
                        print(fileUrl)
                                    
                            guard fileUrl.startAccessingSecurityScopedResource() else { return }
                        fileURL = fileUrl
                        vidURL = fileUrl
                        getAttributes()
                            fileUrl.stopAccessingSecurityScopedResource()
                                    
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                }
                .fullScreenCover(item: $activeSheet) { item in
                    switch item {
                    case .url:
                        NavigationView {
                            VStack {
                            Text("Please Enter The URL Of The Audio You Wish To Stream.")
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
                                        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                                    }) {
                                        Text("Done")
                                    }
                                    .disabled(disabledDone)
                                }
                            }
                    }
                    .fullScreenCover(isPresented: $showingPlayer) {
                        NavigationView {
                        VStack {
                            Spacer()
                            Text("\(urlText)")
                                .bold()
                                .font(.title3)
                            HStack {
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "gobackward.15")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                                Spacer()
                                Button(action: {do {
                                    try AVAudioSession.sharedInstance().setActive(true)
                                    let player = try AVAudioPlayer(contentsOf: vidURL!)
                                    player.play()
                                } catch let error {
                                    print(error)
                                }
                                }) {
                                    Image(systemName: "play.fill")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "stop.fill")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "goforward.15")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                                Spacer()
                            }
                            .padding()
                            Spacer()
                        }
                        .navigationTitle("Player")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {self.showingPlayer = false}) {
                                    Text("Done")
                                }
                            }
                        }
                    }
                    }
                    case .files:
                        NavigationView {
                        VStack {
                            Spacer()
                            Text("\(vidURL!.path)")
                                .bold()
                                .font(.title3)
                            HStack {
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "gobackward.15")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                                Spacer()
                                Button(action: {do {
                                    try AVAudioSession.sharedInstance().setActive(true)
                                    let player = try AVAudioPlayer(contentsOf: vidURL!)
                                    player.play()
                                } catch let error {
                                    print(error)
                                }
                                }) {
                                    Image(systemName: "play.fill")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "stop.fill")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "goforward.15")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                                Spacer()
                            }
                            .padding()
                            Spacer()
                        }
                        .navigationTitle("Player")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {activeSheet = nil}) {
                                    Text("Done")
                                }
                            }
                        }
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
}

struct Audio_Previews: PreviewProvider {
    static var previews: some View {
        Audio(fileURL: URL(string: "/")!)
    }
}
