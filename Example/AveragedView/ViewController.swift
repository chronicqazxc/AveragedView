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
    
    var typeSwitch: UISegmentedControl?
    @IBOutlet weak var slider: UISlider!
    var viewsBottomObject: UIView?
    var button: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.darkGray()
        button.addTarget(self, action:#selector(ViewController.processViews(sender:)) , for: .touchUpInside)
        button.setTitle("1", for: UIControlState(rawValue:0))
        button.tintColor = UIColor.white()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        self.typeSwitch = UISegmentedControl(items: ["Horizontal",
                                                     "Vertical",
                                                     "Auto"])
        self.typeSwitch?.selectedSegmentIndex = 0
        self.typeSwitch?.addObserver(self, forKeyPath: "selectedSegmentIndex", options: .new, context: nil)
        self.typeSwitch?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.typeSwitch!)
        
        self.view.addConstraints(self.buttonAndSwitchConstraints(button: button,
                                                                 typeSwitch: self.typeSwitch!,
                                                                 heigt: 50.0,
                                                                 padding: 10.0))
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
            self.processViews(sender: self.button!)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
        if keyPath == "selectedSegmentIndex" {
            self.processViews(sender: self.button!)
        }
    }
    
    deinit {
        self.slider.removeObserver(self, forKeyPath: "selectedSegmentIndex", context: nil)
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
    
    func buttonAndSwitchConstraints(button: UIButton, typeSwitch: UISegmentedControl, heigt: Float ,padding: Float) -> Array<NSLayoutConstraint> {
        
        let constraints = NSMutableArray(array: NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[button]-padding-[typeSwitch]-padding-|",
                                                                               options: NSLayoutFormatOptions(rawValue: 0),
                                                                               metrics: ["padding":padding],
                                                                               views: ["button":button,
                                                                                       "typeSwitch":typeSwitch]))
        
        constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "V:[button(==heigt)]-padding-|",
                                                                    options: NSLayoutFormatOptions(rawValue: 0),
                                                                    metrics: ["padding":padding, "heigt":heigt],
                                                                    views: ["button":button]))
        
        constraints.add(NSLayoutConstraint(item: typeSwitch,
                                           attribute: .height,
                                           relatedBy: .equal,
                                           toItem: button,
                                           attribute: .height,
                                           multiplier: 1.0,
                                           constant: 1.0))
        
        constraints.add(NSLayoutConstraint(item: typeSwitch,
                                           attribute: .width,
                                           relatedBy: .equal,
                                           toItem: button,
                                           attribute: .width,
                                           multiplier: 4/5,
                                           constant: 1.0))
        
        constraints.add(NSLayoutConstraint(item: typeSwitch,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: button,
                                           attribute: .top,
                                           multiplier: 1.0,
                                           constant: 1.0))
        
        return constraints.copy() as! Array<NSLayoutConstraint>
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processViews(sender: UIControl) {
        var type: AveragedViewType?
        
        if self.typeSwitch?.selectedSegmentIndex == 0 {
            type = .Horizontal
        } else if self.typeSwitch?.selectedSegmentIndex == 1 {
            type = .Vertical
        } else {
            print("Haven't implement yet")
            return
        }
        
        let constraints = AveragedView.averagedViewConstraints(bottomObject: self.slider,
                                                               padding: 10.0,
                                                               randomBackgroundColor: true,
                                                               type: type!,
                                                               viewsForAverage:
            { [weak self] _ in
                let tag = 999
                for view in (self?.view.subviews)! {
                    if view.tag == tag {
                        view.removeFromSuperview()
                    }
                }
                
                let views = NSMutableArray()
                
                var button: UIButton?
                if sender.classForCoder == UIButton.self {
                    button = sender as? UIButton
                } else {
                    button = self?.button
                }
                
                let numberOfViews = Int((button?.title(for: UIControlState(rawValue: 0))!)!)!
                
                for _ in 1 ... numberOfViews {
                    let view = UIView(frame: CGRect.zero)
                    view.tag = tag
                    view.translatesAutoresizingMaskIntoConstraints = false
                    self?.view.addSubview(view)
                    views.add(view)
                }
                return views.copy() as! [UIView]
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
