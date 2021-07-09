//
//  ToDoItemVC.swift
//  ToDoApp
//
//  Created by Nata on 08.07.2021.
//

import UIKit

class ToDoItemVC: UIViewController {

    @IBOutlet weak var doneBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDoneBtn()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func setUpDoneBtn() {
        doneBtn.isEnabled = false
    }
}
