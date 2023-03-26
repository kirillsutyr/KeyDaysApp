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
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext	, persistenceController.container.viewContext)
                		
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                print("Scene is background")
                persistenceController.save()
            case .inactive:
                print("Scene is inactive")
            case .active:
                print("Scene is active")
            @unknown default:
                print("Apple chandeg something")
            }
        }
    }
}
