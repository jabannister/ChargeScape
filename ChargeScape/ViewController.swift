//
//  ViewController.swift
//  ChargeScape
//
//  Created by Jeremy Bannister on 5/8/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var applicationRoot = ApplicationRoot()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        view.addSubview(applicationRoot)
        applicationRoot.frame = view.relativeFrame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        applicationRoot.frame = view.relativeFrame
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

