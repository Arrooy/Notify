//
//  AddViewController.swift
//  Notify
//
//  Created by Alumne on 30/10/2020.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    var callbackAddTask: (_ attribute: String,_ attribute: Date?) -> Void = { _,_ in}
    var callbackEndedView: () -> Void = {}
    
    var userWantsReminder:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date();
    }
    
    @IBAction func cancelButtonActionHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonActionHandler(_ sender: Any) {
                
        callbackAddTask(taskTextField.text!, userWantsReminder ? datePicker.date : nil);
        
        self.dismiss(animated: true, completion: callbackEndedView)
    }
 
    
    @IBAction func switcChanged(_ sender: Any) {
        userWantsReminder = (sender as! UISwitch).isOn
    }
}
