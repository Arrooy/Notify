//
//  AddViewController.swift
//  Notify
//
//  Created by Alumne on 30/10/2020.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var taskTextField: UITextField!
    
    var callbackAddTask: (_ attribute: String) -> Void = { _ in}
      
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelButtonActionHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonActionHandler(_ sender: Any) {

        callbackAddTask(taskTextField.text!);
        self.dismiss(animated: true, completion: nil)
    }
    
    //Todo: Check this and add result to callback
    func showAlertDatePicker(){
        let myDatePicker: UIDatePicker = UIDatePicker()
        myDatePicker.timeZone = .local
        myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        alertController.view.addSubview(myDatePicker)
        let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            print("Selected Date: \(myDatePicker.date)")
            print("\(type(myDatePicker.date))")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
