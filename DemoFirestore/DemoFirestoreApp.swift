//
//  DemoFirestoreApp.swift
//  DemoFirestore
//
//  Created by Kemal Ekren on 12.12.2021.
//

import SwiftUI
import Firebase

@main
struct DemoFirestoreApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
