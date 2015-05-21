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
    @IBOutlet weak var countLabel: UILabel!

    let wormhole = Wormhole(appGroupIdentifier: "group.com.nixWork.Wormhole", messageDirectoryName: "Wormhole")

    override func viewDidLoad() {
        super.viewDidLoad()

        let listener: Wormhole.Listener = { [unowned self] message in
            if let tapCount = message as? NSNumber {
                self.countLabel.text = "\(tapCount.integerValue)"
            }
        }

        wormhole.bindListener(listener, forMessageWithIdentifier: "watchTap")

        let listener2: Wormhole.Listener = { [unowned self] message in
            if let tapCount = message as? NSNumber {
                self.redCountLabel.text = "\(tapCount.integerValue)"
            }
        }

        wormhole.bindListener(listener2, forMessageWithIdentifier: "watchTap")
    }

    @IBAction func stop(sender: UIButton) {
        wormhole.stopListeningForMessageWithIdentifier("watchTap")
    }
}
