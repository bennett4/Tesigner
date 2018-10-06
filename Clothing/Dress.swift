//
//  Dress.swift
//  Tesigner
//
//  Created by Matt. on 9/30/18.
//  Copyright © 2018 mbenn. All rights reserved.
//

import UIKit

class Dress: CanvasView {
    
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
        
        // Set Dress Endpoints
        let leftBottom = CGPoint(x: width * 0.15, y: height * 0.89)
        let rightBottom = CGPoint(x: width * 0.85, y: height * 0.89)
        let leftShoulder = CGPoint(x: width * 0.3, y: height * 0.02)
        let rightShoulder = CGPoint(x: width * 0.7, y: height * 0.02)
        let leftNeck = CGPoint(x: width * 0.35, y: height * 0.01)
        let rightNeck = CGPoint(x: width * 0.65, y: height * 0.01)
        let leftTopWaist = CGPoint(x: width * 0.325, y: height * 0.35)
        let rightTopWaist = CGPoint(x: width * 0.675, y: height * 0.35)
        let leftArmpit = CGPoint(x: width * 0.31, y: height * 0.14)
        let rightArmpit = CGPoint(x: width * 0.69, y: height * 0.14)
        
        // Set Control Points for Curves
        let leftArmpitControlPoint = CGPoint(x: width * 0.325, y: height * 0.1)
        let leftNeckControlPoint = CGPoint(x: width * 0.35, y: height * 0.1)
        let leftRibControlPoint = CGPoint(x: width * 0.29, y: height * 0.175)
        let leftRibControlPoint2 = CGPoint(x: width * 0.3, y: height * 0.2)
        let leftLegControlPoint = CGPoint(x: width * 0.325, y: height * 0.4)
        let leftLegControlPoint2 = CGPoint(x: width * 0.15, y: height * 0.7)
        let rightArmpitControlPoint = CGPoint(x: width * 0.675, y: height * 0.1)
        let rightNeckControlPoint = CGPoint(x: width * 0.65, y: height * 0.1)
        let rightRibControlPoint = CGPoint(x: width * 0.71, y: height * 0.175)
        let rightRibControlPoint2 = CGPoint(x: width * 0.7, y: height * 0.2)
        let rightLegControlPoint = CGPoint(x: width * 0.675, y: height * 0.4)
        let rightLegControlPoint2 = CGPoint(x: width * 0.85, y: height * 0.7)
        
        // Generate the Path
        
        // Left
        let path = UIBezierPath()
        path.move(to: leftNeck)
        path.addLine(to: leftShoulder)
        path.addCurve(to: leftArmpit, controlPoint1: leftArmpitControlPoint, controlPoint2: leftArmpitControlPoint)
        path.addCurve(to: leftTopWaist, controlPoint1: leftRibControlPoint, controlPoint2: leftRibControlPoint2)
        path.addCurve(to: leftBottom, controlPoint1: leftLegControlPoint, controlPoint2: leftLegControlPoint2)
        
        // Bottom
        path.addCurve(to: CGPoint(x:width * 0.20, y:height*0.91), controlPoint1: CGPoint(x:width * 0.17, y:height*0.92), controlPoint2: CGPoint(x:width * 0.17, y:height*0.92))
        path.addCurve(to: CGPoint(x:width * 0.25, y:height*0.93), controlPoint1: CGPoint(x:width * 0.22, y:height*0.934), controlPoint2: CGPoint(x:width * 0.22, y:height*0.934))
        path.addCurve(to: CGPoint(x:width * 0.30, y:height*0.94), controlPoint1: CGPoint(x:width * 0.27, y:height*0.942), controlPoint2: CGPoint(x:width * 0.27, y:height*0.942))
        path.addCurve(to: CGPoint(x:width * 0.35, y:height*0.95), controlPoint1: CGPoint(x:width * 0.32, y:height*0.95), controlPoint2: CGPoint(x:width * 0.32, y:height*0.95))
        path.addCurve(to: CGPoint(x:width * 0.40, y:height*0.955), controlPoint1: CGPoint(x:width * 0.38, y:height*0.968), controlPoint2: CGPoint(x:width * 0.38, y:height*0.968))
        path.addCurve(to: CGPoint(x:width * 0.45, y:height*0.97), controlPoint1: CGPoint(x:width * 0.42, y:height*0.975), controlPoint2: CGPoint(x:width * 0.42, y:height*0.975))
        path.addCurve(to: CGPoint(x:width * 0.50, y:height*0.98), controlPoint1: CGPoint(x:width * 0.48, y:height*0.99), controlPoint2: CGPoint(x:width * 0.48, y:height*0.99))
        path.addCurve(to: CGPoint(x:width * 0.55, y:height*0.976), controlPoint1: CGPoint(x:width * 0.53, y:height*0.99), controlPoint2: CGPoint(x:width * 0.53, y:height*0.99))
        path.addCurve(to: CGPoint(x:width * 0.60, y:height*0.96), controlPoint1: CGPoint(x:width * 0.58, y:height*0.975), controlPoint2: CGPoint(x:width * 0.58, y:height*0.975))
        path.addCurve(to: CGPoint(x:width * 0.65, y:height*0.952), controlPoint1: CGPoint(x:width * 0.62, y:height*0.968), controlPoint2: CGPoint(x:width * 0.62, y:height*0.968))
        path.addCurve(to: CGPoint(x:width * 0.70, y:height*0.938), controlPoint1: CGPoint(x:width * 0.69, y:height*0.95), controlPoint2: CGPoint(x:width * 0.69, y:height*0.95))
        path.addCurve(to: CGPoint(x:width * 0.75, y:height*0.93), controlPoint1: CGPoint(x:width * 0.72, y:height*0.942), controlPoint2: CGPoint(x:width * 0.72, y:height*0.942))
        path.addCurve(to: CGPoint(x:width * 0.80, y:height*0.92), controlPoint1: CGPoint(x:width * 0.78, y:height*0.934), controlPoint2: CGPoint(x:width * 0.78, y:height*0.934))
        path.addCurve(to: rightBottom, controlPoint1: CGPoint(x:width * 0.84, y:height*0.92), controlPoint2: CGPoint(x:width * 0.84, y:height*0.92))
        
        // Right
        path.addCurve(to: rightTopWaist, controlPoint1: rightLegControlPoint2, controlPoint2: rightLegControlPoint)
        path.addCurve(to: rightArmpit, controlPoint1: rightRibControlPoint2, controlPoint2: rightRibControlPoint)
        path.addCurve(to: rightShoulder, controlPoint1: rightArmpitControlPoint, controlPoint2: rightArmpitControlPoint)
        path.addLine(to: rightNeck)
        
        // Top
        path.addCurve(to: leftNeck, controlPoint1: rightNeckControlPoint, controlPoint2: leftNeckControlPoint)
        
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
        let copy = Dress()
        return copy
    }
    
}
