//
//  OSCircleLabel.swift
//  CircleImageProject
//
//  Created by Daniel Vela on 15/04/16.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import UIKit

@IBDesignable
class OSCircleLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        createMask()
    }
    
    func createMask() {
        var radious = self.bounds.size.height < self.bounds.size.width ? self.bounds.size.height : self.bounds.size.width
        radious = radious / 2
        
        // Calculate bounding box with radious from the center of the view
        let x = (self.bounds.size.width / 2) - CGFloat(radious)
        let y = (self.bounds.size.height / 2) - CGFloat(radious)
        let width = CGFloat(radious) * 2
        let height = CGFloat(radious) * 2
        
        let circleLayer = CAShapeLayer.init()
        circleLayer.path = UIBezierPath.init(ovalInRect: CGRectMake(x, y, width, height)).CGPath
        
        self.layer.mask = circleLayer;
    }

}
