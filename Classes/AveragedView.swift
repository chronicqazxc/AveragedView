//
//  AveragedView.swift
//  AutoLayoutTest
//
//  Created by Wayne Hsiao on 6/25/16.
//  Copyright © 2016 Wayne Hsiao. All rights reserved.
//

import UIKit

public enum AveragedViewType {
    case Horizon, Vertical
}

public class AveragedView: UIView {
    func averageViews(sum: Int, tag: Int) -> Array<UIView> {
        let viewsArray = NSMutableArray()
        for _ in 0 ... sum {
            let view = UIView(frame: CGRect.zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor.randomColor()
            view.tag = tag
            viewsArray.add(view)
        }
        return viewsArray.copy() as! Array<UIView>
    }
    
    func averageViewConstraints(views: Array<UIView>, bottomObject: AnyObject?, padding: Float) -> Array<NSLayoutConstraint> {
        return AveragedView.viewConstraints(views: views ,
                                            bottomObject: bottomObject,
                                            padding: padding)
    }
    
    public static func averagedViewConstraints(bottomObject: AnyObject?,
                                               padding: Float,
                                               randomBackgroundColor: Bool,
                                               type: AveragedViewType,
                                               viewsForAverage: () -> Array<UIView>) -> Array<NSLayoutConstraint> {
        let views = viewsForAverage()
        if randomBackgroundColor {
            for view in views {
                view.backgroundColor = UIColor.randomColor()
            }
        }
        
        var constraints: Array<NSLayoutConstraint>
        if type == .Vertical {
            constraints = AveragedView.verticalViewConstraints(views: views,
                                                               bottomObject: bottomObject,
                                                               padding: padding)
        } else {
            constraints = AveragedView.viewConstraints(views: views,
                                                       bottomObject: bottomObject,
                                                       padding: padding)
        }
        return constraints
    }
    
    public static func averagedViewConstraints(sum: Int,
                                               bottomObject: AnyObject?,
                                               padding: Float,
                                               autoBackGroundColor: Bool,
                                               type: AveragedViewType,
                                               isAddedGeneratedViews: (views:Array<UIView>) -> Bool) -> Array<NSLayoutConstraint> {
        
        let viewsArray = NSMutableArray()
        for _ in 0 ... sum-1 {
            let view = UIView(frame: CGRect.zero)
            if autoBackGroundColor {
                view.backgroundColor = UIColor.randomColor()
            }
            viewsArray.add(view)
        }
        
        let views = viewsArray.copy() as! Array<UIView>
        
        if isAddedGeneratedViews(views: views) {
            
            var constraints: Array<NSLayoutConstraint>
            if type == .Vertical {
                constraints = AveragedView.verticalViewConstraints(views: views,
                                                                   bottomObject: bottomObject,
                                                                   padding: padding)
            } else {
                constraints = AveragedView.viewConstraints(views: views,
                                                           bottomObject: bottomObject,
                                                           padding: padding)
            }
            return constraints
        } else {
            return []
        }
    }
    
    public static func averagedViewsAndConstraints(sum: Int,
                                                   tag: Int,
                                                   bottomObject: AnyObject?,
                                                   padding: Float,
                                                   containerView: UIView ) -> (views:Array<UIView>, constraints:Array<NSLayoutConstraint>) {

        let viewsArray = NSMutableArray()
        for _ in 0 ... sum-1 {
            let view = UIView(frame: CGRect.zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor.randomColor()
            view.tag = tag
            viewsArray.add(view)
            containerView.addSubview(view)
        }
        
        let views = viewsArray.copy() as! Array<UIView>
        
        let constraints = AveragedView.viewConstraints(views: views ,
                                                       bottomObject: bottomObject,
                                                       padding: padding)
        return (views, constraints)
    }
    
    private static func verticalViewConstraints(views: Array<UIView>,
                                                bottomObject: AnyObject?,
                                                padding: Float) -> Array<NSLayoutConstraint> {
        
        func constraintsOfWidhtHeightBaseLine(firstView: UIView, view: UIView) -> Array<NSLayoutConstraint> {
            return [
                NSLayoutConstraint(item: firstView,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .width,
                                   multiplier: 1.0,
                                   constant: 1.0),
                
                NSLayoutConstraint(item: firstView,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .height,
                                   multiplier: 1.0,
                                   constant: 1.0),
                
                NSLayoutConstraint(item: firstView,
                                   attribute: .left,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .left,
                                   multiplier: 1.0,
                                   constant: 1.0)]
        }
        
        let constraints = NSMutableArray()
        var visualFormat = NSMutableString() as String
        let viewsDictionary = NSMutableDictionary()
        var firstView = UIView()
        var firstViewName = ""
        
        for view in views {
            let index = views.index(of: view)
            let viewName = NSString(format: "view%d", index!) as String
            if index == 0 {
                firstView = view
                firstViewName = viewName
                if views.count == 1 {
                    visualFormat.append(NSString(format: "V:|-padding-[%@]-padding-[bottomObject]", viewName) as String)
                } else {
                    visualFormat.append(NSString(format: "V:|-padding-[%@]", viewName) as String)
                }
            } else if index == (views.count - 1) {
                visualFormat.append(NSString(format: "-padding-[%@]-padding-[bottomObject]", viewName) as String)
                constraints.addObjects(from: constraintsOfWidhtHeightBaseLine(firstView: firstView, view: view))
            } else {
                visualFormat.append(NSString(format: "-padding-[%@]", viewName) as String)
                constraints.addObjects(from: constraintsOfWidhtHeightBaseLine(firstView: firstView, view: view))
            }
            
            viewsDictionary.setObject(view, forKey: viewName)
        }
        viewsDictionary.setObject(bottomObject!, forKey: "bottomObject")
        
        let viewsDic = viewsDictionary.copy() as! [String : AnyObject]
        constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                                                    options: NSLayoutFormatOptions(rawValue: 0),
                                                                    metrics: ["padding": padding],
                                                                    views: viewsDic))
        
        let formatString = NSString(format: "H:|-padding-[%@]-padding-|", firstViewName) as String
        
        constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: formatString,
                                                                    options: NSLayoutFormatOptions(rawValue: 0),
                                                                    metrics: ["padding": padding],
                                                                    views: [firstViewName: firstView]))
        return constraints.copy() as! Array<NSLayoutConstraint>
        
    }
    
    private static func viewConstraints(views: Array<UIView>, bottomObject: AnyObject?, padding: Float) -> Array<NSLayoutConstraint> {
        
        func constraintsOfWidhtHeightBaseLine(firstView: UIView, view: UIView) -> Array<NSLayoutConstraint> {
            return [
                NSLayoutConstraint(item: firstView,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .width,
                                   multiplier: 1.0,
                                   constant: 1.0),
                
                NSLayoutConstraint(item: firstView,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .height,
                                   multiplier: 1.0,
                                   constant: 1.0),
                
                NSLayoutConstraint(item: firstView,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 1.0)]
        }
        
        let constraints = NSMutableArray()
        
        var visualFormat = NSMutableString() as String
        let viewsDictionary = NSMutableDictionary()
        var firstView = UIView()
        var firstViewName = ""
        
        for view in views {
            let index = views.index(of: view)
            let viewName = NSString(format: "view%d", index!) as String
            if index == 0 {
                firstView = view
                firstViewName = viewName
                if views.count == 1 {
                    visualFormat.append(NSString(format: "H:|-padding-[%@]-padding-|", viewName) as String)
                } else {
                    visualFormat.append(NSString(format: "H:|-padding-[%@]", viewName) as String)
                }
            } else if index == (views.count - 1) {
                visualFormat.append(NSString(format: "-padding-[%@]-padding-|", viewName) as String)
                constraints.addObjects(from: constraintsOfWidhtHeightBaseLine(firstView: firstView, view: view))
            } else {
                visualFormat.append(NSString(format: "-padding-[%@]", viewName) as String)
                constraints.addObjects(from: constraintsOfWidhtHeightBaseLine(firstView: firstView, view: view))
            }
            
            viewsDictionary.setObject(view, forKey: viewName)
        }
        let viewsDic = viewsDictionary.copy() as! [String : AnyObject]
        constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                                                    options: NSLayoutFormatOptions(rawValue: 0),
                                                                    metrics: ["padding": padding],
                                                                    views: viewsDic))
        
        let formatString = NSString(format: "V:|-padding-[%@]-padding-[bottomObject]", firstViewName) as String
        
        constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: formatString,
                                                                    options: NSLayoutFormatOptions(rawValue: 0),
                                                                    metrics: ["padding": padding],
                                                                    views: ["bottomObject": bottomObject!,
                                                                            firstViewName: firstView]))
        return constraints.copy() as! Array<NSLayoutConstraint>
    }
    
    public static func ambiguityTest(view: UIView) {
        let format = NSString(format: "<%@:0x%0x>: %@", NSStringFromClass(view.classForCoder), unsafeAddress(of: view), view.hasAmbiguousLayout() ? "Ambiguous": "Unambiguous")
        print(format)
    }
    
    deinit {
        print("AveragedView deinit")
    }
}
