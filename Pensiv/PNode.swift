//
//  PNode.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 7..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics



class PNode : NSButton
{
    private var touched = false
    func isTouched() -> Bool
    {
        return touched
    }
    
    private var moved = false
    func isMoved() -> Bool
    {
        return moved
    }
    
    private var motherview : PCustomView?
    
    
    private var _activated = false
    private var activated : Bool
    {
        get {
            return _activated
        }
        set {
            _activated = newValue
            
            if newValue == true {
                
                motherview?.setSelectedNode(target: self)
            }
            else if newValue == false {
                if motherview?.getSelectedNode() == self
                {
                    motherview?.resolveSelectedNode()
                }
            }
        }
    }
    func isActivated() -> Bool
    {
        return _activated
    }
    
    
    func setMotherView(target view : PCustomView)
    {
        motherview = view
    }
    
    func initNodeData()
    {
        
        //self.superview 가 종속된 뷰를 가리킴 - 여기서는 PCustomView
        
        
    }
    
    //var target_view : PCustomView?
    
    /*
    override func mouseDown(with event: NSEvent) {
        istouched = true
        target_view?.touchednode = self
        self.setNeedsDisplay()
    }
    
    
    override func mouseMoved(with event: NSEvent) {
        //super.mouseMoved(with: event)
        self.frame.origin.x += event.deltaX
        self.frame.origin.y += event.deltaY
        
        self.setNeedsDisplay()
    }
    
    override func mouseUp(with event: NSEvent) {
        istouched = false
        target_view?.touchednode = nil
        self.setNeedsDisplay()
    }
    
    var trackingarea : NSTrackingArea?
    */
    
    
    override func mouseDown(with event: NSEvent) {
        touched = true
        
        self.setNeedsDisplay()
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.frame.origin.x += event.deltaX
        self.frame.origin.y -= event.deltaY //어째서 Y 변화량의 축이 다르지?
        
        moved = true
        
        self.setNeedsDisplay()
    }
    
    override func mouseUp(with event: NSEvent) {
        touched = false
        if(moved == false)
        {
            activated = !activated
        }
        moved = false
        
        self.setNeedsDisplay()
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
    }*/
    
    override func draw(_ dirtyRect: NSRect) {
        
    }
    //ID
    //Position
    //Scale
    //TextSize
    //Alpha
    //Color
    //Zorder
    //
}



class PTextNode : PNode
{
    var text : NSTextField?
    
    override func initNodeData() {
        text = NSTextField(frame: self.frame)
        text?.backgroundColor = NSColor.black
        self.addSubview(text!)
    }
    
    override func draw(_ dirtyRect: NSRect)
    {
        let path = NSBezierPath(ovalIn: dirtyRect)
        
        if(self.isActivated() == true)
        {
            NSColor.red.setFill()
        }
        else
        {
            NSColor.green.setFill()
        }
        
        path.fill()
        
        NSColor.black.setFill()
        path.stroke()
        
        let p = NSBezierPath()
        let a = NSPoint(x: 0, y: 0)
        let b = NSPoint(x: 100, y: 300)
        p.move(to: a)
        p.line(to: b)
        p.lineWidth = 5
        p.lineCapStyle = .roundLineCapStyle
        p.stroke()
    }
}




class PFunctionNode : PNode
{
    override func initNodeData()
    {
        //text = NSTextField(frame: self.frame)
        //text?.backgroundColor = NSColor.black
        //self.addSubview(text!)
        //self.superview 가 종속된 뷰를 가리킴 - 여기서는 PCustomView
        
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let path = NSBezierPath(ovalIn: dirtyRect)
        
        path.fill()
        
        NSColor.black.setFill()
        path.stroke()
    }
}









