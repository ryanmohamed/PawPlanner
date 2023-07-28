//
//  ContentView.swift
//  PawPlanner
//
//  Created by ryan on 7/27/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            
            TaskListView()
                .tabItem {
                    Image(systemName: "tornado")
                    Text("Tasks")
                        .font(.custom("Poppins", size: 14))
                }
                .tag(0)

            PetListView()
                .tabItem {
                    Image(systemName: "pawprint.circle.fill")
                    Text("Pets")
                        .font(.custom("Poppins", size: 14))
                }
                .tag(1)
        }
        .accentColor(Color.candyRed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
