![Release](https://img.shields.io/github/release-date/allen870619/SimpleAudioWaveIndicator?color=blue)
![Lang](https://img.shields.io/badge/Lang-Swift-orange)
![LastCommit](https://img.shields.io/github/last-commit/allen870619/SimpleAudioWaveIndicator?style=flat)
![Release](https://img.shields.io/github/v/release/allen870619/SimpleAudioWaveIndicator)

# SimpleAudioWaveIndicator
A simple sound wave indicator by UIKit

![CleanShot 2022-10-05 at 14 33 34](https://user-images.githubusercontent.com/32888552/193996252-296292d7-1a7e-4a40-865d-50df8b2cb9dc.gif)

## Installation
Swift Package Manager
```
dependencies: [
    .package(url: "https://github.com/allen870619/SimpleAudioWaveIndicator.git", from: "version-tag")
]
```

## Usage
You can use with *AVFoundation's* player / record, then use Timer to catch voice power.

```
/// initial
audioPlayer = try AVAudioPlayer(contentsOf: url)
audioPlayer?.prepareToPlay()
audioPlayer?.isMeteringEnabled = true  // important!

/// Using timer to block player, and get the info you want
audioWaveIndicator.reset() // reset panel, clear all data

timer = Timer.scheduledTimer(timeInterval: 1 / 60,
                            target: self,
                            selector: #selector(timerAction),
                            userInfo: nil, repeats: true)
audioPlayer?.play()

/// Timer Action
audioWaveIndicator.power = (audioPlayer?.averagePower(forChannel: 0) ?? 0)
audioWaveIndicator.setNeedsDisplay() // repaint
audioPlayer?.updateMeters() 
  
```

## Configuration
```swift
/// Minimum Volumn
///
/// If lower than this, amplitude will be 0
var minDb: Float = 40 // acutally is -40
    
/// Sampling
///
/// Taking power between  N-1 power
///
/// v---------v---------v--......
/// If timer's interval id 1/60, you will have 60 power data in one sec.
/// Using sampling to reduce data (60 -> 6 while sampling is 10) amount,
/// or the indicator would move too fast.
var sampling: Int = 10
    
var showPercentage: CGFloat = 1 // amplitude of stroke (percentage of half height, 0~1)
var barSpacing = 8
var strokeColor: UIColor = .red
var strokeWidth: CGFloat = 2
```

## License

MIT.

## Author

[Allen Lee](https://github.com/allen870619)
