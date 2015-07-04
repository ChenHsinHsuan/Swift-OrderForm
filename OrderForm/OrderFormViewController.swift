//
//  OrderFormViewController.swift
//  OrderForm
//
//  Created by Chen Hsin Hsuan on 2015/6/30.
//  Copyright (c) 2015年 AirconTW. All rights reserved.
//

import UIKit


let StartPlayerCellIdentifier = "StartPlayerCellIdentifier"
let CreateIdentifier = "CreateIdentifier"
let ReservePlayerCellIdentifier = "ReservePlayerCellIdentifier"
let StartPlayerTableViewHeaderFooterViewIdentifier = "StartPlayerTableViewHeaderFooterViewIdentifier"
let ReservePlayerTableViewHeaderFooterViewIdentifier = "ReservePlayerTableViewHeaderFooterViewIdentifier"
let NoPlayerCellIdentifier = "NoPlayerCellIdentifier"

let Segue_EditStartPlayerIdentifier = "EditStartPlayerSegueIdentifier"
let Segue_EditReservePlayerIdentifier = "EditReservePlayerSegueIdentifier"
let Segue_PositionIdentifier = "PositionIdentifier"
let Segue_ChangePlayerIdentifier = "ChangePlayerSegueIdentifier"

let positionDict:[String:String] = ["P":"投", "C":"捕", "1B":"一",
                                    "2B":"二", "3B":"三", "SS":"游",
                                    "LF":"左", "CF":"中", "RF":"右",
                                    "SF":"自", "DH":"指"]


class OrderFormViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {

    //MARK:IBoutLet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightTabBarButton: UIBarButtonItem!
    @IBOutlet weak var leftTabBarButton: UIBarButtonItem!
    
    
    //MARK:Variable
    var startPlayers = [Player](count: 10, repeatedValue: Player())
    var reservePlayers = [Player]()
    var offLinePlayers = [Player]()
    var selectedIndexPath: NSIndexPath?

    
    //MARK:ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        
        self.tableView.registerNib(UINib(nibName: "StartPlayerHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: StartPlayerTableViewHeaderFooterViewIdentifier)

        self.tableView.registerNib(UINib(nibName: "ReservePlayerHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: ReservePlayerTableViewHeaderFooterViewIdentifier)
        
        //select database
        self.reservePlayers = shareAppDelegate.findPlayerList()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndexPath = nil
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  Segue_EditStartPlayerIdentifier {
            let destVC = segue.destinationViewController as! EditStartPlayerViewController
            destVC.orderFormViewController = self
        }else if segue.identifier == Segue_EditReservePlayerIdentifier {
            let destVC = segue.destinationViewController as! EditReservePlayerViewController
            destVC.fromViewController = self
        }else if segue.identifier == Segue_PositionIdentifier {
            
            println("")
            let destVC = segue.destinationViewController as! PositionViewController
            destVC.orderFormViewController = self
        }else if segue.identifier == Segue_ChangePlayerIdentifier {
            let destVC = segue.destinationViewController as! ChangePlayerViewController
            destVC.orderFormViewController = self
        }
    }
    
    
    //MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCounter = 0
        
        switch section {
        case 0 :
            rowCounter = 10
        case 1 :
            rowCounter = reservePlayers.count + 1
        case 2 :
            if offLinePlayers.count == 0 {
                rowCounter = 1
            }else{
                rowCounter = offLinePlayers.count
            }
        default:
            return 0
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
//            cell.playerPositionLabel.text = positionDict[thePlayer.position!]
            cell.playerPositionLabel.text = thePlayer.position
            return cell
       } else if indexPath.section == 1 {
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
        
        if offLinePlayers.count > 0 {
            let cell = self.tableView.dequeueReusableCellWithIdentifier(ReservePlayerCellIdentifier) as! ReservePlayerTableViewCell
            let thePlayer = offLinePlayers[indexPath.row]
            cell.playerNameLabel.text = thePlayer.name
            cell.playerNumberLabel.text = thePlayer.number
            return cell
        }
        
        //沒有球員
        let cell = self.tableView.dequeueReusableCellWithIdentifier(NoPlayerCellIdentifier) as! NoPlayerTableViewCell
        cell.titleLabel.text = "無已下場球員"
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
            return ""
        }
        return title
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(StartPlayerTableViewHeaderFooterViewIdentifier) as? StartPlayerHeaderView
            headerView?.sectionTitleLabel.text = "先發選手"
            return headerView
        }
        

        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(ReservePlayerTableViewHeaderFooterViewIdentifier) as? ReservePlayerHeaderView
        if section == 1 {
            headerView?.sectionTitleLabel.text = "預備選手,共\(reservePlayers.count)名"
        }else{
            headerView?.sectionTitleLabel.text = "已下場選手,共\(offLinePlayers.count)名"
        }
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if reservePlayers.count == 0 && indexPath.section == 1 && indexPath.row == 0 {
            return false
        }
        
        if indexPath.section == 1 && indexPath.row == reservePlayers.count {
            return false
        }
        
        if offLinePlayers.count == 0 && indexPath.section == 2 && indexPath.row == 0 {
            return false
        }
        
        
        return true
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {

        if reservePlayers.count == 0 && indexPath.section == 1 && indexPath.row == 0 {
            return []
        }
        
        if offLinePlayers.count == 0 && indexPath.section == 2 && indexPath.row == 0 {
            return []
        }
        
        //delete按鈕自己做
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "清除", handler: {
            (action:UITableViewRowAction! , indexPath:NSIndexPath!) -> Void in
            switch indexPath.section {
            case 0:
                self.startPlayers[indexPath.row] = Player(name: "", number: "", position:"")
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
                self.performSegueWithIdentifier(Segue_EditStartPlayerIdentifier, sender: self)
            }else if indexPath.section == 1 {
                if indexPath.row != self.reservePlayers.count {
                    self.selectedIndexPath = indexPath
                    self.performSegueWithIdentifier(Segue_EditReservePlayerIdentifier, sender: self)
                }
            }
        })
        editAction.backgroundColor = UIColor(red:1.0, green:0.09, blue:0.27, alpha:1)

        //更換球員
        var changeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "更換", handler: {
            (action:UITableViewRowAction! , indexPath:NSIndexPath!) -> Void in
            
            self.selectedIndexPath = indexPath
            self.performSegueWithIdentifier(Segue_ChangePlayerIdentifier, sender: self)
            
        })
        changeAction.backgroundColor = UIColor(red:1.0, green:0.32, blue:0.32, alpha:1)
        
        
        if indexPath.section == 0 {
            let thePlayer = self.startPlayers[indexPath.row]
            if thePlayer.name == nil && thePlayer.number == nil && thePlayer.position == nil {
                return [editAction]
            }
            changeAction.title = "下場"
        }else if indexPath.section == 1 {
            changeAction.title = "上場"
        }else {
            changeAction.title = "再上場"
        }
    

        return [changeAction, editAction, deleteAction]
    }
    

    //MARK: - IBAction
    @IBAction func sortButtonPressed(sender: UIBarButtonItem) {
        self.tableView.editing = !self.tableView.editing
        if self.tableView.editing {
            self.rightTabBarButton.image = UIImage(named: "cross")
        }else{
            self.rightTabBarButton.image = UIImage(named: "sort")
        }
    }

    @IBAction func menuButtonPressed(sender: UIBarButtonItem) {
        if self.tableView.editing {
            self.tableView.editing = false
            self.rightTabBarButton.image = UIImage(named: "sort")
        }
        let actionSheet = UIActionSheet(title: "選單", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "退出", otherButtonTitles: "初始化", "守備地圖")
        actionSheet.showInView(self.view)
    }
    
    
    @IBAction func createReservePlayerButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier(Segue_EditReservePlayerIdentifier, sender: self)
    }
    
    
    //MARK: - UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        case 1:
            return
        case 2:
            self.startPlayers = [Player](count: 10, repeatedValue: Player())
            self.reservePlayers = shareAppDelegate.findPlayerList()
            self.offLinePlayers = [Player]()
            self.tableView.reloadData()
        case 3:
            performSegueWithIdentifier(Segue_PositionIdentifier, sender: self)
        default:
            return
        }
        
    }
    
    
}

