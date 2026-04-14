//
//  TodoRowDetailsButton.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftUI

struct TodoRowDetailsButton: View {
    let item: TodoItem
    let action: () -> Void

    private var formattedDueDate: String {
        item.dueDate.formatted(date: .abbreviated, time: .omitted)
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier("todo-title-\(item.title)")

                Text(formattedDueDate)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !item.details.isEmpty {
                    Text(item.details)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
        .accessibilityLabel("Show details for \(item.title)")
        .accessibilityIdentifier("todo-row-\(item.title)")
    }
}
