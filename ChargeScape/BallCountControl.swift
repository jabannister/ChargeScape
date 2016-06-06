//
//  BallCountControl.swift
//  ChargeScape
//
//  Created by Jeremy Bannister on 5/9/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class BallCountControl: JABView, JABButtonDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    var delegate: BallCountControlDelegate?
    
    // MARK: State
    var ballCount = 0
    
    // MARK: UI
    let ballCountLabel = UILabel()
    let ballCountTitleLabel = UILabel()
    let deleteButton = JABButton()
    let addButton = JABButton()
    
    // MARK: Parameters
    var fontName = ""
    let bufferBetweenCountLabelAndCountTitleLabel = CGFloat(4)
    
    let bufferBetweenButtonsAndCountLabel = CGFloat(25)
    let sizeOfButtons = CGFloat(60)
    
    
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public override init () {
        super.init()
        
        
        
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
        
        addBallCountLabel()
        addBallCountTitleLabel()
        addDeleteButton()
        addAddButton()
        
    }
    
    override public func updateAllUI() {
        
        configureBallCountLabel()
        positionBallCountLabel()
        
        configureBallCountTitleLabel()
        positionBallCountTitleLabel()
        
        configureDeleteButton()
        positionDeleteButton()
        
        configureAddButton()
        positionAddButton()
        
    }
    
    
    
    // MARK: Adding
    func addBallCountLabel () {
        addSubview(ballCountLabel)
    }
    
    func addBallCountTitleLabel () {
        addSubview(ballCountTitleLabel)
    }
    
    func addDeleteButton () {
        addSubview(deleteButton)
    }
    
    func addAddButton () {
        addSubview(addButton)
    }
    
    
    
    
    // MARK: Ball Count Label
    func configureBallCountLabel () {
        
        ballCountLabel.text = "\(ballCount)"
        ballCountLabel.textAlignment = NSTextAlignment.Center
        ballCountLabel.font = UIFont(name: fontName, size: 35)
        
    }
    
    func positionBallCountLabel () {
        
        var newFrame = CGRectZero
        if ballCountLabel.text != nil {
            
            let size = ballCountLabel.font.sizeOfString(ballCountLabel.text!, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = (width - newFrame.size.width)/2
            newFrame.origin.y = 0
            
            ballCountLabel.frame = newFrame
            
        }
    }
    
    
    // MARK: Ball Count Title Label
    func configureBallCountTitleLabel () {
        
        if ballCount != 1 {
            ballCountTitleLabel.text = "Charges"
        } else {
            ballCountTitleLabel.text = "Charge"
        }
        
        ballCountTitleLabel.textAlignment = NSTextAlignment.Center
        ballCountTitleLabel.font = UIFont(name: fontName, size: 18)
        
    }
    
    func positionBallCountTitleLabel () {
        var newFrame = CGRectZero
        if ballCountTitleLabel.text != nil {
            
            let size = ballCountTitleLabel.font.sizeOfString(ballCountTitleLabel.text!, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = ballCountLabel.x + (ballCountLabel.width - newFrame.size.width)/2
            newFrame.origin.y = ballCountLabel.bottom + bufferBetweenCountLabelAndCountTitleLabel
            
            ballCountTitleLabel.frame = newFrame
            
        }
    }
    
    
    // MARK: Delete Button
    func configureDeleteButton () {
        
        deleteButton.type = JABButtonType.Image
        deleteButton.image = UIImage(named: "iOS 7 Left Arrow")
        deleteButton.dimsWhenPressed = true
        deleteButton.buttonDelegate = self
        
        deleteButton.updateAllUI()
        
    }
    
    func positionDeleteButton () {
        var newFrame = CGRectZero
        
        newFrame.size.width = sizeOfButtons
        newFrame.size.height = newFrame.size.width
        
        newFrame.origin.x = ballCountLabel.x - newFrame.size.width - bufferBetweenButtonsAndCountLabel
        newFrame.origin.y = ballCountLabel.y + (ballCountLabel.height + bufferBetweenCountLabelAndCountTitleLabel + ballCountTitleLabel.height - newFrame.size.height)/2
        
        deleteButton.frame = newFrame
    }
    
    // MARK: Add Button
    func configureAddButton () {
        
        addButton.type = JABButtonType.Image
        addButton.image = UIImage(named: "iOS 7 Right Arrow")
        addButton.dimsWhenPressed = true
        addButton.buttonDelegate = self
        
        addButton.updateAllUI()
        
    }
    
    func positionAddButton () {
        var newFrame = CGRectZero
        
        newFrame.size.width = sizeOfButtons
        newFrame.size.height = newFrame.size.width
        
        newFrame.origin.x = ballCountLabel.right + bufferBetweenButtonsAndCountLabel
        newFrame.origin.y = deleteButton.y
        
        addButton.frame = newFrame
    }
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Buttons
    func deleteButtonPressed () {
        delegate?.ballCountControlDeleteButtonWasPressed(self)
    }
    
    func addButtonPressed () {
        delegate?.ballCountControlAddButtonWasPressed(self)
    }
    
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Button
    public func buttonWasTouched(button: JABButton) {
        
    }
    
    public func buttonWasUntouched(button: JABButton, triggered: Bool) {
        
        if triggered {
            
            if button == deleteButton {
                
                deleteButtonPressed()
                
            } else if button == addButton {
                
                addButtonPressed()
                
            }
            
        }
        
    }
    
}



public protocol BallCountControlDelegate {
    
    func ballCountControlDeleteButtonWasPressed(ballCountControl: BallCountControl)
    func ballCountControlAddButtonWasPressed(ballCountControl: BallCountControl)
    
}
