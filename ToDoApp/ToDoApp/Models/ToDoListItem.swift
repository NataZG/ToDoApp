//
//  ToDoListItem.swift
//  ToDoApp
//
//  Created by Nata on 08.07.2021.
//

import Foundation

class TodoListItem {
    
    var text: String
    var checked: Bool
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }
}
