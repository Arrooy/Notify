//
//  MainTableViewController.swift
//  Notify
//
//  Created by Alumne on 30/10/2020.
//

import UIKit

class MainTableViewController: UITableViewController {

    let REPKEY = "notify_key"
    
    var tasks: [Task] = [Task]()
    var repository: UserRepository = UserRepository()

    var names: [String]? = [String]()
    var states: [Bool]? = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (names, states) = repository.getUserInfo(forUserID: REPKEY)
        
        addSomeTasks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue1" {
            let addVC = segue.destination as! AddViewController
        
            addVC.callbackAddTask = { taskContent in
                print(taskContent)
                self.tasks.append(Task(name:taskContent,taskIsCompleted:false))
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                
                self.addTaskToDB(name: taskContent)
                
                /*self.beginUpdates()
                self.insertRowsAtIndexPaths([
                tblname.endUpdates()    */
                
            }
        }
    }
    
    func addTaskToDB(name: String) {
        repository.removeUserInfo(forUserID: REPKEY)
        
        names?.append(name)
        states?.append(false)
        
        repository.storeInfo(forUserID: REPKEY, name: names!, avatarData: states!)
    }
    
    func deleteTaskFromDB(index: Int) {
        repository.removeUserInfo(forUserID: REPKEY)
        
        names?.remove(at: index)
        states?.remove(at: index)
        
        repository.storeInfo(forUserID: REPKEY, name: names!, avatarData: states!)
    }
    
    func updateTaskFromDB(index: Int, name: String, state: Bool) {
        repository.removeUserInfo(forUserID: REPKEY)

        names?[index] = name
        states?[index] = state
        
        repository.storeInfo(forUserID: REPKEY, name: names!, avatarData: states!)
    }

    
    func addSomeTasks() {
        var so: [String]? = [String]()
        var bo: [Bool]? = [Bool]()

        (so, bo) = repository.getUserInfo(forUserID: REPKEY)
        
        for i in 0...((so?.count ?? 0)-1) {
            tasks.append(Task(name:so?[i] ?? "Error", taskIsCompleted: bo?[i] ?? false))
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        return 125.5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifyCell", for: indexPath) as! TaskTableViewCell
        
        // Configure the cell...
        updateCell(indexPath);
        
        return cell
    }
    

    func updateCell(indexPath:IndexPath){
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifyCell", for: indexPath) as! TaskTableViewCell
        cell.TaskName.text = tasks[indexPath.row].taskName
        cell.ImatgeCheck.image = tasks[indexPath.row].taskIsCompleted ? UIImage(named:"checked") : UIImage(named:"unchecked")
        
        cell.callbackImagePressed == niL ? { 
            self.tasks[indexPath.row].taskIsCompleted = !self.tasks[indexPath.row].taskIsCompleted;
            cell.ImatgeCheck.image = self.tasks[indexPath.row].taskIsCompleted ? UIImage(named:"checked") : UIImage(named:"unchecked")
            
            self.updateTaskFromDB(index: indexPath.row, name: self.tasks[indexPath.row].taskName ?? "Error", state: self.tasks[indexPath.row].taskIsCompleted)
        } : cell.callbackImagePressed

        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if !tasts[indexPath.row].taskIsCompleted {
            let alert = UIAlertController(title: "Marcar com a completada...", message:nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Marcar com completa", style: .default, handler:{_ in 
                self.tasks[indexPath.row].taskIsCompleted = true
                self.updateCell(indexPath);
            }))
            alert.addAction(UIAlertAction(title: "Cancel·lar", style: .cancel, handler: nil))
            present(alert, animated:true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Que vols fer?", message:nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Marcar com incompleta", style: .default, handler:{_ in 
                self.tasks[indexPath.row].taskIsCompleted = false
                self.updateCell(indexPath);
            }))
            alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler {_ in 
                removeTask(indexPath.row)
            }))
            
            present(alert, animated:true, completition:nil)
        }
    }

    func removeTask(index:Int){
        self.tasks.remove(at: index)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        
        self.deleteTaskFromDB(index)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            removeTask(indexPath.row)
        }
    }
    
    func createNotification(title: String, description: String, weekday: Int, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = description
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        dateComponents.weekday = weekday
        dateComponents.hour = hour
        dateComponents.minute = minute
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let uuidString = title
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }
}
