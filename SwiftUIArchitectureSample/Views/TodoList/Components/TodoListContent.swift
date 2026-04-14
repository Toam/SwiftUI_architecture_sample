//
//  TodoListContent.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftUI

struct TodoListContent: View {
    let todoItems: [TodoItem]
    let searchText: String
    let toggleCompletion: (TodoItem) -> Void
    let delete: (TodoItem) -> Void
    let showDetails: (TodoItem) -> Void

    var body: some View {
        List {
            ForEach(todoItems) { item in
                TodoRow(item: item) {
                    toggleCompletion(item)
                } delete: {
                    delete(item)
                } showDetails: {
                    showDetails(item)
                }
            }
        }
        .overlay {
            if todoItems.isEmpty {
                emptyState
            }
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        if searchText.isEmpty {
            ContentUnavailableView(
                "No Tasks",
                systemImage: "checklist",
                description: Text("Add your first task to get started.")
            )
        } else {
            ContentUnavailableView.search(text: searchText)
        }
    }
}
