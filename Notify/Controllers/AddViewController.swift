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
    
    var callbackAddTask: (_ attribute: String) -> Void = { _ in}
    var userWantsReminder:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date();
    }
    
    @IBAction func cancelButtonActionHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonActionHandler(_ sender: Any) {
        if userWantsReminder{
            print("Date is ",datePicker.date)
        }else{
            print("Date not used")
        }
        
        callbackAddTask(taskTextField.text!);
        self.dismiss(animated: true, completion: nil)
    }
    
   //TODO: THIS PETA
    @IBAction func remindMeLaterSwitch(_ sender: Any) {
        let sw = sender as! UISwitch
        userWantsReminder = sw.isOn
    }
    
    
}
