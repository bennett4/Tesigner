//
//  LongSleeve.swift
//  Tesigner
//
//  Created by Matt. on 9/8/18.
//  Copyright © 2018 mbenn. All rights reserved.
//

import UIKit

class LongSleeve: CanvasView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        // Get Dimensions
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        // Set Shirt Endpoints
        let leftBottom = CGPoint(x: width * 0.2, y: height * 0.99)
        let rightBottom = CGPoint(x: width * 0.8, y: height * 0.99)
        let leftArmpit = CGPoint(x: width * 0.2, y: height * 0.35)
        let rightArmpit = CGPoint(x: width * 0.8, y: height * 0.35)
        let leftSleeveBottom = CGPoint(x: width * 0.15, y: height * 0.99)
        let rightSleeveBottom = CGPoint(x: width * 0.85, y: height * 0.99)
        let leftSleeveTop = CGPoint(x: width * 0.01, y: height * 0.975)
        let rightSleeveTop = CGPoint(x: width * 0.99, y: height * 0.975)
        let leftNeck = CGPoint(x: width * 0.35, y: height * 0.1)
        let rightNeck = CGPoint(x: width * 0.65, y: height * 0.1)
        
        // Set Control Points for Neck
        let neckLeftControlPoint = CGPoint(x: width * 0.40, y: height * 0.2)
        let neckRightControlPoint = CGPoint(x: width * 0.60, y: height * 0.2)
        
        // Set Control Points for Shoulders
        let leftShoulderControlPoint1 = CGPoint(x: width * 0.1, y: height * 0.125)
        let leftShoulderControlPoint2 = CGPoint(x: width * 0.025, y: height * 0.1)
        let rightShoulderControlPoint1 = CGPoint(x: width * 0.975, y: height * 0.1)
        let rightShoulderControlPoint2 = CGPoint(x: width * 0.9, y: height * 0.125)
        
        // Generate the Path
        let path = UIBezierPath()
        path.move(to: leftNeck)
        path.addCurve(to: leftSleeveTop, controlPoint1: leftShoulderControlPoint1, controlPoint2: leftShoulderControlPoint2)
        path.addLine(to: leftSleeveBottom)
        path.addLine(to: leftArmpit)
        path.addLine(to: leftBottom)
        path.addLine(to: rightBottom)
        path.addLine(to: rightArmpit)
        path.addLine(to: rightSleeveBottom)
        path.addLine(to: rightSleeveTop)
        path.addCurve(to: rightNeck, controlPoint1: rightShoulderControlPoint1, controlPoint2: rightShoulderControlPoint2)
        path.addCurve(to: leftNeck, controlPoint1: neckRightControlPoint, controlPoint2: neckLeftControlPoint)
        
        // Fill
        if (fillColor == nil) {
            fillColor = UIColor.white
        }
        fillColor.set()
        path.fill()
        
        // Stroke
        UIColor.black.set()
        path.lineWidth = 2
        path.stroke()
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = LongSleeve()
        return copy
    }
    
}
