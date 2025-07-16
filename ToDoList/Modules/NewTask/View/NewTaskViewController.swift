//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Alaa Gawish on 16/07/2025.
//

import UIKit

class NewTaskViewController: BaseViewController {
    static let identifier: String = "NewTaskViewController"
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var taskTitle: UITextView!
    var viewModel: HomeViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func initValues() {
        viewModel = HomeViewModel(localStorage: LocalStorage())
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: taskDate.date)
        viewModel.addNew(task: Task(id: Int.random(in: 100...10000) +  Int.random(in: 99...99992), title: taskTitle.text ?? "", date: dateString, isCompleted: false))
        self.navigationController?.popViewController(animated: true)
    }
}
