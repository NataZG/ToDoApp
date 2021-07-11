//
//  ToDoListTVC.swift
//  ToDoApp
//
//  Created by Nata on 09.07.2021.
//

import UIKit

class ToDoListTVC: UITableViewController {

    @IBOutlet weak var deleteButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDeleteButton()
        // добавление кнопки и функцонала editButton
        navigationItem.leftBarButtonItem = editButtonItem
        // выбор сразу нескольких ячеек
        tableView.allowsMultipleSelectionDuringEditing = true
    }

    @IBAction func deleteItems(_ sender: UIBarButtonItem) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let priority = Priority(rawValue: indexPath.section) {
                    let todos = TodoListDBService.todoList(for: priority)

                    let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1: indexPath.row
                    let item = todos[rowToDelete]

                    TodoListDBService.remove(item, from: priority, at: rowToDelete)
                }
            }
            tableView.deleteRows(at: selectedRows, with: .automatic)
            setUpDeleteButton()
        }
    }

    func configureText(for cell: UITableViewCell, with item: TodoListItem) {
        if let checkmarkCell = cell as? ToDoListCellView {
            checkmarkCell.toDoLabel.text = item.text
        }
    }

    func configureCheckmark(for cell: UITableViewCell, with item: TodoListItem) {
        guard let checkmarkCell = cell as? ToDoListCellView else { return }

        if item.checked {
            checkmarkCell.checkmarkImage.image = #imageLiteral(resourceName: "photo_2021-07-08 20.19.55")
        } else {
            checkmarkCell.checkmarkImage.image = nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddItem" {
            if let itemDetailViewController = segue.destination as? ToDoItemVC {
                itemDetailViewController.delegate = self
            }
        }
    }

    private func setUpDeleteButton() {
        deleteButton.isEnabled = tableView.indexPathsForSelectedRows != nil
    }
}

// MARK: - Table view data source

extension ToDoListTVC {
    // MARK: - Header & Sections

    override func numberOfSections(in tableView: UITableView) -> Int {
        Priority.allCases.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        if let priority = Priority(rawValue: section) {
            switch priority {
            case .high:
                title = "High Priority Tasks"
            case .medium:
                title = "Medium Priority Tasks"
            case .low:
                title = "Low Priority Tasks"
            }
        }
        return title
    }

    // MARK: - Rows

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let priority = Priority(rawValue: section) else { return 0 }
        return TodoListDBService.todoList(for: priority).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let priority = Priority(rawValue: indexPath.section) {
            let items = TodoListDBService.todoList(for: priority)
            let item = items[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        return cell
    }
}

extension ToDoListTVC {
    // когда выделяем
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            setUpDeleteButton()
            return
        }

        if let cell = tableView.cellForRow(at: indexPath) {
            if let priority = Priority(rawValue: indexPath.section) {
                let items = TodoListDBService.todoList(for: priority)
                let item = items[indexPath.row]
                item.checked.toggle()
                configureCheckmark(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

    // когда снимаем выделение
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            setUpDeleteButton()
        }
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let itemDelete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            if let priority = Priority(rawValue: indexPath.section) {
                let item = TodoListDBService.todoList(for: priority)[indexPath.row]
                TodoListDBService.remove(item, from: priority, at: indexPath.row)
                let indexPaths = [indexPath]
                tableView.deleteRows(at: indexPaths, with: .automatic)
            }
        }

        let itemEdit = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [itemDelete, itemEdit])
        return swipeActions
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let srcPriority = Priority(rawValue: sourceIndexPath.section),
            let destPriority = Priority(rawValue: destinationIndexPath.section)
        {
            let item = TodoListDBService.todoList(for: srcPriority)[sourceIndexPath.row]
            TodoListDBService.move(item: item, from: srcPriority, at: sourceIndexPath.row, to: destPriority, at: destinationIndexPath.row)
        }
        tableView.reloadData()
    }
}

// MARK: TodoItemViewControllerDelegate

extension ToDoListTVC: ToDoItemVCDelegate {
    func ToDoItemVCDidCancel() {
        navigationController?.popViewController(animated: true)
    }

    func ToDoItemVC(didFinishAddingItemFor priority: Priority) {
        navigationController?.popViewController(animated: true)
        let rowIndex = TodoListDBService.todoList(for: priority).count - 1
        let indexPath = IndexPath(row: rowIndex, section: priority.rawValue)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
}

