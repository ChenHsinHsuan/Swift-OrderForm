//
//  OrderFormViewController.swift
//  OrderForm
//
//  Created by Chen Hsin Hsuan on 2015/6/30.
//  Copyright (c) 2015年 AirconTW. All rights reserved.
//

import UIKit

class OrderFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK:IBoutLet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderHitButton: UIBarButtonItem!
    
    //MARK:Variable
    let StartPlayerCellIdentifier = "StartPlayerCellIdentifier"
    let CreateIdentifier = "CreateIdentifier"
    let ReservePlayerCellIdentifier = "ReservePlayerCellIdentifier"
    let StartPlayerTableViewHeaderFooterViewIdentifier = "StartPlayerTableViewHeaderFooterViewIdentifier"
    let ReservePlayerTableViewHeaderFooterViewIdentifier = "ReservePlayerTableViewHeaderFooterViewIdentifier"
    
    let Segue_EditStartPlayerIdentifier = "EditStartPlayerSegueIdentifier"
    let Segue_EditReservePlayerIdentifier = "EditReservePlayerSegueIdentifier"
    
    let positionDict:[String:String] = ["P":"投", "C":"捕", "1B":"一",
                        "2B":"二", "3B":"三", "SS":"游",
                        "LF":"左", "CF":"中", "RF":"右",
                        "SF":"自", "DH":"指"]
    
    
    var startPlayers = [Player](count: 10, repeatedValue: Player(name: nil, number: "--", position: "N/A"))
    var reservePlayers = [Player]()
    var offLinePlayers = [Player]()
    var selectedIndexPath: NSIndexPath?
    
    
    
    //MARK:ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.registerNib(UINib(nibName: "StartPlayerHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: StartPlayerTableViewHeaderFooterViewIdentifier)

        self.tableView.registerNib(UINib(nibName: "ReservePlayerHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: ReservePlayerTableViewHeaderFooterViewIdentifier)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:TableView 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sectionCounter = 2
        if offLinePlayers.count > 0 {
            sectionCounter++
        }
        return sectionCounter
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCounter = 0
        
        switch section {
        case 0 :
            rowCounter = 10
        case 1 :
            rowCounter = reservePlayers.count + 1
        case 2 :
            rowCounter = offLinePlayers.count
        default:
            rowCounter = 0
        }
        
        return rowCounter
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(StartPlayerCellIdentifier) as! StartPlayerTableViewCell
            cell.hitNumberLabel.text = "\(indexPath.row+1)"
        
            let thePlayer = startPlayers[indexPath.row]
        
            cell.playerNameLabel.text = thePlayer.name
            cell.playerNumberLabel.text = thePlayer.number
            cell.playerPositionLabel.text = positionDict[thePlayer.position!]
            return cell
       }
    

    
        if reservePlayers.count > 0 && indexPath.row < reservePlayers.count {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(ReservePlayerCellIdentifier) as! ReservePlayerTableViewCell
            let thePlayer = reservePlayers[indexPath.row]
            cell.playerNameLabel.text = thePlayer.name
            cell.playerNumberLabel.text = thePlayer.number
            return cell
        }

        let cell = self.tableView.dequeueReusableCellWithIdentifier(CreateIdentifier) as! UITableViewCell
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch section {
        case 0 :
            title = "先發"
        case 1 :
            title = "預備"
        case 2 :
            title = "下場"
        default:
            title = ""
        }
        return title
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(StartPlayerTableViewHeaderFooterViewIdentifier) as? StartPlayerHeaderView
            return headerView
        }
        
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(ReservePlayerTableViewHeaderFooterViewIdentifier) as? ReservePlayerHeaderView
            return headerView
        }
        
        let headerView = tableView.tableHeaderView as? UITableViewHeaderFooterView
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 44
        }
        
        if section == 1 {
            return 44
        }
        
        return 22
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
//        if indexPath.section == 0 {
//            self.selectedIndexPath = indexPath
//            performSegueWithIdentifier(Segue_EditStartPlayerIdentifier, sender: self)
//        }else 
        if indexPath.section == 1 {
            if indexPath.row != reservePlayers.count {
                self.selectedIndexPath = indexPath
                performSegueWithIdentifier(Segue_EditReservePlayerIdentifier, sender: self)
            }
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let thePlayer = self.startPlayers[sourceIndexPath.row]
        self.startPlayers.removeAtIndex(sourceIndexPath.row)
        self.startPlayers.insert(thePlayer, atIndex: destinationIndexPath.row)

        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject) -> Bool {
        return true
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            switch indexPath.section {
//            case 0:
//                self.startPlayers[indexPath.row] = Player(name: "", number: "--", position:"")
//            case 1:
//                self.reservePlayers.removeAtIndex(indexPath.row)
//            case 2:
//                self.offLinePlayers.removeAtIndex(indexPath.row)
//            default:
//                return
//            }
//        }
//        
//        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        //delete按鈕自己做
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "清除", handler: {
            (action:UITableViewRowAction! , indexPath:NSIndexPath!) -> Void in
            switch indexPath.section {
            case 0:
                self.startPlayers[indexPath.row] = Player(name: "", number: "--", position:"")
            case 1:
                self.reservePlayers.removeAtIndex(indexPath.row)
            case 2:
                self.offLinePlayers.removeAtIndex(indexPath.row)
            default:
                return
            }
            self.tableView.reloadData()
        })
        deleteAction.backgroundColor = UIColor(red:0.84, green:0.0, blue:0.0, alpha:1)

        //編輯
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "編輯", handler: {
            (action:UITableViewRowAction! , indexPath:NSIndexPath!) -> Void in
            if indexPath.section == 0 {
                self.selectedIndexPath = indexPath
                self.performSegueWithIdentifier(self.Segue_EditStartPlayerIdentifier, sender: self)
            }else if indexPath.section == 1 {
                if indexPath.row != self.reservePlayers.count {
                    self.selectedIndexPath = indexPath
                    self.performSegueWithIdentifier(self.Segue_EditReservePlayerIdentifier, sender: self)
                }
            }
        })
        editAction.backgroundColor = UIColor(red:1.0, green:0.09, blue:0.27, alpha:1)

        //更換球員
        var changeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "更換", handler: {
            (action:UITableViewRowAction! , indexPath:NSIndexPath!) -> Void in
        })
        changeAction.backgroundColor = UIColor(red:1.0, green:0.32, blue:0.32, alpha:1)
        
        
        if indexPath.section == 0 {
            return [changeAction, editAction, deleteAction]
        }
        
        if indexPath.section == 1 {
            return [changeAction, editAction, deleteAction]
        }

        return []
    }
    
    //MARK: IBAction
    @IBAction func hitOrderButtonPressed(sender: UIBarButtonItem) {
        self.tableView.editing = !self.tableView.editing
        if self.tableView.editing {
            sender.title = "完成"
        }else{
            sender.title = "棒次"
        }
    }
}

