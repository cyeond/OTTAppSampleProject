//
//  StarRatingView.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/18/23.
//

import UIKit

class StarRatingView: UIView {
    private let emptyColor: UIColor = .white
    private let fillColor: UIColor = .systemBlue
    private let point: CGFloat = 30.0
    private let spacing: CGFloat = 10.0
    private let maxCount = 5
    private let minCount = 0
    
    private var currentValue: CGFloat = 0
    private var currentWidth: CGFloat = 0
    private var minWidth: CGFloat = 0
    private var maxWidth: CGFloat = 0
    private var emptyStar: UIImage?
    private var fillStar: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.maxWidth = rateToWidth(CGFloat(self.maxCount))
        self.minWidth = rateToWidth(CGFloat(self.minCount))
        self.emptyStar = makeStarImage(pt: self.point, spacing: self.spacing, color: self.emptyColor)
        self.fillStar = makeStarImage(pt: self.point, spacing: self.spacing, color: self.fillColor)
        
        self.backgroundColor = .clear
        self.frame.size = self.intrinsicContentSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCurrentValue(_ current: CGFloat) {
        currentValue = current > CGFloat(minCount) ? current : CGFloat(minCount)
        currentWidth = rateToWidth(currentValue)
        
        setNeedsDisplay()
    }
    
    private func rateToWidth(_ rate: CGFloat) -> CGFloat {
        var width = self.point * CGFloat(rate)
        width = width + CGFloat(ceil(rate) - 1) * self.spacing
        
        return width
    }
    
    private func makeStar(_ size: CGFloat, color: UIColor) -> UIImage? {
        let starSize: Double = Double(size)
        let xCenter: Double = starSize * 0.5
        let yCenter: Double = starSize * 0.5
        let r: Double = starSize * 0.5
        let flip: Double = -1.0
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: starSize, height: starSize), false, 0)
        
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        currentContext.setFillColor(color.cgColor)
        currentContext.setStrokeColor(color.cgColor)
        
        currentContext.move(to: CGPoint(x: xCenter, y: r * flip + yCenter))
        let theta: Double = 2.0 * .pi * (2.0 / 5.0)
        for i in 1 ..< 5 {
            let x: Double = Double(r * sin(Double(i) * theta))
            let y: Double = Double(r * cos(Double(i) * theta))
            currentContext.addLine(to: CGPoint(x: x + xCenter, y: y * flip + yCenter))
        }
        
        currentContext.closePath()
        currentContext.fillPath()
        let star = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return star
    }
    
    private func makeStarImage(pt size: CGFloat, spacing: CGFloat, color: UIColor) -> UIImage? {
        guard let star = self.makeStar(size, color: color) else { return nil }
        
        var size = star.size
        size.width = size.width + self.spacing
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        star.draw(at: CGPoint(x: 0, y: 0))
        let starImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return starImage
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let emptyStar = self.emptyStar else { return }
        emptyStar.drawAsPattern(in: CGRect(x: 0, y: 0, width: self.maxWidth, height: emptyStar.size.height))
        
        if self.currentValue > 0 {
            guard let fillStar = self.fillStar else { return }
            fillStar.drawAsPattern(in: CGRect(x: 0, y: 0, width: self.currentWidth, height: fillStar.size.height))
        }
    }
}
