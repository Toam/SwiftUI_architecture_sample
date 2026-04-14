//
//  SwiftUIArchitectureSampleApp.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftUI
import SwiftData

@main
struct SwiftUIArchitectureSampleApp: App {
    private var isUITesting: Bool {
        CommandLine.arguments.contains("-ui-testing")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TodoItem.self, inMemory: isUITesting)
    }
}
