//
//  Wormhole.swift
//  Remote
//
//  Created by NIX on 15/5/20.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import Foundation

func ==(lhs: Wormhole.MessageListener, rhs: Wormhole.MessageListener) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public class Wormhole: NSObject {

    let appGroupIdentifier: String
    let messageDirectoryName: String

    public init(appGroupIdentifier: String, messageDirectoryName: String) {

        self.appGroupIdentifier = appGroupIdentifier

        if messageDirectoryName.isEmpty {
            fatalError("ERROR: Wormhole need a message passing directory")
        }

        self.messageDirectoryName = messageDirectoryName
    }

    deinit {
        if let center = CFNotificationCenterGetDarwinNotifyCenter() {
            CFNotificationCenterRemoveEveryObserver(center, Unmanaged.passUnretained(self).toOpaque())
        }
    }

    public typealias Message = NSCoding

    public func passMessage(message: Message?, withIdentifier identifier: String) {

        if identifier.isEmpty {
            fatalError("ERROR: Message need identifier")
        }

        if let message = message {
            var success = false

            if let filePath = filePathForIdentifier(identifier: identifier) {
                let url = URL(fileURLWithPath: filePath)
                
                let data = NSKeyedArchiver.archivedData(withRootObject: message)
                do {
                    try data.write(to: url, options: .atomic)
                    success = true
                } catch {
                    success = false
                }
            }

            if success {
                if let center = CFNotificationCenterGetDarwinNotifyCenter() {
                    CFNotificationCenterPostNotification(center, CFNotificationName(rawValue: identifier as CFString), nil, nil, true)
                }
            }

        } else {
            if let center = CFNotificationCenterGetDarwinNotifyCenter() {
                CFNotificationCenterPostNotification(center, CFNotificationName(rawValue: identifier as CFString), nil, nil, true)
            }
        }
    }

    public struct Listener {

        public typealias Action = (Message?) -> Void

        let name: String
        let action: Action

        public init(name: String, action: @escaping Action) {
            self.name = name
            self.action = action
        }
    }

    struct MessageListener: Hashable {

        let messageIdentifier: String
        let listener: Listener

        var hashValue: Int {
            return (messageIdentifier + "<nixzhu.Wormhole>" + listener.name).hashValue
        }
    }

    var messageListenerSet = Set<MessageListener>()

    public func bindListener(listener: Listener, forMessageWithIdentifier identifier: String) {

        if let center = CFNotificationCenterGetDarwinNotifyCenter() {

            let messageListener = MessageListener(messageIdentifier: identifier, listener: listener)
            messageListenerSet.insert(messageListener)

            let block: (CFNotificationCenter?, UnsafeMutableRawPointer, CFString?, UnsafeRawPointer, CFDictionary?) -> Void = { _, _, _, _, _ in

                if self.messageListenerSet.contains(messageListener) {
                    messageListener.listener.action(self.messageWithIdentifier(identifier: identifier))
                }
            }

            let imp: OpaquePointer = imp_implementationWithBlock(unsafeBitCast(block, to: AnyObject.self))
            let callBack: CFNotificationCallback = unsafeBitCast(imp, to: CFNotificationCallback.self)

            CFNotificationCenterAddObserver(center, Unmanaged.passUnretained(self).toOpaque(), callBack, identifier as CFString, nil, .deliverImmediately)

            // Try fire Listener's action for first time
            listener.action(messageWithIdentifier(identifier: identifier))
        }
    }

    public func removeListener(listener: Listener, forMessageWithIdentifier identifier: String) {

        let messageListener = MessageListener(messageIdentifier: identifier, listener: listener)
        messageListenerSet.remove(messageListener)
    }

    public func removeListenerByName(name: String, forMessageWithIdentifier identifier: String) {

        for messageListener in messageListenerSet {
            if messageListener.messageIdentifier == identifier && messageListener.listener.name == name {
                messageListenerSet.remove(messageListener)

                break
            }
        }
    }

    public func removeAllListenersForMessageWithIdentifier(identifier: String) {

        if let center = CFNotificationCenterGetDarwinNotifyCenter() {
            CFNotificationCenterRemoveObserver(center, Unmanaged.passUnretained(self).toOpaque(), CFNotificationName(identifier as CFString), nil)

            for listener in messageListenerSet {
                if listener.messageIdentifier == identifier {
                    messageListenerSet.remove(listener)
                }
            }
        }
    }

    public func messageWithIdentifier(identifier: String) -> Message? {
        
        if let
            filePath = filePathForIdentifier(identifier: identifier),
            let data = NSData(contentsOfFile: filePath),
            let message = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? Message {
                return message
        }

        return nil
    }

    public func destroyMessageWithIdentifier(identifier: String) {

        if let filePath = filePathForIdentifier(identifier: identifier) {
            let fileManager = FileManager.default
            try? fileManager.removeItem(atPath: filePath)
        }
    }

    public func destroyAllMessages() {

        if let directoryPath = messagePassingDirectoryPath() as NSString? {

            let fileManager = FileManager.default

            if let fileNames = try? fileManager.contentsOfDirectory(atPath: directoryPath as String) {
                for fileName in fileNames {
                    let filePath = directoryPath.appendingPathComponent(fileName)
                    try? fileManager.removeItem(atPath: filePath)
                }
            }
        }
    }

    // MARK: Helpers

    func filePathForIdentifier(identifier: String) -> String? {

        if identifier.isEmpty {
            return nil
        }

        if let directoryPath = messagePassingDirectoryPath() as NSString? {
            let fileName = identifier + ".archive"
            let filePath = directoryPath.appendingPathComponent(fileName)

            return filePath
        }

        return nil
    }

    func messagePassingDirectoryPath() -> String? {

        let fileManager = FileManager.default

        if let appGroupContainer = fileManager.containerURL(forSecurityApplicationGroupIdentifier: self.appGroupIdentifier) {
            let appGroupContainerPath = appGroupContainer.path as NSString
            let directoryPath = appGroupContainerPath.appendingPathComponent(messageDirectoryName)
            
            try? fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)

            return directoryPath
        }

        return nil
    }

}
