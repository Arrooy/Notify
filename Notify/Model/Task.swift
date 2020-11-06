//
//  Task.swift
//  Notify
//
//  Created by Alumne on 30/10/2020.
//

import Foundation

class Task: NSObject{
    
    var taskName:String?
    var taskIsCompleted: Bool = false
    
    init(name:String, taskIsCompleted: Bool) {
        
        super.init()
        
        self.taskName = name
        self.taskIsCompleted = taskIsCompleted
    }
}
