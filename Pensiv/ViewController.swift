//
//  ViewController.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 8..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa


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
    
    
    ////////////////////////////////////////////////////////////////
    
    //데이터베이스 관련
    var dataManager : PDataManager?
    
    func initDataBase() {
        if let dele = NSApplication.shared.delegate as? AppDelegate {
            dataManager = PDataManager(mother : dele)
        }
    }
    
    
    
    
    
    
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
        //scrollview.becomeFirstResponder()
        self.nextResponder = scrollview

        
        
        
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
    
}


