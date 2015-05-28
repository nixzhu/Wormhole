//
//  InterfaceController.swift
//  Remote WatchKit Extension
//
//  Created by NIX on 15/5/20.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import WatchKit
import Wormhole
import RemoteKit

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var lightStateSwitch: WKInterfaceSwitch!
    @IBOutlet weak var lightLevelSlider: WKInterfaceSlider!

    let wormhole = Wormhole(appGroupIdentifier: Config.Wormhole.appGroupIdentifier, messageDirectoryName: Config.Wormhole.messageDirectoryName)

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        super.willActivate()

        if let message = wormhole.messageWithIdentifier(Config.Wormhole.Message.lightState) {
            if let lightState = message as? NSNumber {
                lightStateSwitch.setOn(lightState.boolValue)
                self.lightState = lightState.boolValue
            }
        }

        if let message = wormhole.messageWithIdentifier(Config.Wormhole.Message.lightLevel) {
            if let lightLevel = message as? NSNumber {
                lightLevelSlider.setValue(lightLevel.floatValue)
                self.lightLevel = lightLevel.floatValue
            }
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    typealias LightState = Bool

    var lightState: LightState = false {
        didSet {
            wormhole.passMessage(NSNumber(bool: lightState), withIdentifier: Config.Wormhole.Message.lightState)
        }
    }

    var lightLevel: Float = 2 {
        didSet {
            wormhole.passMessage(NSNumber(float: lightLevel), withIdentifier: Config.Wormhole.Message.lightLevel)
        }
    }

    @IBAction func switchLight(value: Bool) {
        lightState = !lightState
    }

    @IBAction func changeLightLevels(value: Float) {
        lightLevel = value
    }
}
