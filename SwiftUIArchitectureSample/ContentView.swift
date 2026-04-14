//
//  ContentView.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TodoListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
