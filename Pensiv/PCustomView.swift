//
//  PCustomView.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 19..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa
import CoreData


/*
 *
 *  빈곳을 클릭했을때 활성화 제거 -> 본 커스텀 뷰가 노드와 라인을 보유하여야 한다
 *  커스텀 뷰의 터치 매서드는 빈곳을 클릭했을 때만 호출되므로, 해당 매서드에 활성화 제거 매서드를 넣는다
 *
 *  두 노드간의 관계형성도 동일한 방식으로 수행
 *
 *
 */


enum P_CLASS_TYPE
{
    case PNODE
    case PLINE
}


class PCustomView : NSView
{
    /*
    override var isFlipped: Bool{
        get {
            return false
        }
    }*/
   
    var nodetable = [PNode]()
    
   // var trackingarea : NSTrackingArea?
    
    
    var dataManager : PDataManager?
    
    func initDataBase()
    {
        if let dele = NSApplication.shared.delegate as? AppDelegate
        {
            dataManager = PDataManager(mother : dele)
        }
        
    }
    
    
    override func viewDidEndLiveResize() {
        var frame = NSApplication.shared.windows.first?.frame
        frame?.origin = CGPoint(x: 0, y: 0)
        self.frame = frame!
    }
    
    override func viewWillDraw() {
        self.layer?.backgroundColor = CGColor.white
    }
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        //print(event.keyCode)
        
    }
    
    /*
    override func updateTrackingAreas() {
        if (trackingarea != nil)
        {
            self.removeTrackingArea(trackingarea!)
        }
        
        let options : NSTrackingArea.Options = [.activeWhenFirstResponder, .mouseMoved]
        
        trackingarea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        
        self.addTrackingArea(trackingarea!)
        
    }
    
    var touchednode : PNode?
    
    override func mouseMoved(with event: NSEvent) {
        if (touchednode != nil)
        {
            touchednode?.mouseMoved(with: event)
        }
    }
    */
    
    /*
    override func mouseMoved(with event: NSEvent) {
        let position = event.locationInWindow
        let framerect = self.contentView.visibleRect.origin
        let originposition = CGPoint(x: position.x + framerect.x, y: position.y + framerect.y)
        
        for node in nodetable
        {
            node.touched(position: originposition)
        }
     }
    */
    
    var selectednode : PNode?
    
    func setSelectedNode(target node : PNode)
    {
        if selectednode == nil
        {
            selectednode = node
        }
    }
    
    func resolveSelectedNode()
    {
        selectednode = nil
    }

    
    func getSelectedNode() -> PNode?
    {
        return selectednode
    }
    
    func isSelectedNode() -> Bool
    {
        return selectednode != nil ? true : false
    }
    
    var text : PTextNode?
    
    override func mouseDown(with event: NSEvent) {
        //hit test 에 걸린 뷰가 존재한다면, 이 매서드는 호출되지 않는다.
        
        //selected node 가 존재한다면, 그냥 그걸 지운다
        /*
        let originposition = event.locationInWindow
        print("\(originposition.x) , \(originposition.y)")
        let convert = self.convert(originposition, to: self)
        print("\(convert.x) , \(convert.y)")
        */
        
        if let x = subviews.first
        {
            if let y = x.subviews.first
            {
                print("\(y.frame.origin.x) \(y.frame.origin.y)")
            }
        }
        
        //마우스가 정확히 같은 곳을 클릭했을 때, 이벤트의 클릭 카운트가 증가한다.
        
        //노드가 생성된 뒤, 마우스를 움직이지 않으면 노드를 클릭해도 노드색깔이 바뀌지 않는다.
        
        if(event.clickCount == 2)
        {
            
            //let y = NSApplication.shared.windows.first?.frame.height
            //let framerect = self.contentView.visibleRect.origin
            //let originposition = CGPoint(x: position.x + framerect.x, y: position.y + framerect.y)
            
            let origin = CGRect(x: 50, y: 50, width: 200, height: 200)
            let pnode = PTextNode(frame: origin)
            
            //let pnode = PTextNode(frame: origin)
            
            //pnode.frame.origin.x -= pnode.frame.width / 2
            //pnode.frame.origin.y -= pnode.frame.height / 2
            
            self.addSubview(pnode)
            text = pnode
            
            //pushNode(target: pnode)
            
            
            print("xx")
            //dataManager?.saveData(str: "ssss")
            /*
            let ppnode_1 = PPNode(frame : NSRect(x: 100, y: 100, width: 100, height: 100))
            let ppnode_2 = PPNode(frame : NSRect(x: 400, y: 400, width: 100, height: 100))
            
            let pline = PLine(target_1: ppnode_1, target_2: ppnode_2)
            
            self.documentView?.addSubview(ppnode_1)
            self.documentView?.addSubview(ppnode_2)
            self.documentView?.addSubview(pline)
 */
        }
        
    }
    /*
    override func draw(_ dirtyRect: NSRect) {
        
        //Line들이 먼저 그려져야하므로, 모든 라인 드로우를 여기에서 담당
        
        
        super.draw(dirtyRect)
        
    }*/
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        
        for subview in subviews
        {
            let converted_point = subview.convert(point, from: subview)
            let hittestview : NSView? = subview.hitTest(converted_point)
            if (hittestview != nil)
            {
                
                if(hittestview == text?.subviews.first)
                {
                    print("same")
                }
                let x = hittestview?.frame.origin
                //print("\(x?.x) \(x?.y)")
                return hittestview
            }
        }
        print("self")
        return self
    }
 
}











