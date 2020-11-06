//
//  MainTableViewController.swift
//  Notify
//
//  Created by Alumne on 30/10/2020.
//

import UIKit

class MainTableViewController: UITableViewController {

    var tasks: [Task] = [Task]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSomeTasks()
    }
    
    func addSomeTasks(){
        tasks.append(Task(name:"Ei!",taskIsCompleted: false))
        tasks.append(Task(name:"done !!",taskIsCompleted: true))    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath)->CGFloat{
        return 125.5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifyCell", for: indexPath) as! TaskTableViewCell
        
        // Configure the cell...
        cell.TaskName.text = tasks[indexPath.row].taskName
        cell.ImatgeCheck.image = tasks[indexPath.row].taskIsCompleted ? UIImage(named:"checked") : UIImage(named:"unchecked")
        
        return cell
    }
    
}
