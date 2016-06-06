//
//  ApplicationRoot.swift
//  ChargeScape
//
//  Created by Jeremy Bannister on 5/8/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ApplicationRoot: JABApplicationRoot, JugglingFieldDelegate, ControlPanelDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    
    // MARK: State
    
    // MARK: UI
    let jugglingField = JugglingField()
    let controlPanel = ControlPanel()
    
    // MARK: Parameters
    var heightOfControlPanel = CGFloat(100)
    
    
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public override init () {
        super.init()
        
        if !iPad {
            heightOfControlPanel = 70
        }
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        
        super.init()
        print("Should not be initializing from coder \(self)")
    }
    
    
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addJugglingField()
        addControlPanel()
        
    }
    
    override public func updateAllUI() {
        
        configureJugglingField()
        positionJugglingField()
        
        configureControlPanel()
        positionControlPanel()
        
    }
    
    
    
    // MARK: Adding
    func addJugglingField () {
        addSubview(jugglingField)
    }
    
    func addControlPanel () {
        addSubview(controlPanel)
    }
    
    
    
    
    // MARK: Juggling Field
    func configureJugglingField () {
        
        jugglingField.delegate = self
        jugglingField.backgroundColor = blackColor
        jugglingField.updateAllUI()
        
    }
    
    func positionJugglingField () {
        var newFrame = CGRectZero
        
        newFrame.size.width = width
        newFrame.size.height = height - heightOfControlPanel
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = heightOfControlPanel
        
        jugglingField.frame = newFrame
    }
    
    // MARK: Control Panel
    func configureControlPanel () {
        
        controlPanel.delegate = self
        controlPanel.backgroundColor = lightGrayColor
        controlPanel.shadowOpacity = 0.1
        controlPanel.shadowOffset = CGSize(width: 0, height: 1)
        
        controlPanel.ballCount = jugglingField.numberOfBalls
        
        controlPanel.updateAllUI()
    }
    
    func positionControlPanel () {
        var newFrame = CGRectZero
        
        newFrame.size.width = width
        newFrame.size.height = heightOfControlPanel
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = 0
        
        controlPanel.frame = newFrame
    }
    
    
    
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    
    // MARK: Juggling Field
    public func jugglingFieldBallCountDidChange(jugglingField: JugglingField) {
        
        configureControlPanel()
        
    }
    
    
    // MARK: Control Panel
    
    public func controlPanelAddBallButtonWasPressed(controlPanel: ControlPanel) {
        
        jugglingField.createJugglingBall()
        updateAllUI()
        
    }
    
    public func controlPanelDeleteBallButtonWasPressed(controlPanel: ControlPanel) {
        
        jugglingField.deleteJugglingBall()
        updateAllUI()
        
    }
    
    
    
    
    public func controlPanelGravitySwitchFlipped(on: Bool) {
        jugglingField.gravity = on
    }
    
    public func controlPanelSuperChargeSwitchFlipped(on: Bool) {
        jugglingField.superCharge = on
    }
    
    
    
}
