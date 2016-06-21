# DockServiceManager

This service allow a system administrator to remotely execute dockutil command via MDM.

The service run as a LaunchAgent and read its settings inside com.abelionni.DockServiceManager preference domain. The dockitems key in this preference domain contain an array of dictionary composed by keys used by dockutils.

The service run all commands and login and each time a changement is done. Currently, only MDM based update are catched. If you modify the settings with defaults it wont be seen by the service (but applied at the next login time if the settings are persistent).

# Note about the swift script based thing

For fun, this project as been written to be a swift script instead of python script or regular OS X app.

The best solution for the future would be to provide this service as a Cocoa app (written in any kind of language) since it will allow a better ressource manangement and would avoid any manual runloop management.

The current implementation has been made as a test, to see where we can go with swift based script in IT.
