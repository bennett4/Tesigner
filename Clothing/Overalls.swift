//
//  Overalls.swift
//  Tesigner
//
//  Created by Matt. on 10/6/18.
//  Copyright © 2018 mbenn. All rights reserved.
//

import UIKit

class Overalls: CanvasView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        // Draw background
        super.draw(rect)
        
        // Get Dimensions
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        // Set Endpoints
        let leftChest = CGPoint(x: width * 0.4, y: height * 0.2)
        let leftInsideNeck = CGPoint(x: width * 0.4, y: height * 0.02)
        let leftOutsideNeck = CGPoint(x: width * 0.35, y: height * 0.02)
        let leftArmpit = CGPoint(x: width * 0.275, y: height * 0.4)
        let leftLegLeft = CGPoint(x: width * 0.275, y: height * 0.99)
        let leftLegRight = CGPoint(x: width * 0.4, y: height * 0.99)
        let rightLegLeft = CGPoint(x: width * 0.6, y: height * 0.99)
        let rightLeftRight = CGPoint(x: width * 0.725, y: height * 0.99)
        let rightArmpit = CGPoint(x: width * 0.725, y: height * 0.4)
        let rightOutsideNeck = CGPoint(x: width * 0.65, y: height * 0.02)
        let rightInsideNeck = CGPoint(x: width * 0.6, y: height * 0.02)
        let rightChest = CGPoint(x: width * 0.6, y: height * 0.2)
        let leftCrotch = CGPoint(x: width * 0.45, y: height * 0.75)
        let rightCrotch = CGPoint(x: width * 0.55, y: height * 0.75)
        
        // Set Control Points
        let leftNeckControlPoint = CGPoint(x: width * 0.375, y: height * 0.01)
        let rightNeckControlPoint = CGPoint(x: width * 0.625, y: height * 0.01)
        let leftArmpitControlPoint = CGPoint(x: width * 0.35, y: height * 0.3)
        let rightArmpitControlPoint = CGPoint(x: width * 0.65, y: height * 0.3)
        let crotchControlPoint1 = CGPoint(x: width * 0.475, y: height * 0.625)
        let crotchControlPoint2 = CGPoint(x: width * 0.525, y: height * 0.625)

        // Generate the Path
        let path = UIBezierPath()
        path.move(to: leftChest)
        path.addLine(to: leftInsideNeck)
        path.addCurve(to: leftOutsideNeck, controlPoint1: leftNeckControlPoint, controlPoint2: leftNeckControlPoint)
        path.addCurve(to: leftArmpit, controlPoint1: leftArmpitControlPoint, controlPoint2: leftArmpitControlPoint)
        path.addLine(to: leftLegLeft)
        path.addLine(to: leftLegRight)
        path.addLine(to: leftCrotch)
        path.addCurve(to: rightCrotch, controlPoint1: crotchControlPoint1, controlPoint2: crotchControlPoint2)
        path.addLine(to: rightLegLeft)
        path.addLine(to: rightLeftRight)
        path.addLine(to: rightArmpit)
        path.addCurve(to: rightOutsideNeck, controlPoint1: rightArmpitControlPoint, controlPoint2: rightArmpitControlPoint)
        path.addCurve(to: rightInsideNeck, controlPoint1: rightNeckControlPoint, controlPoint2: rightNeckControlPoint)
        path.addLine(to: rightChest)
        path.addLine(to: leftChest)
        
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
        let copy = Overalls()
        return copy
    }
    
}
