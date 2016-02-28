#!/usr/bin/swift

import Foundation

let userInfo = ["com.apple.MCX.changedDomains": ["com.abelionni.DockServiceManager"]]

NSDistributedNotificationCenter.defaultCenter().postNotificationName("com.apple.MCX._managementStatusChangedForDomains", object: "com.apple.MCX", userInfo: userInfo) 

exit(0)
