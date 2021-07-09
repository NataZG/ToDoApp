//
//  ToDoListDBService.swift
//  ToDoApp
//
//  Created by Nata on 08.07.2021.
//

import Foundation

enum Priority: Int, CaseIterable {
    case high
    case medium
    case low
}

// MARK: - TodoListDBService

enum TodoListDBService {
    static func addTodo(_ item: TodoListItem, for priority: Priority, at index: Int) {
        switch priority {
        case .high:
            TempStorage.sharedInstance.highPriorityTodos.insert(item, at: index)
        case .medium:
            TempStorage.sharedInstance.mediumPriorityTodos.insert(item, at: index)
        case .low:
            TempStorage.sharedInstance.lowPriorityTodos.insert(item, at: index)
        }
    }

    static func todoList(for priority: Priority) -> [TodoListItem] {
        switch priority {
        case .high:
            return TempStorage.sharedInstance.highPriorityTodos
        case .medium:
            return TempStorage.sharedInstance.mediumPriorityTodos
        case .low:
            return TempStorage.sharedInstance.lowPriorityTodos
        }
    }

    static func newTodo(text: String, for priority: Priority) {
        let item = TodoListItem(text: text, checked: false)
        switch priority {
        case .high:
            TempStorage.sharedInstance.highPriorityTodos.append(item)
        case .medium:
            TempStorage.sharedInstance.mediumPriorityTodos.append(item)
        case .low:
            TempStorage.sharedInstance.lowPriorityTodos.append(item)
        }
    }

    static func move(item: TodoListItem, from sourcePriority: Priority, at sourceIndex: Int, to destinationPriority: Priority, at destinationIndex: Int) {
        remove(item, from: sourcePriority, at: sourceIndex)
        addTodo(item, for: destinationPriority, at: destinationIndex)
    }

    static func remove(_ item: TodoListItem, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            TempStorage.sharedInstance.highPriorityTodos.remove(at: index)
        case .medium:
            TempStorage.sharedInstance.mediumPriorityTodos.remove(at: index)
        case .low:
            TempStorage.sharedInstance.lowPriorityTodos.remove(at: index)
        }
    }
}
