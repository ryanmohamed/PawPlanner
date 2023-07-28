//
//  PawPlannerApp.swift
//  PawPlanner
//
//  Created by ryan on 7/27/23.
//

import SwiftUI
import CoreData

@main
struct PawPlannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.candyRed, Color.pink]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all))
        }
    }
}

extension Color {
    static let candyRed = Color(red: 1.00, green: 0.29, blue: 0.35)
}
