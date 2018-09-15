//
//  CanvasView.swift
//  Tesigner
//
//  Created by Matt. on 9/3/18.
//  Copyright © 2018 mbenn. All rights reserved.
//

import UIKit

class CanvasView: UIView, NSCopying {
    
    var lineColor = UIColor.black
    var fillColor: UIColor!
    var lineWidth = 4
    var path: UIBezierPath!
    var touchPoint: CGPoint!
    var startingPoint: CGPoint!
    var startingIndexArray = [Int]()
    var touchBegan: Bool!
    
    override func layoutSubviews() {
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startingPoint = touch?.location(in: self)
        
        touchBegan = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Only add to the list of starting indexes if this is the first time moving after pressing down
        if (touchBegan) {
            if (self.layer.sublayers == nil) {
                startingIndexArray.append(0)
            }
            else {
                startingIndexArray.append((self.layer.sublayers?.count)!)
            }
            touchBegan = false
        }
        
        let touch = touches.first
        touchPoint = touch?.location(in: self)
        
        path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: touchPoint)
        startingPoint = touchPoint
        
        drawShapeLayer()
    }
    
    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = CGFloat(lineWidth)
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    func clear() {
        if (startingIndexArray.count > 0) {
            path.removeAllPoints()
            self.layer.sublayers = nil
            startingIndexArray.removeAll()
            self.setNeedsDisplay()
        }
    }
    
    func undo() {
        // If there is a sublayer to be removed
        if (startingIndexArray.count > 0) {
            let endingIndex = self.layer.sublayers!.count - 1
            // Remove all sublayers from the last time the user pressed down to when they lifted up (the last sublayer)
            for _ in startingIndexArray[startingIndexArray.count - 1]...endingIndex {
                self.layer.sublayers!.remove(at: self.layer.sublayers!.count - 1)
            }
            // Remove the starting index of the removed sublayer
            startingIndexArray.removeLast()
        }
        self.setNeedsDisplay()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        preconditionFailure("All subclasses of CanvasView must override the copy() method.")
    }
    
}
