//
//  TasksViewController.swift
//  Calculater
//
//  Created by Nikita Yudichev on 08.05.2020.
//  Copyright © 2020 Nikita Yudichev. All rights reserved.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var user: selfUser!
    var ref: DatabaseReference!
    var tasks = Array<Task>()
    
    
    @IBOutlet weak var tableView: UITableView!
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .clear
       let task = tasks[indexPath.row]
        let taskTitle = tasks[indexPath.row].title
        let isCompleted = task.completed
        cell.textLabel?.text = taskTitle
        
        cell.textLabel?.textColor = .white
        toggleCompletion(cell, isCompleted: isCompleted)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = selfUser(users: currentUser)
        
        ref = Database.database().reference(withPath: "users").child(String(user.id)).child("tasks")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.removeAllObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value, with: { [weak self] (snapshot) in
            
            var _tasks = Array<Task>()
            
            for item in snapshot.children
            {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            self?.tableView.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        
        toggleCompletion(cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["completed": isCompleted])
    }
    
    
    func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool)
    {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
    
    
    @IBAction func AddTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        
        alertController.addTextField()
        
        let safe = UIAlertAction(title: "Save", style: .default) {[weak self] _ in
            
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            
            let task = Task(title: textField.text!, userId: (self?.user.id)!)
            
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.conToDictionary())
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(safe)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func ButtonOut(_ sender: UIBarButtonItem)
    {
        do
        {
            try Auth.auth().signOut()
        } catch
        {
            print("Error")
        }
        dismiss(animated: true, completion: nil)
    }
}
