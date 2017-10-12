# Player App 
[![GitHub license](https://img.shields.io/badge/license-New%20BSD-blue.svg)](https://raw.githubusercontent.com/VictorNouvellet/Player/master/LICENCE) ![platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)

Listen easily to iTunes top songs.

This repository contains the source code for Player iOS app.

This app consists in:

 * Displaying 100 top songs
 * Searching for them
 * Listening to a preview of a selected song

## Installation Requirements

- [Xcode](https://developer.apple.com/xcode/)
- [Cocoapods](https://guides.cocoapods.org/using/getting-started.html) ≥1.2.0

## Installation

1. Clone or [download](https://github.com/VictorNouvellet/Player/archive/master.zip) project.
- From root project directory in Terminal (the one where Podfile file is), run `pod repo update` to update source repos and then run `pod install`. It will install needed pods.
- Run `open Player.xcworkspace` to open the project workspace in Xcode.
- Make sure your device is connected to your computer and Build & Run by using ⌘+R from Xcode.

## Authors
 * Victor Nouvellet - victor (dot) nouvellet (at) gmail (dot) com

## License
 * Player is released under a New BSD License. See LICENSE file for details.

## Related
 * This is the [SOUNDS](https://www.sounds.am/) [challenge](https://gist.github.com/matts2cant/a5dff9aa0528615505bb2bb6ec71877e).

## Todo
- Add player screen
- Use [affiliate documentation](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/#lookup) to search in iTunes database. [Example](https://itunes.apple.com/search?country=FR&entity=song&media=music&attribute=ratingIndex).
- Add icon
- Use cache
- Update README with icon
- Choose between the two top song URLs ([1](https://itunes.apple.com/fr/rss/topsongs/limit=100/json) or [2](https://rss.itunes.apple.com/api/v1/fr/apple-music/top-songs/all/100/explicit.json))
