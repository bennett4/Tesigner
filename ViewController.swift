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
import Photos

class ViewController: UIViewController {
    
    var phoneWidth: CGFloat!
    var phoneHeight: CGFloat!
    var canvasBounds: CGRect!
    var coverView: UIView!
    var closedCoverView: UIGestureRecognizer!
    var canvas: CanvasView!
    var clothingOptions = [[CanvasView]]()
    var optionsGestureRecognizers = [[UILongPressGestureRecognizer]]()
    var lineColorSlider: ColorSlider!
    var fillColorSlider: ColorSlider!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var clothingButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
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
        // Clear all previous strokes
        canvas.clear()
    }
    
    @IBAction func undo(_ sender: Any) {
        // Undo the previous stroke
        canvas.undo()
    }
    
    @IBAction func changeClothes(_ sender: Any) {
        // Add the cover to the screen
        beganChange()
        
        // Add clothing options to the screen
        for i in 0...(clothingOptions.count - 1) {
            for j in 0...(clothingOptions[i].count - 1) {
                view.addSubview(clothingOptions[i][j])
                clothingOptions[i][j].addGestureRecognizer(optionsGestureRecognizers[i][j])
            }
        }
    }
    
    @objc func pickedOutClothes(_ sender: UIView) {
        // Get index of selected clothing option
        var index: Int!
        for i in 0...(clothingOptions.count - 1) {
            for j in 0...(clothingOptions[i].count - 1) {
                if (optionsGestureRecognizers[i][j] == sender) {
                    // Not my favorite approach
                    index = (i * 1000) + j
                }
            }
        }
        
        // Remove the clothing options from the screen
        for i in 0...(clothingOptions.count - 1) {
            for j in 0...(clothingOptions[i].count - 1) {
                clothingOptions[i][j].removeFromSuperview()
                clothingOptions[i][j].removeGestureRecognizer(optionsGestureRecognizers[i][j])
            }
        }
        
        // Add the cover to the screen
        beganChange()
        
        // Add color picker to the screen
        view.addSubview(fillColorSlider)
        fillColorSlider.addTarget(self, action: #selector(ViewController.selectedClothingColor(_:)), for: .touchUpOutside)
        fillColorSlider.addTarget(self, action: #selector(ViewController.selectedClothingColor(_:)), for: .touchUpInside)
        fillColorSlider.tag = index
    }
    
    @objc func selectedClothingColor(_ slider: ColorSlider) {
        // Set fill color and clean up
        let fillColor = slider.color
        fillColorSlider.removeTarget(self, action: #selector(ViewController.selectedClothingColor(_:)), for: .touchUpOutside)
        fillColorSlider.removeTarget(self, action: #selector(ViewController.selectedClothingColor(_:)), for: .touchUpInside)
        fillColorSlider.removeFromSuperview()
        endedChange(slider)
        displayNewClothing(indexOfSelectedClothing: slider.tag, color: fillColor)
    }
    
    func displayNewClothing(indexOfSelectedClothing: Int, color: UIColor) {
        // Remove previous clothing canvas
        let currentColor = canvas.lineColor
        canvas.removeFromSuperview()
        
        // Set new canvas to be the selected option
        let iIndex = indexOfSelectedClothing / 1000
        let jIndex = indexOfSelectedClothing % 1000
        canvas = clothingOptions[iIndex][jIndex].copy() as? CanvasView
        canvas.frame = canvasBounds
        canvas.lineColor = currentColor
        canvas.fillColor = color
        
        // Remove cover view
        endedChange(UIView())
        
        // Add the selected clothing to the canvas
        view.addSubview(canvas)
    }
    
    @IBAction func changeColor(_ sender: Any) {
        // Add cover view
        beganChange()
        
        // Add color picker to the screen
        view.addSubview(lineColorSlider)
        lineColorSlider.addTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpOutside)
        lineColorSlider.addTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpInside)
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        // Set new line color and clean up
        canvas.lineColor = slider.color
        lineColorSlider.removeTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpOutside)
        lineColorSlider.removeTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpInside)
        lineColorSlider.removeFromSuperview()
        endedChange(slider)
    }
    
    @IBAction func save(_ sender: Any) {
        // Convert canvas (UIView) to UIImage
        let renderer = UIGraphicsImageRenderer(size: canvas.bounds.size)
        let image = renderer.image { ctx in
            canvas.drawHierarchy(in: canvas.bounds, afterScreenUpdates: true)
        }
        
        // Save to Photos
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(savedToPhotos(_: error: contextInfo:)), nil)
        
    }
    
    @objc func savedToPhotos(_ image: UIImage, error: NSError?, contextInfo: UnsafeRawPointer) {
        // If we don't have permission to add to the user's photos
        if error != nil {
            // Create the alert
            let title = NSLocalizedString("noPermissionTitle", comment: "Title of dialog box when saving without permission")
            let message = NSLocalizedString("noPermissionDescription", comment: "Description of dialog box when saving without permission")
            let alertController = UIAlertController(title: title + ".", message: message, preferredStyle: .alert)
            
            // Create the Settings action
            let settingsString = NSLocalizedString("settings", comment: "Settings")
            let settingsAction = UIAlertAction(title: settingsString, style: .default) { (alertAction) in
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            }
            
            // Create the Cancel action
            let cancelString = NSLocalizedString("cancel", comment: "Cancel")
            let cancelAction = UIAlertAction(title: cancelString, style: .cancel)
            
            // Add the actions to the alert
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            // Display the alert
            present(alertController, animated: true)
        }
    }
    
    func beganChange() {
        // Add the cover to the screen
        view.addSubview(coverView)
        coverView.addGestureRecognizer(closedCoverView)
    }
    
    @objc func endedChange(_ sender: UIView) {
        if (lineColorSlider.superview != nil) {
            // If a new color was not selected, remove color selector from screen
            lineColorSlider.removeTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpOutside)
            lineColorSlider.removeTarget(self, action: #selector(ViewController.changedColor(_:)), for: .touchUpInside)
            lineColorSlider.removeFromSuperview()
        }
        else if (clothingOptions[0][0].superview != nil) {
            // If a new clothing option was not selected, remove all clothing options from screen
            for i in 0...(clothingOptions.count - 1) {
                for j in 0...(clothingOptions[i].count - 1) {
                    clothingOptions[i][j].removeFromSuperview()
                    clothingOptions[i][j].removeGestureRecognizer(optionsGestureRecognizers[i][j])
                }
            }
        }
        else if (fillColorSlider.superview != nil) {
            // If a new color was not selected, remove color selector and clothing choices from screen
            fillColorSlider.removeTarget(self, action: #selector(ViewController.selectedClothingColor(_:)), for: .touchUpOutside)
            fillColorSlider.removeTarget(self, action: #selector(ViewController.selectedClothingColor(_:)), for: .touchUpInside)
            fillColorSlider.removeFromSuperview()
        }
        
        // Remove cover view
        coverView.removeGestureRecognizer(closedCoverView)
        coverView.removeFromSuperview()
    }
    
    func initComponents() {
        // Set various button properties
        let buttonCornerRadius = CGFloat(18)
        let buttonBorderWidth = CGFloat(1)
        let buttonBorderColor = UIColor.black.cgColor
        let buttonScaleFactor = CGFloat(0.85)
        let buttonFontSize = CGFloat(26)
        
        // The button that allows the user to clear all of his/her previous strokes
        clearButton.titleLabel?.font = UIFont.fontAwesome(ofSize: buttonFontSize, style: .solid)
        clearButton.setTitle(String.fontAwesomeIcon(name: .trash), for: .normal)
        clearButton.setTitleColor(UIColor.black, for: .normal)
        clearButton.backgroundColor = .clear
        clearButton.layer.cornerRadius = buttonCornerRadius
        clearButton.layer.borderWidth = buttonBorderWidth
        clearButton.layer.borderColor = buttonBorderColor
        clearButton.transform = CGAffineTransform(scaleX: buttonScaleFactor, y: buttonScaleFactor)
        
        // The button that allows the user to undo his/her previous stroke
        undoButton.titleLabel?.font = UIFont.fontAwesome(ofSize: buttonFontSize, style: .solid)
        undoButton.setTitle(String.fontAwesomeIcon(name: .undo), for: .normal)
        undoButton.setTitleColor(UIColor.black, for: .normal)
        undoButton.backgroundColor = .clear
        undoButton.layer.cornerRadius = buttonCornerRadius
        undoButton.layer.borderWidth = buttonBorderWidth
        undoButton.layer.borderColor = buttonBorderColor
        undoButton.transform = CGAffineTransform(scaleX: buttonScaleFactor, y: buttonScaleFactor)
        
        // The button that allows the user to change the color of the lines that he/she can draw
        colorButton.titleLabel?.font = UIFont.fontAwesome(ofSize: buttonFontSize, style: .solid)
        colorButton.setTitle(String.fontAwesomeIcon(name: .paintBrush), for: .normal)
        colorButton.setTitleColor(UIColor.black, for: .normal)
        colorButton.backgroundColor = .clear
        colorButton.layer.cornerRadius = buttonCornerRadius
        colorButton.layer.borderWidth = buttonBorderWidth
        colorButton.layer.borderColor = buttonBorderColor
        colorButton.transform = CGAffineTransform(scaleX: buttonScaleFactor, y: buttonScaleFactor)
        
        // The button that allows the user to choose different clothing
        clothingButton.titleLabel?.font = UIFont.fontAwesome(ofSize: buttonFontSize, style: .solid)
        clothingButton.setTitle(String.fontAwesomeIcon(name: .tshirt), for: .normal)
        clothingButton.setTitleColor(UIColor.black, for: .normal)
        clothingButton.backgroundColor = .clear
        clothingButton.layer.cornerRadius = buttonCornerRadius
        clothingButton.layer.borderWidth = buttonBorderWidth
        clothingButton.layer.borderColor = buttonBorderColor
        clothingButton.transform = CGAffineTransform(scaleX: buttonScaleFactor, y: buttonScaleFactor)
        
        // The button that allows the user to save his/her piece to photos
        saveButton.titleLabel?.font = UIFont.fontAwesome(ofSize: buttonFontSize, style: .solid)
        saveButton.setTitle(String.fontAwesomeIcon(name: .download), for: .normal)
        saveButton.setTitleColor(UIColor.black, for: .normal)
        saveButton.backgroundColor = .clear
        saveButton.layer.cornerRadius = buttonCornerRadius
        saveButton.layer.borderWidth = buttonBorderWidth
        saveButton.layer.borderColor = buttonBorderColor
        saveButton.transform = CGAffineTransform(scaleX: buttonScaleFactor, y: buttonScaleFactor)
        
        // The cover view that covers up the base screen when the user is changing something
        coverView = UIView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        coverView.backgroundColor = UIColor.white
        closedCoverView = UITapGestureRecognizer(target: self, action: #selector(self.endedChange(_:)))
        
        // The slider that decides the color of the lines that the user can draw
        lineColorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        let lineSliderWidth = phoneWidth * 0.75
        let lineSliderHeight = phoneHeight * 0.04
        lineColorSlider.frame = CGRect(x: ((phoneWidth / 2) - ((lineSliderWidth) / 2)), y: ((phoneHeight / 2) - ((lineSliderHeight) / 2)), width: lineSliderWidth, height: lineSliderHeight)
        
        // The slider that decides the fill color of the clothing
        fillColorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        let fillSliderWidth = phoneWidth * 0.75
        let fillSliderHeight = phoneHeight * 0.04
        fillColorSlider.frame = CGRect(x: ((phoneWidth / 2) - ((fillSliderWidth) / 2)), y: ((phoneHeight / 2) - ((fillSliderHeight) / 2)), width: fillSliderWidth, height: fillSliderHeight)
        
        // Initialize the clothing options menu
        initOptions()
    }
    
    func initOptions() {
        // Add available clothing options to choose from
        clothingOptions = [[ShortSleeve(), LongSleeve()],
                           [Overalls(), Dress()]]
        
        // Choose the percent of the screen that the options will take up when selecting new clothing
        let percentOfContent = CGFloat(0.8)
        let percentOfSpacing = 1 - percentOfContent
        let optionWidth = (phoneWidth * percentOfContent) / CGFloat(clothingOptions[0].count)
        let spacingWidth = (phoneWidth * percentOfSpacing) / CGFloat(clothingOptions[0].count + 1)
        
        // Set the frame (width/height/over/down) for the clothing options
        for i in 0...(clothingOptions.count - 1) {
            let center = (phoneHeight / 2)
            let contentHeight = (CGFloat(i) - (CGFloat(clothingOptions.count) / CGFloat(2)))
            let spacingHeight = (CGFloat(i) - ((CGFloat(clothingOptions.count) / CGFloat(2)) - 0.5))
            let down = center + (optionWidth * contentHeight) + (spacingWidth * spacingHeight)
            for j in 0...(clothingOptions[i].count - 1) {
                let over = (CGFloat(j) * optionWidth) + (CGFloat(j + 1) * spacingWidth)
                clothingOptions[i][j].frame = CGRect(x: over, y: down, width: optionWidth, height: optionWidth)
            }
        }
        
        // Add gesture recognizers for the clothing options when choosing a new piece of clothing
        for i in 0...(clothingOptions.count - 1) {
            optionsGestureRecognizers.append([])
            for j in 0...(clothingOptions[i].count - 1) {
                optionsGestureRecognizers[i].append(UILongPressGestureRecognizer(target: self, action: #selector(self.pickedOutClothes(_:))))
                optionsGestureRecognizers[i][j].minimumPressDuration = 0
            }
        }
    }
    
}
