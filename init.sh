#!/bin/sh

# Some things taken from here
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx

pretty_print() {
  printf "\n%b\n" "$1"
}

pretty_print "setting up your dev environment like a boss..."

# Set continue to false by default
CONTINUE=false

echo ""
pretty_print "###############################################"
pretty_print "#        DO NOT RUN THIS SCRIPT BLINDLY       #"
pretty_print "#         YOU'LL PROBABLY REGRET IT...        #"
pretty_print "#                                             #"
pretty_print "#              READ IT THOROUGHLY             #"
pretty_print "#         AND EDIT TO SUIT YOUR NEEDS         #"
pretty_print "###############################################"
echo ""

echo ""
pretty_print "Have you read through the script you're about to run and "
pretty_print "understood that it will make changes to your computer? (y/n)"
read -r response
case $response in
  [yY]) CONTINUE=true
      break;;
  *) break;;
esac

if ! $CONTINUE; then
  # Check if we're continuing and output a message if not
  pretty_print "Please go read the script, it only takes a few minutes"
  exit
fi

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


###############################################################################
# General UI/UX
###############################################################################

echo ""
echo "Would you like to set your computer name (as done via System Preferences >> Sharing)?  (y/n)"
read -r response
case $response in
  [yY])
      echo "What would you like it to be?"
      read COMPUTER_NAME
      sudo scutil --set ComputerName $COMPUTER_NAME
      sudo scutil --set HostName $COMPUTER_NAME
      sudo scutil --set LocalHostName $COMPUTER_NAME
      sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME
      break;;
  *) break;;
esac

# Always show scrollbars
echo ""
echo "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

echo ""
echo "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1



################################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
echo ""
echo "Enable trackpad tap to click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo ""
echo "Increasing sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40


###############################################################################
# Finder
###############################################################################

echo ""
echo "Show hidden files in Finder by default? (y/n)"
read -r response
case $response in
  [yY])
    defaults write com.apple.Finder AppleShowAllFiles -bool true
    break;;
  *) break;;
esac

echo ""
echo "Show dotfiles in Finder by default? (y/n)"
read -r response
case $response in
  [yY])
    defaults write com.apple.finder AppleShowAllFiles TRUE
    break;;
  *) break;;
esac

echo ""
echo "Show all filename extensions in Finder by default? (y/n)"
read -r response
case $response in
  [yY])
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    break;;
  *) break;;
esac

echo ""
echo "Use column view in all Finder windows by default? (y/n)"
read -r response
case $response in
  [yY])
    defaults write com.apple.finder FXPreferredViewStyle Clmv
    break;;
  *) break;;
esac

echo ""
echo "Avoid creation of .DS_Store files on network volumes? (y/n)"
read -r response
case $response in
  [yY])
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    break;;
  *) break;;
esac


echo ""
echo "Allowing text selection in Quick Look/Preview in Finder by default"
defaults write com.apple.finder QLEnableTextSelection -bool true


echo ""
echo "Enabling snap-to-grid for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist


echo ""
echo "Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo ""
echo "Adding a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true


# Use current directory as default search scope in Finder
echo ""
echo "Use current directory as default search scope in Finder"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show Path bar in Finder
echo ""
echo "Show Path bar in Finder"
defaults write com.apple.finder ShowPathbar -bool true

# Show Status bar in Finder
echo ""
echo "Show Status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool true

# Show indicator lights for open applications in the Dock
echo ""
echo "Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

# Remove the auto-hiding Dock delay
echo ""
echo "Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

# Set a blazingly fast keyboard repeat rate
echo ""
echo "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1

# Set a shorter Delay until key repeat
echo ""
echo "Set a shorter Delay until key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 12

# Show the ~/Library folder
echo ""
echo "Show the ~/Library folder"
chflags nohidden ~/Library


###############################################################################
# Mail
###############################################################################

echo ""
echo "Setting email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

###############################################################################
# Terminal
###############################################################################

echo ""
echo "Enabling UTF-8 ONLY in Terminal.app and setting the Pro theme by default"
defaults write com.apple.terminal StringEncodings -array 4
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"

###############################################################################
# Time Machine
###############################################################################

echo ""
echo "Prevent Time Machine from prompting to use new hard drives as backup volume? (y/n)"
read -r response
case $response in
  [yY])
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
    break;;
  *) break;;
esac

###############################################################################
# Transmission.app                                                            #
###############################################################################

echo ""
echo "Do you use Transmission for torrenting? (y/n)"
read -r response
case $response in
  [yY])
    echo ""
    echo "Use `~/Downloads/Incomplete` to store incomplete downloads"
    defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
    mkdir -p ~/Downloads/Incomplete
    defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Incomplete"

    echo ""
    echo "Don't prompt for confirmation before downloading"
    defaults write org.m0k.transmission DownloadAsk -bool false

    echo ""
    echo "Trash original torrent files"
    defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

    echo ""
    echo "Hide the donate message"
    defaults write org.m0k.transmission WarningDonate -bool false

    echo ""
    echo "Hide the legal disclaimer"
    defaults write org.m0k.transmission WarningLegal -bool false
    break;;
  *) break;;
esac

###############################################################################
# Sublime Text
###############################################################################

echo ""
echo "Do you use Sublime Text 3 as your editor of choice, and is it installed?"
read -r response
case $response in
  [yY])
    # Installing from homebrew cask does the following for you!
    # echo ""
    # echo "Linking Sublime Text for command line usage as subl"
    # ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl

    echo ""
    echo "Setting Git to use Sublime Text as default editor"
    git config --global core.editor "subl -n -w"
    break;;
  *) break;;
esac

###############################################################################
# Xcode Dev Tools
###############################################################################

pretty_print "Installing xcode dev tools..."
xcode-select --install

###############################################################################
# Homebrew
###############################################################################

if ! command -v brew &>/dev/null; then
  pretty_print "Installing Homebrew, an OSX package manager, follow the instructions..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  if ! grep -qs "recommended by brew doctor" ~/.zshrc; then
    pretty_print "Put Homebrew location earlier in PATH ..."
      printf '\n# recommended by brew doctor\n' >> ~/.zshrc
      printf 'export PATH="/usr/local/bin:$PATH"\n' >> ~/.zshrc
      export PATH="/usr/local/bin:$PATH"
  fi
else
  pretty_print "You already have Homebrew installed...good job!"
fi

# Git installation
pretty_print "Installing git for control version"
brew install git

# Image magick installation
pretty_print "Installing image magick for image processing"
brew install imagemagick

# Heroku Toolbelt
pretty_print "Installing the heroku toolbelt..."
brew install heroku-toolbelt

# Pow installation
pretty_print "Installing pow to serve local rails apps like a superhero..."
curl get.pow.cx | sh

# Node installation
pretty_print "Installing NodeJs..."
brew install node

# Install brew cask
pretty_print "Installing Cask to install apps"
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

pretty_print "Installing Launchrocket to manage your Homebrew formulas like a champ!"
brew cask install launchrocket

###############################################################################
# Node Modules
###############################################################################

# Bower installation
pretty_print "Installing Bower..."
npm install -g bower

# Gulp installation
pretty_print "Installing Gulp..."
npm install -g gulp

# Harp installation
pretty_print "Installing Harp..."
npm install -g harp

# Roots.cx installation
pretty_print "Installing Roots.cx..."
npm install -g roots

# Yeoman installation
pretty_print "Installing Yeoman..."
npm install -g yo

# Gulp Angular installation
pretty_print "Installing Yeoman Gulp Angular Generator..."
npm install -g generator-gulp-angular

# SVGO installation
pretty_print "Installing SVGO..."
npm install -g svgo

# Localtunnel installation
pretty_print "Installing Localtunnel..."
npm install -g localtunnel

###############################################################################
# Application Installation
###############################################################################

# Install apps to /Applications
# Default is: /Users/$user/Applications
# Uncomment next two lines to install
# pretty_print "Installing apps..."
# sh apps.sh

###############################################################################
# Fonts Installation
###############################################################################

# Uncomment next two lines to install
# pretty_print "Installing fonts..."
# sh fonts.sh

###############################################################################
# Wrap-up
###############################################################################

# When done with cask
brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup

# Install Mackup
pretty_print "Installing Mackup..."
brew install mackup

# Launch it and back up your files
# Uncomment next two lines to backup files
# pretty_print "Running Mackup Backup..."
# mackup backup

###############################################################################
# Kill affected applications
###############################################################################

echo ""
pretty_print "Shits Done Bro! You still need to manually install pacakge installer within sublime, setup your hosts, httpd.conf and vhosts files, download chrome extensions, setup your hotspots/mouse settings, and setup your git shit - look at readme for more info."
echo ""
echo ""
pretty_print "################################################################################"
echo ""
echo ""
pretty_print "Note that some of these changes require a logout/restart to take effect."
pretty_print "Killing some open applications in order to take effect."
echo ""

find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
  "Terminal" "Transmission"; do
  killall "${app}" > /dev/null 2>&1
done