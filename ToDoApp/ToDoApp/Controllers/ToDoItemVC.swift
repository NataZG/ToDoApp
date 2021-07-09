//
//  ToDoItemVC.swift
//  ToDoApp
//
//  Created by Nata on 08.07.2021.
//

import UIKit

protocol ToDoItemVCDelegate: AnyObject {
    func ToDoItemVCDidCancel()
    func ToDoItemVC(didFinishAddingItemFor priority: Priority)
}

class ToDoItemVC: UIViewController {

    weak var delegate: ToDoItemVCDelegate?

    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var priority: Priority = .medium

    var pickerData = ["High Priority Todos",
                      "Medium Priority Todos",
                      "Low Priority Todos"]

    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
        picker.selectRow(1, inComponent: 0, animated: true)
    }

    
    @IBAction func doneBtnAction(_ sender: UIBarButtonItem) {
        if let textFieldText = textField.text {
            TodoListDBService.newTodo(text: textFieldText, for: priority)
            delegate?.ToDoItemVC(didFinishAddingItemFor: priority)
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: UIBarButtonItem) {
        delegate?.ToDoItemVCDidCancel()
    }
    
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            doneBtn.isEnabled = true
        } else {
            doneBtn.isEnabled = false
        }
    }
}

// MARK: UIPickerViewDataSource, UIPickerViewDelegate

extension ToDoItemVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priority = Priority(rawValue: row) ?? .medium
    }
}
