//
//  EditReservePlayerViewController.swift
//  OrderForm
//
//  Created by Chen Hsin Hsuan on 2015/6/30.
//  Copyright (c) 2015年 AirconTW. All rights reserved.
//

import UIKit

class EditReservePlayerViewController: SuperViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerNumberPickerView: UIPickerView!
    
    
    var fromViewController: UIViewController!
    var editPlayer:Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let orderFormViewController = fromViewController as? OrderFormViewController {
            if let indexPath = orderFormViewController.selectedIndexPath {
                self.editPlayer = orderFormViewController.reservePlayers[orderFormViewController.selectedIndexPath!.row]
                self.playerNameTextField.text = editPlayer?.name
                self.playerNumberPickerView.selectRow(self.editPlayer!.number!.toInt()!, inComponent: 0, animated: true)
            }
        }else if let playerListTableViewController = fromViewController as? PlayerListTableViewController {
            if let indexPath = playerListTableViewController.selectedIndexPath {
                self.editPlayer = playerListTableViewController.players[playerListTableViewController.selectedIndexPath!.row]
                self.playerNameTextField.text = editPlayer?.name
                self.playerNumberPickerView.selectRow(self.editPlayer!.number!.toInt()!, inComponent: 0, animated: true)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
     //MARK: IBAction
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let name = self.playerNameTextField.text
        var number = "\(self.playerNumberPickerView.selectedRowInComponent(0))"
        if count(number) == 1 {
            number = "0\(number)"
        }
        
        var thePlayer = Player(name: name, number: number, position: "")
        
        if let orderFormViewController = fromViewController as? OrderFormViewController {
            if orderFormViewController.selectedIndexPath != nil {
            orderFormViewController.reservePlayers[orderFormViewController.selectedIndexPath!.row] = thePlayer
                orderFormViewController.selectedIndexPath = nil
            }else{
                orderFormViewController.reservePlayers.append(thePlayer)
            }
            self.navigationController?.popToViewController(orderFormViewController, animated: true)
        }else if let playerListTableViewController = fromViewController as? PlayerListTableViewController {
            
            if playerListTableViewController.selectedIndexPath != nil {
                thePlayer = playerListTableViewController.players[playerListTableViewController.selectedIndexPath!.row]
                DB.executeUpdate("update T_PLAYER set name = ?, number = ? where id = ?;", withArgumentsInArray: [name, number, thePlayer.id!])
            }else{
                DB.executeUpdate("insert into T_PLAYER (name, number) values (?, ?);", withArgumentsInArray: [name, number])
            }
            self.navigationController?.popViewControllerAnimated(true)
        }

    }

    
    //MARK: PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var numberString = "\(row)"
        if count(numberString) == 1 {
            numberString = "0\(numberString)"
        }
        return numberString
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }

    //MARK: Gestrue
    @IBAction func tapGestrue(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    //MARK: TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    

}
