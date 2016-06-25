//
//  ViewController.swift
//  AutoLayoutTest
//
//  Created by Wayne Hsiao on 6/25/16.
//  Copyright © 2016 Wayne Hsiao. All rights reserved.
//

import UIKit
import AveragedView

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    var viewsBottomObject: UIView?
    var button: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.darkGray()
        button.addTarget(self, action:#selector(ViewController.processViews(button:)) , for: .touchUpInside)
        button.setTitle("1", for: UIControlState(rawValue:0))
        button.tintColor = UIColor.white()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        self.view.addConstraints(self.buttonConstraints(button: button, heigt: 50.0, padding: 10.0))
        self.button = button
        
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        self.slider.minimumValue = 1
        self.slider.maximumValue = 10
        self.view.addConstraints(self.sliderConstraints(slider: self.slider, button: button, padding: 10.0))
        
        self.viewsBottomObject = self.slider
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let title = NSString(format: "%d", lroundf(sender.value))
        if title != self.button?.title(for: UIControlState(rawValue: 0)) {
            self.button?.setTitle(title as String, for: UIControlState(rawValue:0))
        }
    }
    
    func sliderConstraints(slider: UISlider, button: UIButton, padding: Float) -> Array<NSLayoutConstraint> {
        
        let constraints = NSMutableArray()
        
        constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[slider]-padding-|",
                                                                    options: NSLayoutFormatOptions(rawValue: 0),
                                                                    metrics: ["padding":padding],
                                                                    views: ["slider":slider]))
        constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "V:[slider(==20)]-padding-[button]",
                                                                    options: NSLayoutFormatOptions(rawValue: 0),
                                                                    metrics: ["padding":padding],
                                                                    views: ["slider":slider,
                                                                            "button":button]))
        return constraints.copy() as! Array<NSLayoutConstraint>
    }
    
    func buttonConstraints(button: UIButton, heigt: Float ,padding: Float) -> Array<NSLayoutConstraint> {
        
        let constraints = NSMutableArray(array: NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[button]-padding-|",
                                                                               options: NSLayoutFormatOptions(rawValue: 0),
                                                                               metrics: ["padding":padding],
                                                                               views: ["button":button]))
        
        constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "V:[button(==heigt)]-padding-|",
                                                                    options: NSLayoutFormatOptions(rawValue: 0),
                                                                    metrics: ["padding":padding, "heigt":heigt],
                                                                    views: ["button":button]))
        return constraints.copy() as! Array<NSLayoutConstraint>
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processViews(button: UIButton) {
        for view in self.view.subviews {
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
        
        let numberOfViews = Int((self.button?.title(for: UIControlState(rawValue: 0)))!)!
        
        let constraints = AveragedView.averagedViewConstraints(sum: numberOfViews,
                                                               tag: 999,
                                                               bottomObject: self.slider,
                                                               padding: 10.0,
                                                               isAddedGeneratedViews:
            { [weak self] views in
                for view in views {
                    self?.view.addSubview(view)
                }
                return true
            }
        )
        
        self.view.addConstraints(constraints)
        
        self.view.updateConstraintsIfNeeded()
        
        AveragedView.ambiguityTest(view: self.view)
        for view in self.view.subviews {
            AveragedView.ambiguityTest(view: view)
        }
    }
}
