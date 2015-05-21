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

    @IBOutlet weak var redCountLabel: UILabel!
    @IBOutlet weak var blueCountLabel: UILabel!

    let wormhole = Wormhole(appGroupIdentifier: "group.com.nixWork.Wormhole", messageDirectoryName: "Wormhole")

    lazy var redListener: Wormhole.Listener = {
        let action: Wormhole.Listener.Action = { [unowned self] message in
            if let tapCount = message as? NSNumber {
                self.redCountLabel.text = "\(tapCount.integerValue)"
            }
        }

        let listener = Wormhole.Listener(name: "redCountLabel", action: action)

        return listener
        }()

    lazy var blueListener: Wormhole.Listener = {
        let action: Wormhole.Listener.Action = { [unowned self] message in
            if let tapCount = message as? NSNumber {
                self.blueCountLabel.text = "\(tapCount.integerValue)"
            }
        }

        let listener = Wormhole.Listener(name: "blueCountLabel", action: action)

        return listener
        }()

    override func viewDidLoad() {
        super.viewDidLoad()

        wormhole.bindListener(redListener, forMessageWithIdentifier: "watchTap")

        wormhole.bindListener(blueListener, forMessageWithIdentifier: "watchTap")
    }

    @IBAction func stopAll(sender: UIButton) {
        wormhole.stopListeningForMessageWithIdentifier("watchTap")
    }

    @IBAction func unbind(sender: UIButton) {
        wormhole.unbindListener(blueListener, forMessageWithIdentifier: "watchTap")
    }

}
