//
//  SAConfettiView.swift
//  Pods
//
//  Created by Sudeep Agarwal on 12/14/15.
//
//

import UIKit
import QuartzCore

public class SAConfettiView: UIView {
    
    public enum ConfettiType {
        case Confetti
        case Triangle
        case Star
        case Diamond
        case Image(UIImage)
    }

    public var colors: [UIColor] = [
        UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
        UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
        UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
        UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
        UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0),
    ]
    public var intensity: Float = 1
    public var type: ConfettiType = .Confetti
    
    lazy var emitter: CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: self.center.x, y: -100)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: self.frame.size.width, height: 1)
        
        var cells = [CAEmitterCell]()
        for color in self.colors {
            cells.append(self.confettiWithColor(color))
        }
        
        emitter.emitterCells = cells
        
        return emitter
    }()

    
    public func startConfetti() {
        layer.addSublayer(emitter)
    }
    
    public func stopConfetti() {
        emitter.removeFromSuperlayer()
    }
    
    
    func imageForType(type: ConfettiType) -> UIImage? {
        
        var fileName: String!
        
        switch type {
        case .Confetti:
            fileName = "confetti"
        case .Triangle:
            fileName = "triangle"
        case .Star:
            fileName = "star"
        case .Diamond:
            fileName = "diamond"
        case let .Image(customImage):
            return customImage
        }
        
        let path = NSBundle(forClass: SAConfettiView.self).pathForResource("SAConfettiView", ofType: "bundle")
        let bundle = NSBundle(path: path!)
        let imagePath = bundle?.pathForResource(fileName, ofType: "png")
        let url = NSURL(fileURLWithPath: imagePath!)
        let data = NSData(contentsOfURL: url)
        if let data = data {
            return UIImage(data: data)!
        }
        return nil
    }
    
    func confettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.color = color.CGColor
        confetti.velocity = CGFloat(150)
        confetti.velocityRange = CGFloat(40)
        confetti.emissionLongitude = CGFloat(M_PI)
        confetti.emissionRange = CGFloat(M_PI_4)
        confetti.spin = CGFloat(M_PI_2)
        confetti.spinRange = CGFloat(M_PI)
        confetti.scaleRange = CGFloat(0.5)
        confetti.scaleSpeed = CGFloat(-0.05)
        confetti.contents = imageForType(type)!.CGImage
        return confetti
    }

}
