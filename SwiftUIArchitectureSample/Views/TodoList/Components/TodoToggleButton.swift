//
//  TodoToggleButton.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftUI

struct TodoToggleButton: View {
    let item: TodoItem
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title3)
                .symbolRenderingMode(.hierarchical)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(item.isCompleted ? "Mark \(item.title) as not completed" : "Mark \(item.title) as completed")
        .accessibilityValue(item.isCompleted ? "Completed" : "Not completed")
        .accessibilityIdentifier("todo-toggle-\(item.title)")
    }
}
