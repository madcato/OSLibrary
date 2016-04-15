//
//  OSCircleImageView.swift
//  CircleImageProject
//
//  Created by Daniel Vela on 15/04/16.
//  Copyright © 2016 Daniel Vela. All rights reserved.
//

import UIKit

@IBDesignable
class OSCircleImageView: UIImageView {

    @IBInspectable var radious: Int = 100 {
        didSet {
            createMask()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func createMask() {
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
