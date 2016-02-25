#!/usr/bin/swift

// version 0.1

import Cocoa

var run = true
let preferenceDomain = "com.abelionni.DockServiceManager"
let defaults = NSUserDefaults(suiteName: preferenceDomain)



func handleSettingsUpdates() {
    print("Applying settings from " + preferenceDomain)
    
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
        let dockutil = NSTask.launchedTaskWithLaunchPath("/usr/local/DockServiceManager/dockutil", arguments: args)
        
        dockutil.waitUntilExit()
    }
}

NSDistributedNotificationCenter.defaultCenter().addObserverForName("com.apple.MCX._managementStatusChangedForDomains", object: "com.apple.MCX", queue: nil) { (note) -> Void in
    
    let potentialDomains = note.userInfo!["com.apple.MCX.changedDomains"] as? [String]
    
    if let domains = potentialDomains {
        if domains.contains("com.abelionni.DockServiceManager") {
            handleSettingsUpdates()
        }
    }
}

//NSNotificationCenter.defaultCenter().postNotificationName(NSUserDefaultsDidChangeNotification, object: nil)

let runLoop = NSRunLoop.currentRunLoop()
runLoop.run()

exit(0)
