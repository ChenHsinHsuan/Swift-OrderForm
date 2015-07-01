//
//  StartPlayerTableViewCell.swift
//  OrderForm
//
//  Created by Chen Hsin Hsuan on 2015/6/30.
//  Copyright (c) 2015年 AirconTW. All rights reserved.
//

import UIKit

class StartPlayerTableViewCell: UITableViewCell {


    //MARK:Variable
    @IBOutlet weak var hitNumberLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerPositionLabel: UILabel!
    @IBOutlet weak var playerNumberLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let changeMenuItem = UIMenuItem(title: "更換", action: "changePlayerButtonPressed")
        UIMenuController.sharedMenuController().menuItems = [changeMenuItem]
        UIMenuController.sharedMenuController().update()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == "changePlayerButtonPressed" {
            return true
        }
        return false
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func changePlayerButtonPressed(){

    }
}
