//
//  MainTableViewController.swift
//  Notify
//
//  Created by Alumne on 30/10/2020.
//

import UIKit
import UserNotifications

class MainTableViewController: UITableViewController {

    let REPKEY = "notify_key"
    
    var tasks: [Task] = [Task]()
    var repository: UserRepository = UserRepository()

    var names: [String]? = [String]()
    var states: [Bool]? = [Bool]()
    var notids: [String]? = [String]()
    
    var notificationsActivated:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (names, states, notids) = repository.getUserInfo(forUserID: REPKEY)
        
        //Ask user for permission to show notifications
        requestNotificationPermission()
        
        
        loadTasksFromDB()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue1" {
            let addVC = segue.destination as! AddViewController
        
            addVC.callbackEndedView = {
                if !self.notificationsActivated {
                    self.showAlert(title: "No es mostrará la notificació de la tasca!", message: "Per a poder rebre notificacions, has d'acceptar les notificacions de l'app a les settings del IPhone.")
                }
            }
            
            addVC.callbackAddTask = { taskContent,notificationDate in
                self.tasks.append(Task(name:taskContent,taskIsCompleted:false))
                
                self.requestNotificationPermission()
                
                if self.notificationsActivated{
                    if let notifDate = notificationDate{
                        self.scheduleNotification(title:taskContent,description:"Recorda acabar la tasca!", notificationDate: notifDate)
                    }
                }
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                
                self.addTaskToDB(name: taskContent)
            }
        }
    }
    
    func addTaskToDB(name: String) {
        if (names == nil) {names = [String]()}
        if (states == nil) {states = [Bool]()}
        if (notids == nil) {notids = [String]()}
        
        repository.removeUserInfo(forUserID: REPKEY)
        
        names?.append(name)
        states?.append(false)
        notids?.append("")
        
        repository.storeInfo(forUserID: REPKEY, name: names!, avatarData: states!, notificationIDs: notids!)
    }
    
    func deleteTaskFromDB(index: Int) {
        repository.removeUserInfo(forUserID: REPKEY)
        
        names?.remove(at: index)
        states?.remove(at: index)

        if ((notids?[index] ?? nil) != nil) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                var identifiers: [String] = [self.notids![index]]
                for notification:UNNotificationRequest in notificationRequests {
                    if notification.identifier == "identifierCancel" {
                        identifiers.append(notification.identifier)
                    }
               }
               UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            }
        }

        notids?.remove(at: index)
        
        repository.storeInfo(forUserID: REPKEY, name: names!, avatarData: states!, notificationIDs: notids!)
    }
    
    func updateTaskFromDB(index: Int, name: String, state: Bool) {
        repository.removeUserInfo(forUserID: REPKEY)

        names?[index] = name
        states?[index] = state
        
        repository.storeInfo(forUserID: REPKEY, name: names!, avatarData: states!, notificationIDs: notids!)
    }

    func setNotificationIDatDB(index: Int, notificationID: String) {
        repository.removeUserInfo(forUserID: REPKEY)

        notids?[index] = notificationID
        
        repository.storeInfo(forUserID: REPKEY, name: names!, avatarData: states!, notificationIDs: notids!)
    }
    
    func loadTasksFromDB() {
        var so: [String]? = [String]()
        var bo: [Bool]? = [Bool]()
        var no: [String]? = [String]()

        (so, bo, no) = repository.getUserInfo(forUserID: REPKEY)
        
        if ((so?.count ?? -1) > 0) {
            for i in 0...((so?.count ?? 0)-1) {
                tasks.append(Task(name:so?[i] ?? "Error", taskIsCompleted: bo?[i] ?? false))
            }
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
        // Configure the cell...
        let cell = updateCellData(indexPath: indexPath);
        
        return cell
    }
    

    func updateCellData(indexPath:IndexPath) -> TaskTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifyCell", for: indexPath) as! TaskTableViewCell
        cell.TaskName.text = tasks[indexPath.row].taskName
        cell.ImatgeCheck.image = tasks[indexPath.row].taskIsCompleted ? UIImage(named:"checked") : UIImage(named:"unchecked")
        
        cell.callbackImagePressed = {
            self.tasks[indexPath.row].taskIsCompleted = !self.tasks[indexPath.row].taskIsCompleted;
            cell.ImatgeCheck.image = self.tasks[indexPath.row].taskIsCompleted ? UIImage(named:"checked") : UIImage(named:"unchecked")
            
            self.updateTaskFromDB(index: indexPath.row, name: self.tasks[indexPath.row].taskName ?? "Error", state: self.tasks[indexPath.row].taskIsCompleted)
        }
        
        //self.tableView.reloadData()
        //self.refreshControl?.endRefreshing()
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Acceptar", style: .cancel, handler: nil))

        if let presVC = self.presentedViewController {
            presVC.present(alert,animated: true,completion: nil)
        }else{
            present(alert,animated:true,completion: nil)
        }
    }
    
    
    //TODO: Check this
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !tasks[indexPath.row].taskIsCompleted {
            let alert = UIAlertController(title: "Marcar com a completada...", message:nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Marcar com completa", style: .default, handler:{_ in 
                self.tasks[indexPath.row].taskIsCompleted = true
                self.updateCellData(indexPath: indexPath);
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }))
            alert.addAction(UIAlertAction(title: "Cancel·lar", style: .cancel, handler: nil))
            present(alert, animated:true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Que vols fer?", message:nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Marcar com incompleta", style: .default, handler:{_ in 
                self.tasks[indexPath.row].taskIsCompleted = false
                self.updateCellData(indexPath: indexPath)
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }))
            alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: {_ in
                self.removeTask(index: indexPath.row)
            }))
            
            present(alert, animated:true, completion:nil)
        }
    }

    func removeTask(index:Int){
        self.tasks.remove(at: index)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        
        self.deleteTaskFromDB(index: index)
    }

    //Check this
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            removeTask(index: indexPath.row)
        }
    }
    
    func requestNotificationPermission(){
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            self.notificationsActivated = granted
        }
    }
    
    
    func scheduleNotification(title: String, description: String, notificationDate:Date) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = description
        content.sound = UNNotificationSound.default
        
        let dateComponents = Calendar.current.dateComponents([.year,.day,.month,.hour,.minute,.second], from: notificationDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    /*
    func createNotification(title: String, description: String, notificationDate:Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = description
        
        //Configure the recurring date
        //let dateComponents = Calendar.current.dateComponents([.year,.day,.month,.hour,.minute,.second], from: notificationDate)
        
        let notificationDate = Date().addingTimeInterval(TimeInterval(10))
        var component = Calendar.current.dateComponents([.year,.day,.month,.hour,.minute,.second], from: notificationDate)
        component.year = 2020
        print(component)
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: component, repeats: false)
        
        // Create the request
        let uuidString = title
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
                print("Error in notification")
            }
        }
    }*/
}
