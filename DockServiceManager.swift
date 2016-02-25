#!/usr/bin/swift

// version 1.0

import Cocoa

let preferenceDomain = "com.abelionni.DockServiceManager"

NSNotificationCenter.defaultCenter().addObserverForName(NSUserDefaultsDidChangeNotification, object: nil, queue: nil) { (notification) -> Void in
    print("Applying settings from " + preferenceDomain)
    
    let defaults = NSUserDefaults(suiteName: preferenceDomain)
    
    for item in (defaults?.arrayForKey("dockitems") as? [[String:String]])! {
        var args = [String]()
        
        for key in item.keys {
            var potentialValue = item[key]
            
            if var value = potentialValue {
                if key == "add" {
                    if !value.containsString("/")
                        && value.containsString(".") {
                            potentialValue = NSWorkspace.sharedWorkspace().absolutePathForAppBundleWithIdentifier(value)
                            if (potentialValue != nil) {
                                value = potentialValue!
                            }
                    }
                }
                
                args.append("--"+key)
                args.append(value)
            }
        }
        
        print("Running dockutil with ", args)
        var dockutil = NSTask.launchedTaskWithLaunchPath("/usr/local/DockServiceManager/dockutil", arguments: args)
        
        dockutil.waitUntilExit()
    }
}

NSNotificationCenter.defaultCenter().postNotificationName(NSUserDefaultsDidChangeNotification, object: nil)

let runLoop = NSRunLoop.currentRunLoop()
runLoop.run()

exit(0)
