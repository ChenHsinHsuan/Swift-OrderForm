//
//  PlayerListTableViewController.swift
//  OrderForm
//
//  Created by Chen Hsin Hsuan on 2015/7/3.
//  Copyright (c) 2015年 AirconTW. All rights reserved.
//

import UIKit
import FMDB

let Segue_EditPlayer = "EditPlayerSegueIdentifier"
class PlayerListTableViewController: UITableViewController {

    
    var players = [Player]()
    var selectedIndexPath:NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !DB.open() {
            println("Unable to open database")
            return
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        players = [Player]()
        if let rs = DB.executeQuery("select * from T_PLAYER", withArgumentsInArray: nil) {
            var thePlayer:Player!
            var id:String?
            var name:String?
            var number:String?
            while rs.next() {
                id = rs.stringForColumn("id")
                name = rs.stringForColumn("name")
                number = rs.stringForColumn("number")
                thePlayer = Player(name: name, number: number!, position: "")
                thePlayer.id = id
                
                self.players.append(thePlayer)
            }
        } else {
            println("select failed: \(DB.lastErrorMessage())")
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return players.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ReservePlayerCellIdentifier, forIndexPath: indexPath) as! ReservePlayerTableViewCell

        let thePlayer = self.players[indexPath.row]
        // Configure the cell...
        cell.playerNameLabel.text = thePlayer.name
        cell.playerNumberLabel.text = thePlayer.number

        return cell
    }
    


    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let thePlayer = self.players[indexPath.row]
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            if DB.executeUpdate("delete from T_PLAYER where id = ? ;", withArgumentsInArray: [thePlayer.id!]){
                self.players.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        performSegueWithIdentifier(Segue_EditPlayer, sender: self)
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == Segue_EditPlayer {
            let destVC = segue.destinationViewController as! EditReservePlayerViewController
            destVC.fromViewController = self
        }
    }


    
    //MARK: - IBAction
    @IBAction func addButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier(Segue_EditPlayer, sender: self)
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
