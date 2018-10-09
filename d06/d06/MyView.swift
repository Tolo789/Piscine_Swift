//
//  MyView.swift
//  d06
//
//  Created by Claudio MUTTI on 10/9/18.
//  Copyright © 2018 Claudio MUTTI. All rights reserved.
//

import Foundation
import UIKit

class MyForm : UIView {
    static private let viewColors : [UIColor] = [.red, .blue, .green, .yellow, .gray, .cyan]
    private var size: CGFloat = 100
    private var isCircle = false
    
    init(x: CGFloat, y: CGFloat) {
        super.init(frame: CGRect(x: 0, y: y - 0, width: size, height: size))
        self.center = CGPoint(x: x, y: y)
        
        self.backgroundColor = MyForm.viewColors[Int(arc4random_uniform(UInt32(MyForm.viewColors.count)))]
        
        if Int(arc4random_uniform(UInt32(2))) == 1 {
            self.layer.cornerRadius = (self.frame.size.width / 2)
            isCircle = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return (isCircle ? .ellipse : .rectangle)
    }
    
    func changePosition(newX: CGFloat, newY: CGFloat) {
        self.center = CGPoint(x: newX, y: newY)
    }
    
    func changeScale(scale: CGFloat) {
        self.transform = self.transform.scaledBy(x: scale, y: scale)
    }
    
    func changeRotation(by rot: CGFloat) {
        self.transform = self.transform.rotated(by: rot)
        
    }
}
