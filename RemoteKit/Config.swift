//
//  Config.swift
//  Remote
//
//  Created by NIX on 15/5/27.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import Foundation

public struct Config {

    public struct Wormhole {
        public static let appGroupIdentifier = "group.com.nixWork.Wormhole"
        public static let messageDirectoryName = "Wormhole"

        public struct Message {
            public static let lightState = "lightState"
            public static let lightLevel = "lightLevel"
        }

        public struct Listener {
            public static let lightStateLabel = "lightStateLabel"
            public static let lightLevelLabel = "lightLevelLabel"
        }
    }

}