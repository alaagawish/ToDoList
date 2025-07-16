//
//  HomeViewModel.swift
//  ToDoList
//
//  Created by Alaa Gawish on 16/07/2025.
//

import Foundation

class HomeViewModel {
    var localStorage: LocalStorageProtocol!
    init(localStorage: LocalStorageProtocol) {
        self.localStorage = localStorage
    }
    var bindAllTasks: (()->()) = {}
    var tasks: [Task] = [] {
        didSet {
            bindAllTasks()
        }
    }
    
    func getAllTasks() {
        tasks = localStorage.getAllTasks()
    }
    
    func deleteTask(withId: Int) {
        localStorage.deleteTask(withId: withId)
        self.getAllTasks()
    }
    
    func addNew(task: Task) {
        localStorage.saveTask(task)
        self.getAllTasks()
    }
    
    func updateTask(task: Task, completeFlag: Bool = false) {
        localStorage.updateTask(task, completeFlag: completeFlag)
        getAllTasks()
    }
}
