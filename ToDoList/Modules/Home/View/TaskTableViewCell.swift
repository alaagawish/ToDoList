//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Alaa Gawish on 16/07/2025.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    static let identifier = "TaskTableViewCell"
    @IBOutlet private weak var check: UIButton!
    @IBOutlet private weak var taskLabel: UILabel!
    
    var indexPath: IndexPath?
    var taskDelegate: TaskDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func add(task: Task) {
        
        check.setImage(UIImage(systemName: task.isCompleted ? "checkmark.square" : "square"), for: .normal)
        if task.isCompleted {
            let attributedString = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue
                ]
            )
            
            taskLabel.attributedText = attributedString
        } else {
            taskLabel.text = task.title
        }
    }
    @IBAction func editTask(_ sender: Any) {
        self.taskDelegate?.editTask(at: indexPath ?? IndexPath())
    }
    
    @IBAction func checkButton(_ sender: Any) {
        if check.image(for: .normal) == UIImage(systemName: "square") {
            self.taskDelegate?.selectTask(at: indexPath ?? IndexPath())
            check.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            self.taskDelegate?.uncheckedTask(at: indexPath ?? IndexPath())
            check.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
}

protocol TaskDelegate {
    func selectTask(at indexPath: IndexPath)
    func uncheckedTask(at indexPath: IndexPath)
    func editTask(at indexPath: IndexPath)
}
