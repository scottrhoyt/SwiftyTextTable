#!/bin/bash

# Update Homebrew
brew update

# Check for SwiftLint install
VERSIONS=`brew ls --versions carthage`
if [[ -z $VERSIONS ]]; then
  echo 'Carthage not installed. Installing.'
	brew install carthage
else
  echo 'Carthage installed. Upgrading if neccessary.'
	brew outdated carthage || brew upgrade carthage
fi
