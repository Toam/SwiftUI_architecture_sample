//
//  TodoListView.swift
//  SwiftUIArchitectureSample
//
//  Created by Thomas Brelet on 14/04/2026.
//

import SwiftData
import SwiftUI

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.createdAt, order: .forward) private var todoItems: [TodoItem]

    @State private var searchText = ""
    @State private var isAddTaskPresented = false
    @State private var selectedItem: TodoItem?
    @State private var selectionFeedbackTrigger = 0

    private var filteredTodoItems: [TodoItem] {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearchText.isEmpty else {
            return todoItems
        }

        return todoItems.filter { item in
            item.title.localizedStandardContains(trimmedSearchText)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                TodoListContent(
                    todoItems: filteredTodoItems,
                    searchText: searchText,
                    toggleCompletion: toggleCompletion,
                    delete: delete,
                    showDetails: showDetails
                )

                FloatingAddTaskButton {
                    isAddTaskPresented = true
                }
            }
            .navigationTitle("Tasks")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search tasks"
            )
            .sheet(isPresented: $isAddTaskPresented) {
                AddTaskSheet()
            }
            .sheet(item: $selectedItem) { item in
                TodoDetailSheet(item: item)
            }
            .task {
                try? TodoItemActions.seedDefaultTasksIfNeeded(in: modelContext)
            }
            .sensoryFeedback(.selection, trigger: selectionFeedbackTrigger)
        }
    }

    private func toggleCompletion(for item: TodoItem) {
        withAnimation {
            TodoItemActions.toggleCompletion(for: item)
            selectionFeedbackTrigger += 1
        }
    }

    private func delete(_ item: TodoItem) {
        withAnimation {
            TodoItemActions.delete(item, from: modelContext)
        }
    }

    private func showDetails(for item: TodoItem) {
        selectionFeedbackTrigger += 1
        selectedItem = item
    }
}

#Preview {
    TodoListView()
        .modelContainer(TodoListPreviewData.modelContainer)
}

private enum TodoListPreviewData {
    @MainActor
    static let modelContainer: ModelContainer = {
        let schema = Schema([TodoItem.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])

        container.mainContext.insert(TodoItem(
            title: "Review SwiftUI architecture",
            details: "Keep the view structure simple and native."
        ))
        container.mainContext.insert(TodoItem(
            title: "Add SwiftData persistence",
            details: "Use SwiftData directly from SwiftUI views.",
            isCompleted: true
        ))
        container.mainContext.insert(TodoItem(
            title: "Write Swift Testing coverage",
            details: "Cover task creation, completion, and deletion."
        ))

        return container
    }()
}
