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
    private var text : NSTextField?
    
    private var istouched = false
    private var ismoved = false
    
    private var isactivated = false
    
    func initTextField()
    {
        text = NSTextField(frame: self.frame)
        text?.backgroundColor = NSColor.black
        self.addSubview(text!)
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
        istouched = true
        
        self.setNeedsDisplay()
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.frame.origin.x += event.deltaX
        self.frame.origin.y -= event.deltaY //어째서 Y 변화량의 축이 다르지?
        
        ismoved = true
        
        self.setNeedsDisplay()
    }
    
    override func mouseUp(with event: NSEvent) {
        istouched = false
        if(ismoved == false)
        {
            isactivated = !isactivated
        }
        ismoved = false
        
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
        let path = NSBezierPath(ovalIn: dirtyRect)
        
        
        if(isactivated == true)
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
    //ID
    //Position
    //Scale
    //TextSize
    //Alpha
    //Color
    //Zorder
    //
}





