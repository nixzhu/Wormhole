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
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        println("viewWilDisappear")
    }
}

