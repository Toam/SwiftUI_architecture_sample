//
//  SwiftUIArchitectureSampleTests.swift
//  SwiftUIArchitectureSampleTests
//
//  Created by Thomas Brelet on 14/04/2026.
//

import Foundation
import SwiftData
import Testing
@testable import SwiftUIArchitectureSample

@Suite(.serialized)
struct SwiftUIArchitectureSampleTests {

    @Test func todoItemUsesExpectedDefaultValues() {
        let item = TodoItem(title: "Write the first version")

        #expect(item.title == "Write the first version")
        #expect(item.details.isEmpty)
        #expect(item.isCompleted == false)
    }

    @MainActor
    @Test func createTaskTrimsTitleAndInsertsIt() throws {
        let container = try makeModelContainer()
        let context = container.mainContext
        let dueDate = Date(timeIntervalSince1970: 1_800_000_000)

        let item = try #require(TodoItemActions.createTask(
            title: "  Buy milk  ",
            details: "  Organic milk  ",
            dueDate: dueDate,
            in: context
        ))
        let items = try fetchTodoItems(in: context)

        #expect(item.title == "Buy milk")
        #expect(item.details == "Organic milk")
        #expect(item.dueDate == dueDate)
        #expect(items.map(\.title) == ["Buy milk"])
    }

    @MainActor
    @Test func createTaskIgnoresEmptyTitles() throws {
        let container = try makeModelContainer()
        let context = container.mainContext

        let item = TodoItemActions.createTask(title: "   ", in: context)
        let items = try fetchTodoItems(in: context)

        #expect(item == nil)
        #expect(items.isEmpty)
    }

    @Test func toggleCompletionUpdatesTaskState() {
        let item = TodoItem(title: "Finish the demo")

        TodoItemActions.toggleCompletion(for: item)

        #expect(item.isCompleted)
    }

    @MainActor
    @Test func deleteTaskRemovesItFromPersistence() throws {
        let container = try makeModelContainer()
        let context = container.mainContext
        let item = try #require(TodoItemActions.createTask(title: "Remove me", in: context))

        TodoItemActions.delete(item, from: context)
        let items = try fetchTodoItems(in: context)

        #expect(items.isEmpty)
    }

    @MainActor
    @Test func seedDefaultTasksOnlyWhenStoreIsEmpty() throws {
        let container = try makeModelContainer()
        let context = container.mainContext

        try TodoItemActions.seedDefaultTasksIfNeeded(in: context)
        try TodoItemActions.seedDefaultTasksIfNeeded(in: context)
        let items = try fetchTodoItems(in: context)

        #expect(items.map(\.title) == ["My first task", "My second task"])
    }

    @MainActor
    private func makeModelContainer() throws -> ModelContainer {
        let schema = Schema([TodoItem.self])
        let configuration = ModelConfiguration(
            "Test-\(UUID().uuidString)",
            schema: schema,
            isStoredInMemoryOnly: true
        )

        return try ModelContainer(for: schema, configurations: [configuration])
    }

    @MainActor
    private func fetchTodoItems(in context: ModelContext) throws -> [TodoItem] {
        let descriptor = FetchDescriptor<TodoItem>(
            sortBy: [SortDescriptor(\TodoItem.createdAt, order: .forward)]
        )

        return try context.fetch(descriptor)
    }
}
