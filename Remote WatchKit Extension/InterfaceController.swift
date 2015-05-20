//
//  InterfaceController.swift
//  Remote WatchKit Extension
//
//  Created by NIX on 15/5/20.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import WatchKit
import Foundation
import Wormhole

class InterfaceController: WKInterfaceController {

    let wormhole = Wormhole(appGroupIdentifier: "group.com.nixWork.Wormhole", messageDirectoryName: "Wormhole")

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    var tapCount = 0

    @IBAction func tap() {
        wormhole.passMessage(NSNumber(integer: ++tapCount), withIdentifier: "watchTap")
    }
}
