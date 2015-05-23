# Wormhole

Wormhole is a Swift port of [MMWormhole](https://github.com/mutualmobile/MMWormhole) but with better API and use logic. You can remove any a listener from it separately.

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

## License

Wormhole is available under the MIT license. See the LICENSE file for more info.