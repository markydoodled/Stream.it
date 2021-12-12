//
//  SettingsView.swift
//  Stream.it
//
//  Created by Mark Howard on 26/09/2021.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
           GroupBox(label: Label("Info", systemImage: "info.circle")) {
               VStack {
                   HStack {
                       Spacer()
                       VStack {
           Text("Version: 1.1.1")
           Text("Build: 2")
                       }
                       Spacer()
                   }
               }
           }
           GroupBox(label: Label("Misc.", systemImage: "ellipsis.circle")) {
               VStack {
                   HStack {
                       Spacer()
                   Button(action: {SendEmail.send()}) {
                       Text("Send Some Feedback")
                   }
                       Spacer()
                   }
               }
           }
       }
        .padding(20)
        .frame(width: 350, height: 150)
}
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

class SendEmail: NSObject {
    static func send() {
        let service = NSSharingService(named: NSSharingService.Name.composeEmail)!
        service.recipients = ["markhoward2005@gmail.com"]
        service.subject = "Stream.it Feedback"

        service.perform(withItems: ["Please Fill Out All Necessary Sections:", "Report A Bug - ", "Rate The App - ", "Suggest An Improvment - "])
    }
}
