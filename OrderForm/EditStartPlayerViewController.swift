//
//  EditStartPlayerViewController.swift
//  OrderForm
//
//  Created by Chen Hsin Hsuan on 2015/6/30.
//  Copyright (c) 2015年 AirconTW. All rights reserved.
//

import UIKit

class EditStartPlayerViewController: SuperViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerNumberPickerView: UIPickerView!
    @IBOutlet var positionButtons: [UIButton]!
    
    var orderFormViewController: OrderFormViewController!
    var editPlayer:Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationItem.title = "第\(self.orderFormViewController.selectedIndexPath!.row+1)棒"

        if let indexPath = self.orderFormViewController.selectedIndexPath {
            self.editPlayer = self.orderFormViewController.startPlayers[self.orderFormViewController.selectedIndexPath!.row]
            self.playerNameTextField.text = editPlayer?.name
            self.playerNumberPickerView.selectRow(indexPath.row, inComponent: 0, animated: true)
            for theButton in self.positionButtons {
                if theButton.titleLabel!.text == self.editPlayer?.position {
                    theButton.selected = true
                    break
                }
            }
        }
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
    @IBAction func positionButtonPressed(sender: UIButton) {
        for theButton in self.positionButtons {
            theButton.selected = false
        }
        sender.selected = true
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let name = self.playerNameTextField.text
        var number = "\(self.playerNumberPickerView.selectedRowInComponent(0))"
        if count(number) == 1 {
            number = "0\(number)"
        }
        var position = ""
        for theButton in self.positionButtons {
            if theButton.selected {
                position = theButton.titleLabel!.text!
                break
            }
        }
        
        let thePlayer = Player(name: name, number: number, position: position)
        
        self.orderFormViewController.startPlayers[self.orderFormViewController.selectedIndexPath!.row] = thePlayer
        self.orderFormViewController.selectedIndexPath = nil
        self.navigationController?.popToRootViewControllerAnimated(true)
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
