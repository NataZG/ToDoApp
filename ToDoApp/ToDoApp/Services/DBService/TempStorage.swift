//
//  TempStorage.swift
//  ToDoApp
//
//  Created by Nata on 08.07.2021.
//

import Foundation

class TempStorage {
    
    static let sharedInstance = TempStorage()
    private init() { }
    
    var highPriorityTodos: [TodoListItem] = []
    var mediumPriorityTodos: [TodoListItem] = []
    var lowPriorityTodos: [TodoListItem] = []
}
