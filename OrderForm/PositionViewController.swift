//
//  PositionViewController.swift
//  OrderForm
//
//  Created by Chen Hsin Hsuan on 2015/7/2.
//  Copyright (c) 2015年 AirconTW. All rights reserved.
//

import UIKit

class PositionViewController: SuperViewController {

    var orderFormViewController:OrderFormViewController!
    
    
    @IBOutlet weak var CFLabel: UILabel!
    @IBOutlet weak var LFLabel: UILabel!
    @IBOutlet weak var RFLabel: UILabel!
    @IBOutlet weak var SFLabel: UILabel!
    @IBOutlet weak var B1Label: UILabel!
    @IBOutlet weak var B2Label: UILabel!
    @IBOutlet weak var SSLabel: UILabel!
    @IBOutlet weak var B3Label: UILabel!
    @IBOutlet weak var DHLabel: UILabel!
    @IBOutlet weak var PLabel: UILabel!
    @IBOutlet weak var CLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        for thePlayer in self.orderFormViewController.startPlayers {
            switch thePlayer.position ?? ""  {
            case "P":
                PLabel.text = thePlayer.number!+" "+thePlayer.name!
            case "C":
                CLabel.text = thePlayer.number!+" "+thePlayer.name!
            case "1B":
                B1Label.text = thePlayer.number!+" "+thePlayer.name!
            case "2B":
                B2Label.text = thePlayer.number!+" "+thePlayer.name!
            case "3B":
                B3Label.text = thePlayer.number!+" "+thePlayer.name!
            case "SS":
                SSLabel.text = thePlayer.number!+" "+thePlayer.name!
            case "SF":
                SFLabel.text = thePlayer.number!+" "+thePlayer.name!
            case "LF":
                LFLabel.text = thePlayer.number!+" "+thePlayer.name!
            case "CF":
                CFLabel.text = thePlayer.number!+" "+thePlayer.name!
            case "RF":
                RFLabel.text = thePlayer.number!+" "+thePlayer.name!
            case "DH":
                DHLabel.text = thePlayer.number!+" "+thePlayer.name!
            default:
                println("no match position")
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

}
