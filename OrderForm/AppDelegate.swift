//
//  AppDelegate.swift
//  OrderForm
//
//  Created by Chen Hsin Hsuan on 2015/6/30.
//  Copyright (c) 2015年 AirconTW. All rights reserved.
//

import UIKit
import FMDB
import Fabric
import Crashlytics


let DBNAME = "orderform.sqlite"
let DB_FOLDER = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
let DB_PATH = DB_FOLDER.stringByAppendingPathComponent(DBNAME)
let DB = FMDatabase(path: DB_PATH)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        Fabric.with([Crashlytics()])

        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)

        //MARK:create player table
        if DB.open() {
            if !DB.executeUpdate("CREATE TABLE IF NOT EXISTS T_PLAYER (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, number text NOT NULL);", withArgumentsInArray: nil) {
                println("create table failed: \(DB.lastErrorMessage())")
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //MARK:FMDB
    func findPlayerList() -> [Player]{
        var players = [Player]()
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
                
                players.append(thePlayer)
            }
        } else {
            println("select failed: \(DB.lastErrorMessage())")
        }
        return players
    }

}

