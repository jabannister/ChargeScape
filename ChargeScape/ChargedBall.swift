//
//  ChargedBall.swift
//  ChargeScape
//
//  Created by Jeremy Bannister on 5/8/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ChargedBall: JABTouchableView, PhysicalObject {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    
    // MARK: State
    public var isBeingHeld = false
    public var markedForDeletion = false
    
    public var position = Vector()
    public var dimensions = Size(width: 0.4, height: 0.4, depth: 0)
    public var velocity = Vector()
    public var mass = CGFloat(1) {
        didSet {
            if mass <= 0 {
                mass = 1
                print("Setting mass to default (1) because it was set less then or equal to 0")
            }
        }
    }
    public var charge = CGFloat(0)
    
    // MARK: UI
    var imageView = UIImageView()
    
    // MARK: Parameters
    
    
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public init (mass: CGFloat) {
        self.mass = mass
        super.init()
        
        if !iPad {
            dimensions = Size(width:0.8, height:0.8, depth:0)
        }
        
    }
    
    
    convenience override init () {
        self.init(mass: 2)
        
    }
    
    
    
    required public init(coder aDecoder: NSCoder) {
        self.mass = 0
        super.init()
        print("Should not be initializing from coder \(self)")
    }
    
    
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        addImageView()
    }
    
    override public func updateAllUI() {
        
        configureImageView()
        positionImageView()
        
    }
    
    
    
    // MARK: Adding
    func addImageView () {
        addSubview(imageView)
    }
    
    
    // MARK: Basketball
    func configureImageView () {
        
        if charge > 0 {
            imageView.image = UIImage(named: "Positive Charge Icon.png")
        } else if charge < 0 {
            imageView.image = UIImage(named: "Negative Charge Icon.png")
        } else {
            imageView.image = UIImage(named: "Neutral Charge Icon.png")
        }
        imageView.userInteractionEnabled = false
        
    }
    
    func positionImageView () {
        
        imageView.frame = relativeFrame
        
    }
}