//
//  ControlPanel.swift
//  ChargeScape
//
//  Created by Jeremy Bannister on 5/9/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ControlPanel: JABView, BallCountControlDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    var delegate: ControlPanelDelegate?
    
    // MARK: State
    var ballCount = 0
    var instructionLabelHidden = false
    
    // MARK: UI
    let instructionLabel = UILabel()
    let ballCountControl = BallCountControl()
    let titleLabel = UILabel()
    
    let gravitySwitch = UISwitch()
    let gravitySwitchTitle = UILabel()
    
    let superChargeSwitch = UISwitch()
    let superChargeSwitchTitle = UILabel()
    
    // MARK: Parameters
    let controlPanelFontName = "Optima-ExtraBlack"
    
    var leftBufferForInstructionLabel = CGFloat(30)
    var bufferBetweenInstructionLabelAndGravitySwitch = CGFloat(55)
    var bufferBetweenGravitySwitchAndSuperchargeSwitch = CGFloat(50)
    
    var rightBufferForBallCountControl = CGFloat(40)
    var widthOfBallCountControl = CGFloat(250)
    var heightOfBallCountControl = CGFloat(80)
    
    var numberOfLinesForInstructionLabel = 2
    
    
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
            numberOfLinesForInstructionLabel = 2
            rightBufferForBallCountControl = 10
            widthOfBallCountControl = 100
            heightOfBallCountControl = 50
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
        
        addInstructionLabel()
        addBallCountControl()
        addTitleLabel()
        
        addGravitySwitch()
        addGravitySwitchTitle()
        
        addSuperChargeSwitch()
        addSuperChargeSwitchTitle()
        
    }
    
    override public func updateAllUI() {
        
        configureInstructionLabel()
        positionInstructionLabel()
        
        configureBallCountControl()
        positionBallCountControl()
        
        configureTitleLabel()
        positionTitleLabel()
        
        
        
        
        configureGravitySwitch()
        positionGravitySwitch()
        
        configureGravitySwitchTitle()
        positionGravitySwitchTitle()
        
        
        configureSuperChargeSwitch()
        positionSuperChargeSwitch()
        
        configureSuperChargeSwitchTitle()
        positionSuperChargeSwitchTitle()
        
        
        
        
        makeAdjustments()
        
    }
    
    
    
    // MARK: Adding
    func addInstructionLabel () {
        addSubview(instructionLabel)
    }
    
    func addBallCountControl () {
        addSubview(ballCountControl)
    }
    
    func addTitleLabel () {
        addSubview(titleLabel)
    }
    
    
    
    
    func addGravitySwitch () {
        addSubview(gravitySwitch)
    }
    
    func addGravitySwitchTitle () {
        addSubview(gravitySwitchTitle)
    }
    
    
    
    func addSuperChargeSwitch () {
        addSubview(superChargeSwitch)
    }
    
    func addSuperChargeSwitchTitle () {
        addSubview(superChargeSwitchTitle)
    }
    
    
    
    
    // MARK: Instruction Label
    func configureInstructionLabel () {
        
        instructionLabel.text = "Tap on a ball to change its charge"
        instructionLabel.textAlignment = NSTextAlignment.Center
        instructionLabel.numberOfLines = numberOfLinesForInstructionLabel
        
        
        if iPad {
            instructionLabel.font = UIFont(name: controlPanelFontName, size: 12)
        } else {
            instructionLabel.font = UIFont(name: controlPanelFontName, size: 12)
        }
        
        
        if instructionLabelHidden {
            instructionLabel.opacity = 0
        } else {
            instructionLabel.opacity = 1
        }
    }
    
    func positionInstructionLabel () {
        if !instructionLabelHidden {
            if instructionLabel.text != nil {
                
                var newFrame = CGRectZero
                var size = instructionLabel.font.sizeOfString(instructionLabel.text!, constrainedToWidth: 110)
                
                
                newFrame.size.width = size.width
                newFrame.size.height = size.height
                
                newFrame.origin.x = leftBufferForInstructionLabel
                newFrame.origin.y = (height - newFrame.size.height)/2
                
                instructionLabel.frame = newFrame
            }
        } else {
            instructionLabel.frame = CGRectZero
        }
        
    }
    
    
    // MARK: Ball Count Control
    func configureBallCountControl () {
        
        ballCountControl.delegate = self
        ballCountControl.ballCount = ballCount
        ballCountControl.fontName = controlPanelFontName
        
        ballCountControl.updateAllUI()
    }
    
    func positionBallCountControl () {
        var newFrame = CGRectZero
        
        newFrame.size.width = widthOfBallCountControl
        newFrame.size.height = heightOfBallCountControl
        
        newFrame.origin.x = width - newFrame.size.width - rightBufferForBallCountControl
        newFrame.origin.y = heightOfStatusBar + ((height - heightOfStatusBar) - heightOfBallCountControl)/2
        
        if !iPad {
            newFrame.size.width += 70
            newFrame.size.height += 20
            newFrame.origin.x -= 70
            newFrame.origin.y -= 20
        } else {
            newFrame.origin.x -= 60
            newFrame.origin.y -= 20
            newFrame.size.width += 70
            newFrame.size.height += 20
        }
        
        
        ballCountControl.frame = newFrame
    }
    
    
    // MARK: Title Label
    func configureTitleLabel () {
        
        titleLabel.text = "ChargeScape"
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: controlPanelFontName, size: 30)
        
        if !iPad {
            titleLabel.opacity = 0
        }
        
    }
    
    func positionTitleLabel () {
        if titleLabel.text != nil {
            
            var newFrame = CGRectZero
            let size = titleLabel.font.sizeOfString(titleLabel.text!, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = (width - newFrame.size.width)/2
            newFrame.origin.y = (height - newFrame.size.height)/2
            
            titleLabel.frame = newFrame
        }
    }
    
    
    // MARK: Gravity Switch
    func configureGravitySwitch () {
        
        gravitySwitch.addTarget(self, action: "gravitySwitchFlipped", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func positionGravitySwitch () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = 0 // Switch has automatic size
        newFrame.size.height = 0
        
        newFrame.origin.x = titleLabel.x - gravitySwitch.width - 35
        newFrame.origin.y = titleLabel.y + (titleLabel.height - gravitySwitch.height)/2
        
        if !iPad {
            newFrame.origin.x = instructionLabel.right + bufferBetweenInstructionLabelAndGravitySwitch
            newFrame.origin.y -= 5
        }
        
        gravitySwitch.frame = newFrame
        
        
    }
    
    // MARK: Gravity Switch Title
    func configureGravitySwitchTitle () {
        
        gravitySwitchTitle.text = "Gravity"
        gravitySwitchTitle.textAlignment = NSTextAlignment.Center
        gravitySwitchTitle.font = UIFont(name: controlPanelFontName, size: 14)
        
    }
    
    func positionGravitySwitchTitle () {
        
        var newFrame = CGRectZero
        if gravitySwitchTitle.text != nil {
            
            let size = gravitySwitchTitle.font.sizeOfString(gravitySwitchTitle.text!, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = gravitySwitch.x + (gravitySwitch.width - gravitySwitchTitle.width)/2
            newFrame.origin.y = gravitySwitch.bottom + 5
            
            gravitySwitchTitle.frame = newFrame
            
        }
    }
    
    
    
    
    
    // MARK: Super Charge Switch
    func configureSuperChargeSwitch () {
        
        superChargeSwitch.addTarget(self, action: "superChargeSwitchFlipped", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func positionSuperChargeSwitch () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = 0 // Switch has automatic size
        newFrame.size.height = 0
        
        newFrame.origin.x = titleLabel.right + 35
        newFrame.origin.y = titleLabel.y + (titleLabel.height - superChargeSwitch.height)/2
        
        if !iPad {
            newFrame.origin.x = gravitySwitch.right + bufferBetweenGravitySwitchAndSuperchargeSwitch
            newFrame.origin.y -= 5
        }
        
        superChargeSwitch.frame = newFrame
        
    }
    
    
    // MARK: Super Charge Switch Title
    func configureSuperChargeSwitchTitle () {
        
        superChargeSwitchTitle.text = "Super Charge"
        superChargeSwitchTitle.textAlignment = NSTextAlignment.Center
        superChargeSwitchTitle.font = UIFont(name: controlPanelFontName, size: 14)
        
    }
    
    func positionSuperChargeSwitchTitle () {
        
        var newFrame = CGRectZero
        if superChargeSwitchTitle.text != nil {
            
            let size = superChargeSwitchTitle.font.sizeOfString(superChargeSwitchTitle.text!, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = superChargeSwitch.x + (superChargeSwitch.width - superChargeSwitchTitle.width)/2
            newFrame.origin.y = superChargeSwitch.bottom + 5
            
            superChargeSwitchTitle.frame = newFrame
            
        }
        
    }
    
    
    
    // MARK: Adjustments
    private func makeAdjustments () { // This method is to adjust for the overlapping of UI that occurs on a 3.5-Inch screen
        if width <= 480 {
            instructionLabelHidden = true
        } else {
            instructionLabelHidden = false
        }
    }
    
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
    // MARK: Switches
    func gravitySwitchFlipped () {
        delegate?.controlPanelGravitySwitchFlipped(gravitySwitch.on)
    }
    
    func superChargeSwitchFlipped () {
        delegate?.controlPanelSuperChargeSwitchFlipped(superChargeSwitch.on)
    }
    
    
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Ball Count Control
    public func ballCountControlDeleteButtonWasPressed(ballCountControl: BallCountControl) {
        delegate?.controlPanelDeleteBallButtonWasPressed(self)
    }
    
    public func ballCountControlAddButtonWasPressed(ballCountControl: BallCountControl) {
        delegate?.controlPanelAddBallButtonWasPressed(self)
    }
    
}



public protocol ControlPanelDelegate {
    
    func controlPanelDeleteBallButtonWasPressed(controlPanel: ControlPanel)
    func controlPanelAddBallButtonWasPressed(controlPanel: ControlPanel)
    
    func controlPanelGravitySwitchFlipped(on: Bool)
    func controlPanelSuperChargeSwitchFlipped(on: Bool)
    
}
