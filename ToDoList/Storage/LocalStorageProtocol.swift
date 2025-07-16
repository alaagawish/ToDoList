//
//  LocalStorageProtocol.swift
//  ToDoList
//
//  Created by Alaa Gawish on 16/07/2025.
//

import Foundation

protocol LocalStorageProtocol {
    func getAllTasks() -> [Task]
    func saveTask(_ task: Task)
    func deleteTask(withId id: Int)
    func updateTask(_ task: Task)
}
