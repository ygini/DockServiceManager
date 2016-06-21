//
//  AppDelegate.swift
//  DockServiceManager
//
//  Created by Yoann Gini on 21/06/2016.
//  Copyright © 2016 Yoann Gini. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    var previousDockItems: [[String:String]]?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        NSDistributedNotificationCenter.defaultCenter().addObserverForName("com.apple.MCX._managementStatusChangedForDomains", object: "com.apple.MCX", queue: nil) { (note) -> Void in
            note.userInfo
            guard let bundleID = NSBundle.mainBundle().bundleIdentifier else { return }
            guard let domains = note.userInfo?["com.apple.MCX.changedDomains"] as? [String] else { return }
            if domains.contains(bundleID) {
                self.handleSettingsUpdates()
            }
        }
        
        self.handleSettingsUpdates()
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func handleSettingsUpdates() {
        guard let dockitems = NSUserDefaults.standardUserDefaults().arrayForKey("dockitems") as? [[String:String]] else {
            return
        }
        
        
        if let previousDockItems = previousDockItems {
            if dockitems == previousDockItems {
                return
            }
        }
        
        for item in dockitems {
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
            
            guard let dockutil = NSBundle.mainBundle().pathForResource("dockutil", ofType: nil) else {
                return
            }
            
            let dockutilTask = NSTask.launchedTaskWithLaunchPath(dockutil, arguments: args)
            
            dockutilTask.waitUntilExit()
        }
        
        previousDockItems = dockitems
        
    }
    
}

