# Wormhole

Wormhole is not just a Swift port of [MMWormhole](https://github.com/mutualmobile/MMWormhole) but with better API and use logic. You can remove any a listener from it separately.

## Example

In WatchKit extension, passing a message:

```Swift
import Wormhole

let wormhole = Wormhole(appGroupIdentifier: "group.com.nixWork.Wormhole", messageDirectoryName: "Wormhole")

wormhole.passMessage(NSNumber(bool: lightState), withIdentifier: "lightState")
```

In App, make a listener and listen a message:

```Swift
import Wormhole

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
     
wormhole.bindListener(lightStateListener, forMessageWithIdentifier: "lightState")
```

Now easy to remove a listener:

```Swift
wormhole.removeListener(lightStateListener, forMessageWithIdentifier: "lightState")
```
or

```Swift
wormhole.removeListenerByName("lightStateLabel", forMessageWithIdentifier: "lightState")
```

For more information, see the demo.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ [sudo] gem install cocoapods
```

To integrate Wormhole into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Wormhole', '~> 1.0'
```

Then, run the following command:

```bash
$ pod install
```

You should open the `{Project}.xcworkspace` instead of the `{Project}.xcodeproj` after you installed anything from CocoaPods.

For more information about how to use CocoaPods, I suggest [this tutorial](http://www.raywenderlich.com/64546/introduction-to-cocoapods-2).

## License

Wormhole is available under the MIT license. See the LICENSE file for more info.