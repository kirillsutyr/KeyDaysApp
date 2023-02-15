//
//  KeyDaysApp.swift
//  KeyDays
//
//  Created by Кирилл Сутырь on 15.02.2023.
//

import SwiftUI

@main
struct KeyDaysApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
