
//
//  ChangePlayerTableViewController.swift
//  OrderForm
//
//  Created by Chen Hsin Hsuan on 2015/7/2.
//  Copyright (c) 2015年 AirconTW. All rights reserved.
//

import UIKit

class ChangePlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var orderFormViewController:OrderFormViewController!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "StartPlayerHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: StartPlayerTableViewHeaderFooterViewIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "ReservePlayerHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: ReservePlayerTableViewHeaderFooterViewIdentifier)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if orderFormViewController.selectedIndexPath?.section == 0 {
            return 2
        }
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let startPlayerCount = orderFormViewController.startPlayers.count
        let reservePlayerCount = orderFormViewController.reservePlayers.count
        let offLinePlayerCount = orderFormViewController.offLinePlayers.count
        
        if orderFormViewController.selectedIndexPath?.section == 0 {
            if section == 0 {
                if orderFormViewController.reservePlayers.count > 0 {
                    return reservePlayerCount
                }
            } else {
                if orderFormViewController.offLinePlayers.count > 0 {
                    return offLinePlayerCount
                }
            }
            return 1
        }
        return startPlayerCount
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if orderFormViewController.selectedIndexPath?.section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(ReservePlayerTableViewHeaderFooterViewIdentifier) as? ReservePlayerHeaderView
            if section == 0 {
                headerView?.sectionTitleLabel.text = "預備選手"
            }else{
                headerView?.sectionTitleLabel.text = "已下場選手"
            }
            return headerView
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(StartPlayerTableViewHeaderFooterViewIdentifier) as? StartPlayerHeaderView
        return headerView
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        if orderFormViewController.selectedIndexPath?.section == 0 {
            //先發替換
            if indexPath.section == 0 {
                if orderFormViewController.reservePlayers.count > 0 {
                    let cell = self.tableView.dequeueReusableCellWithIdentifier(ReservePlayerCellIdentifier) as! ReservePlayerTableViewCell
                    let thePlayer = orderFormViewController.reservePlayers[indexPath.row]
                    cell.playerNameLabel.text = thePlayer.name
                    cell.playerNumberLabel.text = thePlayer.number
                    return cell
                } else {
                    //沒有預備球員
                    let cell = self.tableView.dequeueReusableCellWithIdentifier(NoPlayerCellIdentifier) as! NoPlayerTableViewCell
                    cell.titleLabel.text = "無預備球員"
                    return cell
                }
            } else {
                //已下場球員清單
                if orderFormViewController.offLinePlayers.count > 0 {
                    let cell = self.tableView.dequeueReusableCellWithIdentifier(ReservePlayerCellIdentifier) as! ReservePlayerTableViewCell
                    let thePlayer = orderFormViewController.offLinePlayers[indexPath.row]
                    cell.playerNameLabel.text = thePlayer.name
                    cell.playerNumberLabel.text = thePlayer.number
                    return cell
                }else{
                    //沒有已下場的球員
                    let cell = self.tableView.dequeueReusableCellWithIdentifier(NoPlayerCellIdentifier) as! NoPlayerTableViewCell
                    cell.titleLabel.text = "無可再上場球員"
                    return cell
                }
            }

        }
        
        //預備球員或已下場球員上場
        let thePlayer = orderFormViewController.startPlayers[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(StartPlayerCellIdentifier) as! StartPlayerTableViewCell
        cell.hitNumberLabel.text = "\(indexPath.row+1)"
        cell.playerNameLabel.text = thePlayer.name
        cell.playerNumberLabel.text = thePlayer.number
        cell.playerPositionLabel.text = thePlayer.position
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if orderFormViewController.selectedIndexPath?.section == 0 &&
            orderFormViewController.reservePlayers.count == 0 &&
            indexPath.section == 0 && indexPath.row == 0
        {
            return
        }

        if orderFormViewController.selectedIndexPath?.section == 0 &&
            orderFormViewController.reservePlayers.count == 0 &&
            indexPath.section == 1 && indexPath.row == 0
        {
            return
        }
        
        
        let castToOffLinePlayer:Player! //下場
        let castToStartPlayer:Player!   //上場
        
        if orderFormViewController.selectedIndexPath?.section == 0 {
            //先發下場
            
            //1.抓出兩個交換的球員
            castToOffLinePlayer = orderFormViewController.startPlayers[orderFormViewController.selectedIndexPath!.row]
            
            if indexPath.section == 0 {
                //上場的球員為預備球員
                castToStartPlayer = orderFormViewController.reservePlayers[indexPath.row]
                //刪除該球員於預備球員名單
                orderFormViewController.reservePlayers.removeAtIndex(indexPath.row)
            }else{
                //上場的球員為已下場的球員
                castToStartPlayer = orderFormViewController.offLinePlayers[indexPath.row]
                //刪除該球員於已下場球員名單
                orderFormViewController.offLinePlayers.removeAtIndex(indexPath.row)
            }
            
            //移動到先發名單
            orderFormViewController.startPlayers[orderFormViewController.selectedIndexPath!.row] = castToStartPlayer
            
        }else{
            //跟哪個先發交換
            //1.抓出兩個交換的球員
            if orderFormViewController.selectedIndexPath?.section == 1 {
                //預備球員跟先發換
                castToStartPlayer = orderFormViewController.reservePlayers[orderFormViewController.selectedIndexPath!.row]
                //刪除該球員於預備球員名單
                orderFormViewController.reservePlayers.removeAtIndex(orderFormViewController.selectedIndexPath!.row)
            }else{
                //已下場球員跟先發換
                castToStartPlayer = orderFormViewController.offLinePlayers[orderFormViewController.selectedIndexPath!.row]
                //刪除該球員於已下場球員名單
                orderFormViewController.offLinePlayers.removeAtIndex(orderFormViewController.selectedIndexPath!.row)
            }
            
            castToOffLinePlayer = orderFormViewController.startPlayers[indexPath.row]
            
            
            //移動到先發名單
            orderFormViewController.startPlayers[indexPath.row] = castToStartPlayer
        }
        
        
        //2.先發放到下場球員名單(只處理有背號或有姓名的)
        if count(castToOffLinePlayer.name!) > 0 || count(castToOffLinePlayer.number!) > 0 {
            println("castToOffLinePlayer.name!:\(count(castToOffLinePlayer.name!))")
            println("castToOffLinePlayer.number!:\(count(castToOffLinePlayer.number!))")
            orderFormViewController.offLinePlayers.append(castToOffLinePlayer)
        }
        
        //3.指定球員跟先發資料彙整（守備位置）
        castToStartPlayer.position = castToOffLinePlayer.position
        castToOffLinePlayer.position = nil

        
        
        self.navigationController?.popToViewController(orderFormViewController, animated: true)
    
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
