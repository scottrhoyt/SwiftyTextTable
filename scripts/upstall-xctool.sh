#!/bin/bash

# Update Homebrew
brew update

# Check for SwiftLint install
VERSIONS=`brew ls --versions xctool`
if [[ -z $VERSIONS ]]; then
  echo 'xctool not installed. Installing.'
	brew install xctool
else
  echo 'xctool installed. Upgrading if neccessary.'
	brew outdated xctool || brew upgrade xctool
fi
