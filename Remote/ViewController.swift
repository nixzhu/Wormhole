//
//  ViewController.swift
//  Remote
//
//  Created by NIX on 15/5/20.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import UIKit
import Wormhole
import RemoteKit

class ViewController: UIViewController {

    @IBOutlet weak var lightStateLabel: UILabel!
    @IBOutlet weak var lightStateLockButton: UIButton!

    @IBOutlet weak var lightLevelLabel: UILabel!

    let wormhole = Wormhole(appGroupIdentifier: Config.Wormhole.appGroupIdentifier, messageDirectoryName: Config.Wormhole.messageDirectoryName)

    var lightStateLocked = false {
        didSet {

            if lightStateLocked {
                lightStateLockButton.setTitle("Unlock", forState: .Normal)

                wormhole.removeListenerByName(Config.Wormhole.Listener.lightStateLabel, forMessageWithIdentifier: Config.Wormhole.Message.lightState)

            } else {
                lightStateLockButton.setTitle("Lock", forState: .Normal)

                wormhole.bindListener(lightStateListener, forMessageWithIdentifier: Config.Wormhole.Message.lightState)
            }

        }
    }

    lazy var lightStateListener: Wormhole.Listener = {
        let action: Wormhole.Listener.Action = { [unowned self] message in
            if let lightState = message as? NSNumber {
                self.lightStateLabel.text = lightState.boolValue ? "Light On" : "Light Off"
            }
        }

        let listener = Wormhole.Listener(name: Config.Wormhole.Listener.lightStateLabel, action: action)

        return listener
        }()

    lazy var lightLevelListener: Wormhole.Listener = {
        let action: Wormhole.Listener.Action = { [unowned self] message in
            if let lightLevel = message as? NSNumber {
                self.lightLevelLabel.text = "Level \(lightLevel.integerValue)"
            }
        }

        let listener = Wormhole.Listener(name: Config.Wormhole.Listener.lightLevelLabel, action: action)

        return listener
        }()

    override func viewDidLoad() {
        super.viewDidLoad()

        wormhole.bindListener(lightStateListener, forMessageWithIdentifier: Config.Wormhole.Message.lightState)

        wormhole.bindListener(lightLevelListener, forMessageWithIdentifier: Config.Wormhole.Message.lightLevel)
    }

    // MARK: Actions

    @IBAction func lockOrUnlockLightState(sender: UIButton) {
        lightStateLocked = !lightStateLocked
    }

}

