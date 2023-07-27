//
//  petminderApp.swift
//  petminder
//
//  Created by ryan on 7/25/23.
//

import SwiftUI

@main
struct PawPlannerApp: App {
    let persistenceController = PersistenceController.shared

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Gradient background
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.pink]),
                               startPoint: .top,
                               endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .accentColor(Color.candyRed)
            }
        }
    }
}

extension Color {
    static let candyRed = Color(red: 1.00, green: 0.29, blue: 0.35)
}
