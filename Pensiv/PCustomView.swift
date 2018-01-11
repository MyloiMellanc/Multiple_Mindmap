//
//  PCustomView.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 19..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa

class PCustomView : NSScrollView
{
    var nodetable = [PNode]()
    
   // var trackingarea : NSTrackingArea?
    
    
    /*
    override var acceptsFirstResponder: Bool
    {
        return true
    }*/
    
    override func viewWillDraw() {
        self.documentView?.layer?.backgroundColor = CGColor.white
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
    
    func pushNode(target node : PNode)
    {
        node.initNodeData()
        nodetable.append(node)
        self.documentView?.addSubview(node)
        node.setMotherView(target: self)
    }
    
    override func mouseDown(with event: NSEvent) {
        //마우스가 정확히 같은 곳을 클릭했을 때, 이벤트의 클릭 카운트가 증가한다.
        
        //노드가 생성된 뒤, 마우스를 움직이지 않으면 노드를 클릭해도 노드색깔이 바뀌지 않는다.
        
        if(event.clickCount == 2)
        {
            let position = event.locationInWindow
            
            let framerect = self.contentView.visibleRect.origin
            let originposition = CGPoint(x: position.x + framerect.x, y: position.y + framerect.y)
            
            let origin = CGRect(x: originposition.x, y: originposition.y, width: 100, height: 100)
            let pnode = PNode(frame: origin)
            
            pnode.frame.origin.x -= pnode.frame.width / 2
            pnode.frame.origin.y -= pnode.frame.height / 2
            
            pushNode(target: pnode)
        }
        
    }
    
    
}











