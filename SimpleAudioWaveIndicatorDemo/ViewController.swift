//
//  ViewController.swift
//  SimpleAudioWaveIndicatorDemo
//
//  Created by Lee Yen Lin on 2022/10/5.
//

import AVFAudio
import SimpleAudioWaveIndicator
import UIKit

class ViewController: UIViewController {
    @IBOutlet var audioWaveIndicator: SimpleAudioWaveIndicator!
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        /// put audio here
        let url = Bundle.main.url(forResource: "demo", withExtension: "m4a")!

        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.isMeteringEnabled = true
        } catch {
            print("Error:", error.localizedDescription)
        }
    }

    @IBAction func playStop(_: Any) {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0
            timer?.invalidate()
        } else {
            audioWaveIndicator.reset()
            timer = Timer.scheduledTimer(timeInterval: 1 / 60, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            audioPlayer?.play()
        }
    }

    @objc func timerAction() {
        if audioPlayer?.isPlaying == true{
            audioWaveIndicator.power = (audioPlayer?.averagePower(forChannel: 0) ?? 0)
            audioWaveIndicator.setNeedsDisplay()
            audioPlayer?.updateMeters()
        }else {
            timer?.invalidate()
        }
    }
}
