//
//  ViewController.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 8..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics
import CoreData

/*
 *  마인드 맵 데이터를 관리하는 클래스, 뷰 교체 및 선정 클래스, 터치 컨트롤러 클래스
 *  해당 클래스들 3가지를 통합적으로 관리하는 클래스
 *
 *
 *
 *
 */




class ViewController: NSViewController
{
    
    @IBOutlet var scrollview: PCustomView!
    
    
    @objc func demoCrawling()
    {
        let democrawl = DemoWordCrawler()
        democrawl.demoCrawling(search: "pdf")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //이 시점에서 윈도우 객체는 초기화되지 않았다...? nil값 반환함
        
        let x = NSScreen.main?.frame
        NSLog("Screen resolution is (\(x!.width), \(x!.height))")
        
        scrollview.wantsLayer = true
        scrollview.becomeFirstResponder()
        scrollview.updateTrackingAreas()
        scrollview.initDataBase()
        
        
        let thread = Thread(target: self, selector: Selector("demoCrawling"), object: nil)
        thread.start()
        
    }
    
    override func viewWillAppear() {
        //scrollview.documentView?.layer?.backgroundColor = CGColor.black
    }
    
    

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    override func mouseMoved(with event: NSEvent) {
        //scrollview.mouseMoved(with: event)
        
    }
    
    
    
    override func mouseDown(with event: NSEvent) {
        //let position = event.locationInWindow
        
        //let tf = NSTextField(string: "demo")
        
        //let origin = CGRect(x: position.x, y: position.y, width: 100, height: 100)
        
        //let lab = NSTextView(frame: origin)
        //lab.string = "demo"
        
        //scrollview.addSubview(lab)
        
        //NSLog("\(event.clickCount)")
        
        //scrollview.mouseDown(with: event)
    }

}


