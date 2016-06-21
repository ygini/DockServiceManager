# DockServiceManager

This service allows a system administrator to remotely execute dockutil command via MDM.

The service runs as a LaunchAgent and read its settings inside com.github.ygini.DockServiceManager preference domain. The dockitems key in this preference domain contain an array of dictionaries composed by keys used by dockutils.

The service runs all commands at login and each time a change is made. Currently, only MDM based update are caught. If you modify the settings with defaults, it won’t be seen by the service (but applied at the next login time if the settings are persistent).

10.9 or better is needed for this tool since it's written in Swift (not sure if it's a good idea but we will see).

When using add verbs with dockutil, DockServiceManager allow you to specify full path for app or app BundleID. If you use BundleID, it will use NSWorkspace API to find the best candidate.

# Sample settings

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>dockitems</key>
	<array>
		<dict>
			<key>add</key>
			<string>com.microsoft.Outlook</string>
			<key>position</key>
			<string>end</string>
		</dict>
		<dict>
			<key>add</key>
			<string>/Applications/Managed Software Center.app</string>
			<key>position</key>
			<string>beginning</string>
		</dict>
	</array>
</dict>
</plist>
```
