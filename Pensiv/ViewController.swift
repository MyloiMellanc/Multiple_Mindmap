//
//  ViewController.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 8..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa




class ViewController: NSViewController
{
    
    
    @IBOutlet var scrollview: PCustomView!
    
    let dataManager = Neo4jWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //이 시점에서 윈도우 객체는 초기화되지 않았다...? nil값 반환함
        
        let x = NSScreen.main?.frame
        NSLog("Screen resolution is (\(x!.width), \(x!.height))")
        
        
        scrollview.documentView = PCustomDocumentView(frame : NSRect(x: 0, y: 0, width: 4000, height: 3000))
        
        scrollview.wantsLayer = true
        
        self.nextResponder = scrollview

        
        
        dataManager.initWrapper()
        if dataManager.connect() == false {
            print("Database Connect error")
            exit(0)
        }
        
        
        
    }
    
    override func viewWillAppear() {
    
    }
    

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    deinit {
        self.dataManager.disconnect()
    }
    
}


