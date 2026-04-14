//
//  TodoDetailSheet.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftUI

struct TodoDetailSheet: View {
    @Environment(\.dismiss) private var dismiss

    let item: TodoItem

    private var formattedDueDate: String {
        item.dueDate.formatted(date: .abbreviated, time: .omitted)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    Text(item.title)

                    Label(
                        item.isCompleted ? "Completed" : "Not completed",
                        systemImage: item.isCompleted ? "checkmark.circle.fill" : "circle"
                    )
                }

                Section("Description") {
                    if item.details.isEmpty {
                        Text("No description")
                            .foregroundStyle(.secondary)
                    } else {
                        Text(item.details)
                    }
                }

                Section("Date") {
                    Text(formattedDueDate)
                }
            }
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TodoDetailSheet(
        item: TodoItem(
            title: "Review SwiftUI architecture",
            details: "Keep the view structure simple and native.",
            dueDate: .now,
            isCompleted: true
        )
    )
}
