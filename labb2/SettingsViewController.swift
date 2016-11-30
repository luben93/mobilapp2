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
    @IBOutlet weak var lineColorButton: UIButton!
    @IBOutlet weak var lineColorBox: UIView!
    @IBOutlet weak var backColorButton: UIButton!
    
    @IBOutlet weak var backColorBox: UIView!
    @IBOutlet weak var theView: UIView!
    
    var selectedButton:UIButton = UIButton()
    
    
    let colorslider = ColorSlider()
    
    override func viewDidLoad() {
        colorslider.frame = CGRect(x: 0, y: 0, width: 40, height: 350)
        //view.addSubview(colorslider)
        theView.addSubview(colorslider)
        colorslider.addTarget(self, action: #selector(SettingsViewController.changedColor(_:)), for: .valueChanged)
        
        
        
        
    }
    
    
    func changedColor(_ slider: ColorSlider) {
        var color = slider.color
        print("Color: \(color.description)")
    }
    
    @IBAction func lineColorSelected(_ sender: UIButton) {
        
    }
    
    @IBAction func backColorSelected(_ sender: UIButton) {
        
    }
}
