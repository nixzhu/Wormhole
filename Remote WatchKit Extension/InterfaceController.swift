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

    @IBOutlet weak var lightStateSwitch: WKInterfaceSwitch!
    @IBOutlet weak var lightLevelsSlider: WKInterfaceSlider!

    let wormhole = Wormhole(appGroupIdentifier: "group.com.nixWork.Wormhole", messageDirectoryName: "Wormhole")

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        super.willActivate()

        if let message = wormhole.messageFromFileWithIdentifier("lightState") {
            if let lightState = message as? NSNumber {
                lightStateSwitch.setOn(lightState.boolValue)
            }
        }

        if let message = wormhole.messageFromFileWithIdentifier("lightLevels") {
            if let lightLevels = message as? NSNumber {
                lightLevelsSlider.setValue(lightLevels.floatValue)
            }
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    typealias LightState = Bool

    var lightState: LightState = false {
        didSet {
            wormhole.passMessage(NSNumber(bool: lightState), withIdentifier: "lightState")
        }
    }

    var lightLevels: Float = 2 {
        didSet {
            wormhole.passMessage(NSNumber(float: lightLevels), withIdentifier: "lightLevels")
        }
    }

    @IBAction func switchLight(value: Bool) {
        lightState = value
    }

    @IBAction func changeLightLevels(value: Float) {
        println(value)
        lightLevels = value
    }
}
