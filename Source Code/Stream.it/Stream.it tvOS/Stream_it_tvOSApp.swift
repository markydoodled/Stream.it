//
//  Stream_it_tvOSApp.swift
//  Stream.it tvOS
//
//  Created by Mark Howard on 27/09/2021.
//

import SwiftUI
import AVFAudio

@main
struct Stream_it_tvOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let audioSession = AVAudioSession.sharedInstance()
         do {
             try audioSession.setCategory(.playback, mode: .moviePlayback, options: [.allowAirPlay])
         } catch {
             print("Setting category to AVAudioSessionCategoryPlayback failed.")
         }

        return true
    }
}
