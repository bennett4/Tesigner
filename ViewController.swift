//
//  ViewController.swift
//  Tesigner
//
//  Created by Matt. on 9/3/18.
//  Copyright © 2018 mbenn. All rights reserved.
//

import UIKit
import FontAwesome
import ColorSlider

class ViewController: UIViewController {
    
    var phoneWidth: CGFloat!
    var phoneHeight: CGFloat!
    var canvasBounds: CGRect!
    var coverView: UIView!
    var closedCoverView: UIGestureRecognizer!
    var canvas: CanvasView!
    var clothingOptions = [CanvasView]()
    var optionsGestureRecognizers = [UILongPressGestureRecognizer]()
    var colorSlider: ColorSlider!
    var color: UIColor!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var clothingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Width and Height of Phone
        phoneWidth = view.frame.size.width
        phoneHeight = view.frame.size.height
        
        // Set Dimensions of the Canvas
        let dimens = phoneWidth * 0.9
        canvasBounds = CGRect(x: (phoneWidth / 2) - (dimens / 2), y: (phoneHeight / 2) - (dimens / 2), width: dimens, height: dimens)
        
        // Set the Initial Canvas
        canvas = ShortSleeve(frame: canvasBounds)
        view.addSubview(canvas)
        
        // Set Up All Other Components
        initComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func clear(_ sender: Any) {
        canvas.clear()
    }
    
    @IBAction func undo(_ sender: Any) {
        canvas.undo()
    }
    
    @IBAction func changeClothes(_ sender: Any) {
        // Add cover view
        beganChange()
        
        // Add clothing options to the screen
        for i in 0...(clothingOptions.count - 1) {
            view.addSubview(clothingOptions[i])
            clothingOptions[i].addGestureRecognizer(optionsGestureRecognizers[i])
        }
    }
    
    @objc func pickedOutClothes(_ sender: UIView) {
        // Find index of selected clothing option
        var index: Int!
        for i in 0...(clothingOptions.count - 1) {
            if (optionsGestureRecognizers[i] == sender) {
                index = i
            }
        }
        
        // Remove previous clothing canvas
        let currentColor = canvas.lineColor
        canvas.removeFromSuperview()
        
        // Set new canvas to be the selected option
        canvas = clothingOptions[index].copy() as! CanvasView
        canvas.frame = canvasBounds
        canvas.lineColor = currentColor
        
        // Remove cover view
        endedChange(sender)
        
        // Add the selected clothing to the canvas
        view.addSubview(canvas)
    }
    
    @IBAction func changeColor(_ sender: Any) {
        // Add cover view
        beganChange()
        
        // Add color picker to the screen
        view.addSubview(colorSlider)
        colorSlider.addTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpOutside)
        colorSlider.addTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpInside)
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        // Set new line color and clean up
        canvas.lineColor = slider.color
        colorSlider.removeTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpOutside)
        colorSlider.removeTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpInside)
        colorSlider.removeFromSuperview()
        endedChange(slider)
    }
    
    func beganChange() {
        view.addSubview(coverView)
        coverView.addGestureRecognizer(closedCoverView)
    }
    
    @objc func endedChange(_ sender: UIView) {
        if (colorSlider.superview != nil) {
            // If a new color was not selected, remove color selector from screen
            colorSlider.removeTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpOutside)
            colorSlider.removeTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpInside)
            colorSlider.removeFromSuperview()
        }
        else if (clothingOptions[0].superview != nil) {
            // If a new clothing option was not selected, remove all clothing options from screen
            for i in 0...(clothingOptions.count - 1) {
                clothingOptions[i].removeFromSuperview()
                clothingOptions[i].removeGestureRecognizer(optionsGestureRecognizers[i])
            }
        }
        
        // Remove cover view
        coverView.removeGestureRecognizer(closedCoverView)
        coverView.removeFromSuperview()
    }
    
    func initComponents() {
        let buttonCornerRadius = CGFloat(20)
        let buttonBorderWidth = CGFloat(1)
        let buttonBorderColor = UIColor.black.cgColor
        let buttonScaleFactor = CGFloat(0.8)
        
        clearButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        clearButton.setTitle(String.fontAwesomeIcon(name: .trash), for: .normal)
        clearButton.setTitleColor(UIColor.black, for: .normal)
        clearButton.backgroundColor = .clear
        clearButton.layer.cornerRadius = buttonCornerRadius
        clearButton.layer.borderWidth = buttonBorderWidth
        clearButton.layer.borderColor = buttonBorderColor
        clearButton.transform = CGAffineTransform(scaleX: buttonScaleFactor, y: buttonScaleFactor)
        
        undoButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        undoButton.setTitle(String.fontAwesomeIcon(name: .undo), for: .normal)
        undoButton.setTitleColor(UIColor.black, for: .normal)
        undoButton.backgroundColor = .clear
        undoButton.layer.cornerRadius = buttonCornerRadius
        undoButton.layer.borderWidth = buttonBorderWidth
        undoButton.layer.borderColor = buttonBorderColor
        undoButton.transform = CGAffineTransform(scaleX: buttonScaleFactor, y: buttonScaleFactor)
        
        colorButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        colorButton.setTitle(String.fontAwesomeIcon(name: .paintBrush), for: .normal)
        colorButton.setTitleColor(UIColor.black, for: .normal)
        colorButton.backgroundColor = .clear
        colorButton.layer.cornerRadius = buttonCornerRadius
        colorButton.layer.borderWidth = buttonBorderWidth
        colorButton.layer.borderColor = buttonBorderColor
        colorButton.transform = CGAffineTransform(scaleX: buttonScaleFactor, y: buttonScaleFactor)
        
        clothingButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        clothingButton.setTitle(String.fontAwesomeIcon(name: .tshirt), for: .normal)
        clothingButton.setTitleColor(UIColor.black, for: .normal)
        clothingButton.backgroundColor = .clear
        clothingButton.layer.cornerRadius = buttonCornerRadius
        clothingButton.layer.borderWidth = buttonBorderWidth
        clothingButton.layer.borderColor = buttonBorderColor
        clothingButton.transform = CGAffineTransform(scaleX: buttonScaleFactor, y: buttonScaleFactor)
        
        coverView = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        coverView.backgroundColor = UIColor.white
        closedCoverView = UITapGestureRecognizer(target: self, action: #selector(self.endedChange(_:)))
        
        colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        let sliderWidth = phoneWidth * 0.75
        let sliderHeight = phoneHeight * 0.04
        colorSlider.frame = CGRect(x: ((phoneWidth / 2) - ((sliderWidth) / 2)), y: ((phoneHeight / 2) - ((sliderHeight) / 2)), width: sliderWidth, height: sliderHeight)
        
        initOptions()
    }
    
    func initOptions() {
        clothingOptions.append(ShortSleeve())
        clothingOptions.append(LongSleeve())
        
        let percentOfContent = CGFloat(0.8)
        let percentOfSpacing = 1 - percentOfContent
        
        let optionWidth = (phoneWidth * percentOfContent) / CGFloat(clothingOptions.count)
        let spacingWidth = (phoneWidth * percentOfSpacing) / CGFloat(clothingOptions.count + 1)
        
        for i in 0...(clothingOptions.count - 1) {
            clothingOptions[i].frame = CGRect(x: (CGFloat(i) * optionWidth) + (CGFloat(i + 1) * spacingWidth), y: (phoneHeight / 2) - (optionWidth / 2), width: optionWidth, height: optionWidth)
        }
        
        for i in 0...(clothingOptions.count - 1) {
            optionsGestureRecognizers.append(UILongPressGestureRecognizer(target: self, action: #selector(self.pickedOutClothes(_:))))
            optionsGestureRecognizers[i].minimumPressDuration = 0
        }
    }
    
}
