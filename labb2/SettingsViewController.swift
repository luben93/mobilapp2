//
//  SettingsViewController.swift
//  labb2
//
//  Created by Carl-Johan Dahlman on 2016-11-30.
//  Copyright © 2016 lucas persson. All rights reserved.
//

import UIKit
class SettingsViewController:  UIViewController
{
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("colors.")
    static let lineColorSettingTag = "lineColor"
    static let backgroundColorSettingTag = "backgroundColor"
    
    @IBOutlet weak var lineColorButton: UIButton!
    @IBOutlet weak var lineColorBox: UIView!
    @IBOutlet weak var backColorButton: UIButton!
    
    @IBOutlet weak var backColorBox: UIView!
    @IBOutlet weak var theView: UIView!
    
    var selectedButton:UIButton = UIButton()
    
    
    let colorslider = ColorSlider()
    var selectedColor: UIColor = UIColor.green
    
    override func viewDidLoad() {
        colorslider.frame = CGRect(x: 0, y: 0, width: 40, height: 350)
        //view.addSubview(colorslider)
        theView.addSubview(colorslider)
        colorslider.addTarget(self, action: #selector(SettingsViewController.changedColor(_:)), for: .valueChanged)
        colorslider.addTarget(self, action: #selector(SettingsViewController.newColor(_:)), for: .touchUpInside)
        loadColors()
        
        
        
    }
    
    func loadColors() {
        var lineColor = UIColor.black
        var backColor = UIColor.black
        if let loadedColor = NSKeyedUnarchiver.unarchiveObject(withFile: SettingsViewController.ArchiveURL.path + SettingsViewController.lineColorSettingTag){
            lineColor = loadedColor as! UIColor
        }
        if let loadedColor = NSKeyedUnarchiver.unarchiveObject(withFile: SettingsViewController.ArchiveURL.path + SettingsViewController.backgroundColorSettingTag){
            backColor = loadedColor as! UIColor
        }
        backColorButton.setTitleColor(backColor, for: UIControlState.normal)
        lineColorButton.setTitleColor(lineColor, for: UIControlState.normal)
        

    }
    
    func newColor(_ slider: ColorSlider) {
        if  selectedButton == backColorButton || selectedButton == lineColorButton {
            
            let color = slider.color
            selectedColor = color
            if selectedButton == lineColorButton {
                // save color for line
                NSKeyedArchiver.archiveRootObject(selectedColor, toFile: SettingsViewController.ArchiveURL.path + SettingsViewController.lineColorSettingTag)
                //UserDefaults.standard.set(selectedColor, forKey: SettingsViewController.lineColorSettingTag)
                //UserDefaults.standard.synchronize()
                
            }
            if selectedButton == backColorButton {
                // save color for back
                NSKeyedArchiver.archiveRootObject(selectedColor, toFile: SettingsViewController.ArchiveURL.path + SettingsViewController.backgroundColorSettingTag)
                
                //UserDefaults.standard.set(selectedColor, forKey: SettingsViewController.backgroundColorSettingTag)
                //UserDefaults.standard.synchronize()
            }
    }
    }
    
    func changedColor(_ slider: ColorSlider) {
        
        if  selectedButton == backColorButton || selectedButton == lineColorButton {
            
        let color = slider.color
        selectedColor = color
        if selectedButton == lineColorButton {
            // save color for line
            lineColorButton.setTitleColor(selectedColor, for: UIControlState.normal)
            lineColorBox.backgroundColor = selectedColor
            
            //UserDefaults.standard.set(selectedColor, forKey: SettingsViewController.lineColorSettingTag)
            //UserDefaults.standard.synchronize()

        }
        if selectedButton == backColorButton {
            // save color for back
            backColorButton.setTitleColor(selectedColor, for: UIControlState.normal)
            backColorBox.backgroundColor = selectedColor
            
            //UserDefaults.standard.set(selectedColor, forKey: SettingsViewController.backgroundColorSettingTag)
            //UserDefaults.standard.synchronize()

        }
        
            print("Color: \(color.description)")
        
        
        }
    }
    
    @IBAction func lineColorSelected(_ sender: UIButton) {
        if  selectedButton == lineColorButton {
            selectedButton = UIButton()
            lineColorButton.backgroundColor = UIColor.white
        }else {
            selectedButton.backgroundColor = UIColor.white
            selectedButton = lineColorButton
            lineColorButton.backgroundColor = UIColor.gray
        }
        
        
    }
    
    @IBAction func backColorSelected(_ sender: UIButton) {
        if  selectedButton == backColorButton {
            selectedButton = UIButton()
            backColorButton.backgroundColor = UIColor.white
        }else {
            selectedButton.backgroundColor = UIColor.white
            selectedButton = backColorButton
            backColorButton.backgroundColor = UIColor.gray
        }
        
    }
}
