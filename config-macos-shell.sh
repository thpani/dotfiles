#!/bin/bash
# Remove all apps from the Dock and keep only ~/Downloads on the right side
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array \
  "<dict>
    <key>tile-type</key><string>directory-tile</string>
    <key>tile-data</key><dict>
      <key>file-data</key><dict>
        <key>_CFURLString</key><string>file://$HOME/Downloads/</string>
        <key>_CFURLStringType</key><integer>15</integer>
      </dict>
      <key>file-label</key><string>Downloads</string>
      <key>arrangement</key><integer>2</integer>
      <key>displayas</key><integer>0</integer>
      <key>showas</key><integer>1</integer>
    </dict>
  </dict>"

# Auto-hide the Dock and set icon size
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 38

killall Dock

# Hide widgets on the desktop (System Settings > Desktop & Dock > Show Widgets)
defaults write com.apple.WindowManager StandardHideWidgets -int 1
defaults write com.apple.WindowManager StageManagerHideWidgets -int 1
killall WindowManager
