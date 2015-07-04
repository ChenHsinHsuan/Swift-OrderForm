//
//  MainViewController.swift
//  OrderForm
//
//  Created by Chen Hsin Hsuan on 2015/7/2.
//  Copyright (c) 2015年 AirconTW. All rights reserved.
//

import UIKit
import GoogleMobileAds


let shareAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let PAGE_ADUNIT_ID = "ca-app-pub-5200673733349176/7626862844"
class MainViewController: SuperViewController {

    var theGADInterstitial = GADInterstitial(adUnitID: PAGE_ADUNIT_ID)
    let request = GADRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //廣告設定
        request.testDevices = [
            "ffd5b4c17425a518e4f9c99b1738ae16" //AirPhone
        ];
        theGADInterstitial.loadRequest(request)
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

    @IBAction func sponseButtonPressed(sender: AnyObject) {
        //準備廣告
        if (theGADInterstitial.isReady) {
            theGADInterstitial.presentFromRootViewController(self)
        }else{
            theGADInterstitial = GADInterstitial(adUnitID: PAGE_ADUNIT_ID)
            theGADInterstitial.loadRequest(request)
            if (theGADInterstitial.isReady) {
                theGADInterstitial.presentFromRootViewController(self)
            }
        }
    }
}
