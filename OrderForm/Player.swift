//
//  Player.swift
//  OrderForm
//
//  Created by Chen Hsin Hsuan on 2015/6/30.
//  Copyright (c) 2015年 AirconTW. All rights reserved.
//

import UIKit

class Player: NSObject {
    var name:String?
    var number:String?
    var position:String?

    
    init(name:String?, number:String, position:String){
        self.name = name
        self.number = number
        self.position = position
    }
}
