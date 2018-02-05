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
        //democrawl.demoCrawling(search: "hyper")
        democrawl.demoRun()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //이 시점에서 윈도우 객체는 초기화되지 않았다...? nil값 반환함
        
        let x = NSScreen.main?.frame
        NSLog("Screen resolution is (\(x!.width), \(x!.height))")
        
        scrollview.wantsLayer = true
        
        
        
        var list = Set<PLink>()
        
        let view = NSView()
        let node = PTextNode(position: CGPoint(), text: "ss")
        let node2 = PTextNode(position: CGPoint(), text: "sd")
        
        let z = PLink(view: view, node_1: node, node_2: node)
        let y = PLink(view: view, node_1: node, node_2: node)
        let t = PLink(view: view, node_1: node, node_2: node2)
        
        print(list.count)
        list.insert(z)
        print(list.count)
        list.insert(y)
        print(list.count)
        list.insert(t)
        print(list.count)
        
        //scrollview.initDataBase()
        
        
        //let thread = Thread(target: self, selector: Selector("demoCrawling"), object: nil)
        //thread.start()
        
    }
    
    override func viewWillAppear() {
    
    }
    

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    override func mouseMoved(with event: NSEvent) {
        
    }
    
    
    
    override func mouseDown(with event: NSEvent) {
        
    }

}


