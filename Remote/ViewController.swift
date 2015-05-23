//
//  ViewController.swift
//  Remote
//
//  Created by NIX on 15/5/20.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import UIKit
import Wormhole

class ViewController: UIViewController {

    @IBOutlet weak var lightStateLabel: UILabel!
    @IBOutlet weak var lightLevelsLabel: UILabel!

    let wormhole = Wormhole(appGroupIdentifier: "group.com.nixWork.Wormhole", messageDirectoryName: "Wormhole")

    lazy var lightStateListener: Wormhole.Listener = {
        let action: Wormhole.Listener.Action = { [unowned self] message in
            if let lightState = message as? NSNumber {
                self.lightStateLabel.text = lightState.boolValue ? "Light On" : "Light Off"
            }
        }

        let listener = Wormhole.Listener(name: "lightStateLabel", action: action)

        return listener
        }()

    lazy var lightLevelsListener: Wormhole.Listener = {
        let action: Wormhole.Listener.Action = { [unowned self] message in
            if let lightLevels = message as? NSNumber {
                self.lightLevelsLabel.text = "Level \(lightLevels.integerValue)"
            }
        }

        let listener = Wormhole.Listener(name: "lightLevelsLabel", action: action)

        return listener
        }()

    override func viewDidLoad() {
        super.viewDidLoad()

        wormhole.bindListener(lightStateListener, forMessageWithIdentifier: "lightState")

        wormhole.bindListener(lightLevelsListener, forMessageWithIdentifier: "lightLevels")
    }
}
