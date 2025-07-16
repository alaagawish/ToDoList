//
//  HomeViewController.swift
//  ToDoList
//
//  Created by Alaa Gawish on 16/07/2025.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet private weak var newTitleTextField: UITextField!
    @IBOutlet private weak var editTaskView: UIView!
    @IBOutlet private weak var tasksTableView: UITableView!
    var tasks: [Task] = []
    var currentEditTaskIndex: Int = -1
    var homeViewModel: HomeViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func initValues() {
        homeViewModel = HomeViewModel(localStorage: LocalStorage())
    }
    override func bindValues() {
        homeViewModel.bindAllTasks =  { [weak self] in
            guard let self = self else { return }
            
            self.tasks  = tasks.sorted {
                if $0.isCompleted != $1.isCompleted {
                    return !$0.isCompleted
                } else {
                    return $0.date < $1.date
                }
            }
            self.tasksTableView.reloadData()
        }
    }
    override func registerCell() {
        tasksTableView.register(UINib(nibName: TaskTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        homeViewModel.getAllTasks()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func doneEditingTask(_ sender: Any) {
        tasks[currentEditTaskIndex].title = newTitleTextField.text ?? ""
        editTaskView.isHidden = true
    }
    @IBAction func addNewTask(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: NewTaskViewController.identifier) as? NewTaskViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        editTaskView.isHidden = true
        newTitleTextField.text = ""
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        cell.indexPath = indexPath
        cell.taskDelegate = self
        cell.add(task: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            self.homeViewModel.deleteTask(withId: self.tasks[indexPath.row].id)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
extension HomeViewController: TaskDelegate {
    func selectTask(at indexPath: IndexPath) {
        homeViewModel.updateTask(task: tasks[indexPath.row], completeFlag: true)
    }
    
    func uncheckedTask(at indexPath: IndexPath) {
        homeViewModel.updateTask(task: tasks[indexPath.row], completeFlag: false)
    }
    
    func editTask(at indexPath: IndexPath) {
        newTitleTextField.text = tasks[indexPath.row].title
        currentEditTaskIndex = indexPath.row
        editTaskView.isHidden = false
    }
}
