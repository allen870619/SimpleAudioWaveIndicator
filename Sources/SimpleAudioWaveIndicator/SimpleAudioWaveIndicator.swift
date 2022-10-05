//
//  SimpleAudioWaveIndicator.swift
//
//
//  Created by Lee Yen Lin on 2022/10/5.
//

import UIKit

public class SimpleAudioWaveIndicator: UIView {
    /* style*/
    public var minDb: Float = 40 // acutally is -40
    public var barSpacing = 8
    public var sampling: Int = 10 // take one datum from N data each period
    public var strokeColor: UIColor = .red
    public var strokeWidth: CGFloat = 2
    public var showPercentage: CGFloat = 1 // amplitude of stroke (percentage of half height)

    /* data*/
    private var powerStack = [Float]()
    private var timeCounter = 0
    
    /// averagePower recommanded
    public var power: Float = 40 {
        didSet {
            var p = abs(power)
            if p > minDb {
                p = minDb
            }
            if timeCounter % sampling == 0 {
                powerStack.append(p)
                if powerStack.count > 200 {
                    powerStack.removeFirst()
                }
            }
        }
    }

    override public func draw(_: CGRect) {
        let path = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = strokeWidth
        strokeColor.set()

        let center = bounds.height / 2
        var index = powerStack.count - 1
        var startX = frame.width - 1 - (CGFloat(barSpacing * timeCounter) / CGFloat(sampling))

        while startX >= 0, index >= 0 {
            let delta = CGFloat(minDb - powerStack[index]) / CGFloat(minDb) * showPercentage * center
            path.move(to: .init(x: startX, y: center - delta))
            path.addLine(to: .init(x: startX, y: center + delta))
            index -= 1
            startX -= CGFloat(barSpacing)
        }
        path.close()
        path.stroke()

        timeCounter += 1
        timeCounter %= sampling
    }

    /// reset all drawing
    public func reset() {
        power = minDb
        powerStack.removeAll()
        timeCounter = 0
    }
}
