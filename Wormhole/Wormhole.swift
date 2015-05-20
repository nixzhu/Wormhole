//
//  Wormhole.swift
//  Remote
//
//  Created by NIX on 15/5/20.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import Foundation

public class Wormhole: NSObject {
    let appGroupIdentifier: String
    let messageDirectoryName: String?

    struct Notification {
        static let Message = "WormholeMessageNotification"
    }

    public init(appGroupIdentifier: String, messageDirectoryName: String?) {
        self.appGroupIdentifier = appGroupIdentifier
        self.messageDirectoryName = messageDirectoryName

        super.init()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveMessageNotification:", name: Notification.Message, object: nil)
    }

    deinit {
        if let center = CFNotificationCenterGetDarwinNotifyCenter() {
            CFNotificationCenterRemoveEveryObserver(center, unsafeAddressOf(self))
        }

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


    public typealias Message = NSCoding

    public func passMessage(message: Message, withIdentifier identifier: String) {
        writeMessage(message, withIdentifier: identifier)
    }

    public typealias Listener = Message -> Void

    var listeners = [Listener]()

    public func bindListener(listener: Listener, forMessageWithIdentifier identifier: String) {
        if let center = CFNotificationCenterGetDarwinNotifyCenter() {

            let block: @objc_block (CFNotificationCenter!, UnsafeMutablePointer<Void>, CFString!, UnsafePointer<Void>, CFDictionary!) -> Void = { center, observer, name, object, userInfo in

                NSNotificationCenter.defaultCenter().postNotificationName(Notification.Message, object: nil, userInfo: ["identifier": identifier])
            }

            let imp: COpaquePointer = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
            let callBack: CFNotificationCallback = unsafeBitCast(imp, CFNotificationCallback.self)

            CFNotificationCenterAddObserver(center, unsafeAddressOf(self), callBack, identifier, nil, CFNotificationSuspensionBehavior.DeliverImmediately)

            listeners.append(listener)

            println("listeners \(listeners.count)")
        }
    }

    // in

    func writeMessage(message: Message, withIdentifier identifier: String) {

        var success = false

        if let filePath = filePathForIdentifier(identifier) {
            let data = NSKeyedArchiver.archivedDataWithRootObject(message)
            success = data.writeToFile(filePath, atomically: true)
        }

        if success {
            notifyForMessageWithIdentifier(identifier)
        }
    }

    func filePathForIdentifier(identifier: String) -> String? {
        if identifier.isEmpty {
            return nil
        }

        if let directoryPath = messagePassingDirectoryPath() {
            let fileName = identifier + ".archive"
            let filePath = directoryPath.stringByAppendingPathComponent(fileName)

            return filePath
        }

        return nil
    }

    func messagePassingDirectoryPath() -> String? {

        let fileManager = NSFileManager.defaultManager()

        if let
            appGroupContainer = fileManager.containerURLForSecurityApplicationGroupIdentifier(self.appGroupIdentifier),
            appGroupContainerPath = appGroupContainer.path {
                var directoryPath = appGroupContainerPath
                if let messageDirectoryName = messageDirectoryName {
                    directoryPath = directoryPath.stringByAppendingPathComponent(messageDirectoryName)
                }

                fileManager.createDirectoryAtPath(directoryPath, withIntermediateDirectories: true, attributes: nil, error: nil)

                return directoryPath
        }

        return nil
    }

    func messageFromFileWithIdentifier(identifier: String) -> Message? {
        if let
            filePath = filePathForIdentifier(identifier),
            data = NSData(contentsOfFile: filePath),
            message = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Message {
                return message
        }

        return nil
    }

    func notifyForMessageWithIdentifier(identifier: String) {
        if let center = CFNotificationCenterGetDarwinNotifyCenter() {
            CFNotificationCenterPostNotification(center, identifier, nil, nil, 1)
        }
    }

    // MARK: NSNotification

    func didReceiveMessageNotification(notification: NSNotification) {
        if let
            userInfo = notification.userInfo as? [String: String],
            identifier = userInfo["identifier"] {

                for listener in listeners {
                    if let message = messageFromFileWithIdentifier(identifier) {
                        listener(message)
                    }
                }
        }
    }
}


