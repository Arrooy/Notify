//
//  TaskTableViewCell.swift
//  Notify
//
//  Created by Alumne on 30/10/2020.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var ImatgeCheck: UIImageView!
    @IBOutlet weak var TaskName: UILabel!
    
    // Definim callback com a atribut del nostre controlador
    var callbackImagePressed: () -> Void = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        ImatgeCheck.isUserInteractionEnabled = true
        ImatgeCheck.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        // Your action
        callbackImagePressed();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
