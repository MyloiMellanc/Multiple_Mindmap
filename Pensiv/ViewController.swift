//
//  ViewController.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 8..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var main: NSView!
    
    var table = Set<NSTextField>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        main.layer?.backgroundColor = CGColor.white
    
        
        let x = NSScreen.main?.frame
        NSLog("Screen resolution is (\(x?.width), \(x?.height))")
        /*
        let point = CGPoint(x : 250.0, y : 50.0)
        let size = CGSize(width : 800.0, height : 600.0)
        let origin = CGRect(origin: point, size: size)
        
        self.view.window?.setFrame(origin, display: true)*/
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    override func mouseDown(with event: NSEvent) {
        let lab = NSTextField(string: "demo label")
        
        let position = event.locationInWindow
        lab.frame.origin = position
        
        //self.view.addSubview(lab)     -- Same
        main.addSubview(lab)
        
        table.insert(lab)
        
    }

}


