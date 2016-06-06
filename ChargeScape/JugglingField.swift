//
//  JugglingField.swift
//  ChargeScape
//
//  Created by Jeremy Bannister on 5/8/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class JugglingField: JABView, JABTouchableViewDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    var delegate: JugglingFieldDelegate?
    
    // MARK: State
    var gravity = false
    var superCharge = false {
        didSet {
            if superCharge {
                superChargeAllJugglingBalls()
            } else {
                dischargeAllJugglingBalls()
            }
        }
    }
    var chainReaction = false
    var neutralize = false
    
    // MARK: UI
    var jugglingBalls = [ChargedBall]()
    
    // MARK: Parameters
    let initialNumberOfBalls = 0
    var numberOfBalls: Int {
        get {
            return jugglingBalls.count
        }
    }
    let magnitudeOfChargeOfBalls = CGFloat(0.00001)
    let dt = CGFloat(0.005)
    var heightOfScreenInMeters = CGFloat(4.0)
    var widthOfScreenInMeters = CGFloat(1)
    
    let pi = CGFloat(3.14159)
    let epsilonNaught = CGFloat(8.854 * pow(10, -12))
    let G = CGFloat(6.67259 * pow(10, -11))
    let massOfEarth = CGFloat(5.972 * pow(10, 24) * 0.8) // Multiply by 0.8 so that balls fall more slowly
    let radiusOfEarth = CGFloat(6.371 * pow(10, 6))
    var centerOfEarth: Vector
    
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public override init () {
        
        centerOfEarth = Vector(x: widthOfScreenInMeters/2, y: heightOfScreenInMeters + radiusOfEarth, z: 0.0)
        
        super.init()
        
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(dt), target: self, selector: "updateJugglingBalls", userInfo: nil, repeats: true)
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        
        centerOfEarth = Vector(x: widthOfScreenInMeters/2, y: heightOfScreenInMeters + radiusOfEarth, z: 0.0)
        
        super.init()
        
        print("Should not be initializing from coder \(self)")
    }
    
    
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        createJugglingBalls()
        
    }
    
    override public func updateAllUI() {
        
        configureScreenMetric()
        
        configureJugglingBalls()
        positionJugglingBalls()
        
    }
    
    
    // MARK: Pseudo
    func configureScreenMetric () {
        
        if width != 0 && height != 0 {
            
            if width > height {
                heightOfScreenInMeters = CGFloat(4)
                widthOfScreenInMeters = heightOfScreenInMeters * (width/height)
            } else {
                widthOfScreenInMeters = CGFloat(4)
                heightOfScreenInMeters = widthOfScreenInMeters * (height/width)
            }
            
        }
        
    }
    
    
    // MARK: Create
    func createJugglingBalls () {
        
        deleteJugglingBalls()
        
        for i in 0..<initialNumberOfBalls {
            createJugglingBall()
        }
        
    }
    
    
    // MARK: Adding
    func addJugglingBalls () {
        
        for jugglingBall in jugglingBalls {
            addSubview(jugglingBall)
        }
        
    }
    
    
    // MARK: Delete
    func deleteJugglingBalls () {
        
        for jugglingBall in jugglingBalls {
            jugglingBall.removeFromSuperview()
        }
        jugglingBalls.removeAll(keepCapacity: false)
        
    }
    
    
    // MARK: Juggling Balls
    func configureJugglingBalls () {
        
        for jugglingBall in jugglingBalls {
            
            jugglingBall.delegate = self
        }
    }
    
    func positionJugglingBalls () {
        
        for jugglingBall in jugglingBalls {
            
            var newFrame = CGRectZero
            let conversionFactor = height/heightOfScreenInMeters
            
            newFrame.size.width = jugglingBall.dimensions.width * conversionFactor
            newFrame.size.height = jugglingBall.dimensions.height * conversionFactor
            
            newFrame.origin.x = jugglingBall.position.x * conversionFactor
            newFrame.origin.y = jugglingBall.position.y * conversionFactor
            
            jugglingBall.frame = newFrame
            
        }
        
    }
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Physics
    func updateJugglingBalls () {
        
        
        var ballsMarkedForDeletion = [(ChargedBall, Int)]()
        
        
        for i in 0..<jugglingBalls.count {
            var jugglingBall = jugglingBalls[i]
            
            
            if !jugglingBall.isBeingHeld {
                
                var decelerationFactorBounce = CGFloat(0.85)
                var decelerationFactorScrape = CGFloat(0.7)
                
                decelerationFactorBounce = CGFloat(0.5)
                decelerationFactorScrape = CGFloat(0.5)
                
                
                
                let force = forceOnJugglingBall(jugglingBall)
                let acceleration = force.scaledBy(1/jugglingBall.mass)
                jugglingBall.velocity.addOn(acceleration.scaledBy(dt))
                jugglingBall.position.addOn(jugglingBall.velocity.scaledBy(dt))
                
                
                if jugglingBall.position.x < 0 {
                    jugglingBall.position.x = 0
                    jugglingBall.velocity.x = -jugglingBall.velocity.x * decelerationFactorBounce
                    jugglingBall.velocity.y = jugglingBall.velocity.y * decelerationFactorScrape
                }
                
                if jugglingBall.position.x + jugglingBall.dimensions.width > widthOfScreenInMeters {
                    jugglingBall.position.x = widthOfScreenInMeters - jugglingBall.dimensions.width
                    jugglingBall.velocity.x = -jugglingBall.velocity.x * decelerationFactorBounce
                    jugglingBall.velocity.y = jugglingBall.velocity.y * decelerationFactorScrape
                }
                
                if jugglingBall.position.y + jugglingBall.dimensions.height > heightOfScreenInMeters {
                    jugglingBall.position.y = heightOfScreenInMeters - jugglingBall.dimensions.height
                    jugglingBall.velocity.y = -jugglingBall.velocity.y * decelerationFactorBounce
                    jugglingBall.velocity.x = jugglingBall.velocity.x * decelerationFactorScrape
                }
                
                if jugglingBall.position.y < 0 {
                    jugglingBall.position.y = 0
                    jugglingBall.velocity.y = -jugglingBall.velocity.y * decelerationFactorBounce
                    jugglingBall.velocity.x = jugglingBall.velocity.x * decelerationFactorScrape
                }
                
                
                if neutralize {
                    // Neutralize charges that have collided
                    for j in 0..<jugglingBalls.count {
                        let otherJugglingBall = jugglingBalls[j]
                        if jugglingBall != otherJugglingBall {
                            if jugglingBall.charge/otherJugglingBall.charge < 0 {
                                if jugglingBall.position.subtractedOff(otherJugglingBall.position).length < (jugglingBall.dimensions.width/2 + otherJugglingBall.dimensions.width/2)*0.2 {
                                    ballsMarkedForDeletion.append((jugglingBall, i))
                                    otherJugglingBall.charge = 0
                                    otherJugglingBall.updateAllUI()
                                }
                            }
                        }
                    }
                }
                
                
            }
            
        }
        
        
        // Bubble sort balls marked for deletion so that the recorded indices of each ball remain correct throughout deletion process
        if ballsMarkedForDeletion.count > 0 {
            for i in 0..<(ballsMarkedForDeletion.count - 1) {
                for j in 0..<(ballsMarkedForDeletion.count - 1) {
                    var first = ballsMarkedForDeletion[j]
                    var second = ballsMarkedForDeletion[j + 1]
                    
                    if second.1 < first.1 {
                        var holder = second
                        ballsMarkedForDeletion[j + 1] = first
                        ballsMarkedForDeletion[j] = holder
                    }
                }
            }
        }
        
        
        // Delete balls from end
        for i in 0..<ballsMarkedForDeletion.count {
            var ball = ballsMarkedForDeletion[ballsMarkedForDeletion.count - 1 - i]
            ball.0.removeFromSuperview()
            jugglingBalls.removeAtIndex(ball.1)
        }
        
        if ballsMarkedForDeletion.count > 0 {
            delegate?.jugglingFieldBallCountDidChange(self)
        }
        
        
        updateAllUI()
        
        
    }
    
    
    func forceOnJugglingBall (jugglingBall: ChargedBall) -> Vector {
        
        let totalForce = Vector()
        
        let r = centerOfEarth.subtractedOff(jugglingBall.position)
        let gravityMagnitude = (G * massOfEarth * jugglingBall.mass)/pow(r.length, 2)
        r.normalize()
        
        let forceOfGravity = r.scaledBy(gravityMagnitude)
        
        if gravity {
            totalForce.addOn(forceOfGravity)
        }
        
        
        for otherJugglingBall in jugglingBalls {
            if otherJugglingBall != jugglingBall {
                
                let r = jugglingBall.position.subtractedOff(otherJugglingBall.position)
                var electricForceMagnitude = CGFloat(100000000)
                if !r.isZero() {
                    
                    let coulombInteraction = true // Toggles between regular coulomb ineraction and more complex leonard-jones type interaction
                    
                    if coulombInteraction {
                        electricForceMagnitude = ((1/(4 * pi * epsilonNaught)) * (jugglingBall.charge * otherJugglingBall.charge))*(1/(pow(r.length, 2)))
                    } else {
                        if jugglingBall.charge/otherJugglingBall.charge > 0 { // Always repulsive
                            
                            electricForceMagnitude = ((1/(4 * pi * epsilonNaught)) * (jugglingBall.charge * otherJugglingBall.charge))*(1/(pow(r.length, 4)))
                            
                        } else { // Long range attractive short range repulsive
                            
                            electricForceMagnitude = ((1/(4 * pi * epsilonNaught)) * (jugglingBall.charge * otherJugglingBall.charge))*(1/(pow(r.length, 2)) - (1/pow(r.length, 4)))
                        }
                    }
                    
                    
                }
                r.normalize()
                
                let electricForce = r.scaledBy(electricForceMagnitude)
                
                totalForce.addOn(electricForce)
            }
        }
        
        
        
        return totalForce
    }
    
    
    
    func totalKineticEnergy () -> CGFloat {
        
        var kineticEnergy = CGFloat(0)
        
        for jugglingBall in jugglingBalls {
            
            kineticEnergy += 0.5 * jugglingBall.mass * pow(jugglingBall.velocity.length, 2)
            
        }
        
        return kineticEnergy
        
    }
    
    
    
    
    
    // MARK: Juggling Balls
    public func deleteJugglingBall () {
        
        if jugglingBalls.count != 0 {
            jugglingBalls[0].removeFromSuperview()
            jugglingBalls.removeAtIndex(0)
        }
        
    }
    
    public func createJugglingBall () {
        
        var newJugglingBall = ChargedBall()
        
        newJugglingBall.position = Vector(x: widthOfScreenInMeters/2, y: heightOfScreenInMeters/2, z: 0)
        newJugglingBall.velocity = Vector(x:1, y:-0.2, z:0)
        
        for jugglingBall in jugglingBalls {
            if jugglingBall.position.isEqualTo(newJugglingBall.position) {
                newJugglingBall.position.x += 0.1
            }
        }
        
        newJugglingBall.mass = 1
        
        if superCharge {
            newJugglingBall.charge = magnitudeOfChargeOfBalls * 10
        } else {
            newJugglingBall.charge = magnitudeOfChargeOfBalls
        }
        
        
        jugglingBalls.append(newJugglingBall)
        addSubview(newJugglingBall)
        
    }
    
    
    
    func superChargeAllJugglingBalls () {
        
        for jugglingBall in jugglingBalls {
            if jugglingBall.charge > 0 {
                jugglingBall.charge = magnitudeOfChargeOfBalls * 10
            } else if jugglingBall.charge < 0 {
                jugglingBall.charge = magnitudeOfChargeOfBalls * -10
            }
        }
    }
    
    func dischargeAllJugglingBalls () {
        for jugglingBall in jugglingBalls {
            if jugglingBall.charge > 0 {
                jugglingBall.charge = magnitudeOfChargeOfBalls
            } else if jugglingBall.charge < 0 {
                jugglingBall.charge = -magnitudeOfChargeOfBalls
            }
        }
    }
    
    
    
    
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Touchable View
    public func touchableViewTouchDidBegin(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer) {
        
        let location = gestureRecognizer.locationInView(self)
        
        for jugglingBall in jugglingBalls {
            if touchableView == jugglingBall {
                jugglingBall.isBeingHeld = true
            }
        }
        
    }
    
    public func touchableViewTouchDidChange(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        let location = gestureRecognizer.locationInView(self)
        
        for jugglingBall in jugglingBalls {
            if touchableView == jugglingBall {
                
                jugglingBall.x += xDistance
                jugglingBall.y += yDistance
                
                let conversionFactor = heightOfScreenInMeters/height
                jugglingBall.position.x = jugglingBall.x * conversionFactor
                jugglingBall.position.y = jugglingBall.y * conversionFactor
            }
        }
        
    }
    
    public func touchableViewTouchDidEnd(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        let velocityConversionFactor = heightOfScreenInMeters/height
        
        for jugglingBall in jugglingBalls {
            if touchableView == jugglingBall {
                jugglingBall.velocity.x = xVelocity * velocityConversionFactor
                jugglingBall.velocity.y = yVelocity * velocityConversionFactor
                jugglingBall.isBeingHeld = false
                
                if methodCallNumber < 5 {
                    jugglingBall.charge += magnitudeOfChargeOfBalls
                    if jugglingBall.charge > magnitudeOfChargeOfBalls {
                        jugglingBall.charge = -magnitudeOfChargeOfBalls
                    }
                    
                    if superCharge {
                        jugglingBall.charge = jugglingBall.charge*10
                    }
                    
                    jugglingBall.updateAllUI()
                }
            }
        }
        
    }
    
    public func touchableViewTouchDidCancel(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        let velocityConversionFactor = heightOfScreenInMeters/height
        
        for jugglingBall in jugglingBalls {
            if touchableView == jugglingBall {
                jugglingBall.velocity.x = xVelocity * velocityConversionFactor
                jugglingBall.velocity.y = yVelocity * velocityConversionFactor
                jugglingBall.isBeingHeld = false
            }
        }
        
    }
    
}





public protocol JugglingFieldDelegate {
    func jugglingFieldBallCountDidChange(jugglingField: JugglingField)
}
