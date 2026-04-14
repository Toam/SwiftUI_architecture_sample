//
//  FloatingAddTaskButton.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftUI

struct FloatingAddTaskButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("Add Task", systemImage: "plus")
                .font(.system(size: 28, weight: .bold))
                .labelStyle(.iconOnly)
                .frame(width: 56, height: 56)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.circle)
        .padding(24)
        .accessibilityHint("Opens the add task form")
        .accessibilityIdentifier("add-task-button")
    }
}
