#!/bin/bash

# Update Homebrew
brew update

# Check for SwiftLint install
VERSIONS=`brew ls --versions swiftlint`
if [[ -z $VERSIONS ]]; then
  echo 'SwiftLint not installed. Installing.'
	brew install swiftlint
else
  echo 'SwiftLint installed. Upgrading if neccessary.'
	brew outdated swiftlint || brew upgrade swiftlint
fi
