//
//  LocalStorage.swift
//  ToDoList
//
//  Created by Alaa Gawish on 16/07/2025.
//

import CoreData
import UIKit

class LocalStorage: LocalStorageProtocol {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext
    var entity: NSEntityDescription
    init() {
        
        managedContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "TaskEntity", in: managedContext)!
    }
    func getAllTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TaskEntity")
        var allTasks: [Task] = []
        do {
            let tasks = try managedContext.fetch(fetchRequest)
            
            for i in tasks {
                allTasks.append(Task(id: i.value(forKey: "id") as! Int, title: i.value(forKey: "title") as! String, date: i.value(forKey: "date") as! String, isCompleted: i.value(forKey: "isDone") as? Bool ?? false))
            }
            print("Getting all tasks done.")
            
        } catch let error as NSError{
            print("\nerror in fetching tasks: \(error)")
        }
        return allTasks
    }
    
    func saveTask(_ task: Task) {
        let movieEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        movieEntity.setValue(task.date, forKey: "date")
        movieEntity.setValue(task.isCompleted, forKey: "isDone")
        movieEntity.setValue(task.id, forKey: "id")
        movieEntity.setValue(task.title, forKey: "title")
        
        do {
            try managedContext.save()
            print("Task saved in Local source")
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteTask(withId id: Int) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id as CVarArg)
        
        do {
            if let item = try managedContext.fetch(fetchRequest).first {
                managedContext.delete(item)
                try managedContext.save()
            }
        } catch {
            print("task deleted: \(error)")
        }
    }
    
    func updateTask(_ task: Task) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", task.id)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if let storedTask = results.first {
                storedTask.title = task.title
                storedTask.isDone = task.isCompleted
                try managedContext.save()
                print("Task updated successfully.")
            } else {
                print("Task not found.")
            }
        } catch {
            print("Failed to fetch or update task: \(error)")
        }
    }
}
