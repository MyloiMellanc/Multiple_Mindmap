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

class PNode : NSView
{
    
}

class PTextNode : PNode
{
    var text : NSTextField?
    
    override init(frame frameRect: NSRect) {
        super.init(frame : frameRect)
        
        
        let origin = NSRect(x: 0, y: 0, width: 150, height: 150)
        text = NSTextField(frame : origin)
        self.addSubview(text!)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        //text?.draw(dirtyRect)
        
        
        let a = NSBezierPath()
        a.move(to: NSPoint(x: 0, y: 0))
        a.line(to: NSPoint(x: 100, y: 100))
        a.lineWidth = 2.0
        NSColor.red.setFill()
        a.stroke()
    }
    
    
}

/*

class PTextNode : NSTextField, NSTextFieldDelegate
{
    let nodeType = P_CLASS_TYPE.PNODE
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.isEditable = true
        self.isSelectable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(with event: NSEvent) {
        self.isEditable = true
        self.isSelectable = true
        self.becomeFirstResponder()
    }
    
    
    override func mouseDragged(with event: NSEvent) {
        self.isEditable = false
        self.isSelectable = false
        
        self.frame.origin.x += event.deltaX
        self.frame.origin.y -= event.deltaY //어째서 Y 변화량의 축이 다르지?
        
        self.setNeedsDisplay()
    }
    
    
    
    
    
    override func textShouldEndEditing(_ textObject: NSText) -> Bool {
        //self.isEditable = false
        self.isSelectable = false
        self.resignFirstResponder()
        return true
    }
    
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}
*/
/*

class PNode : NSButton
{
    let _type = P_CLASS_TYPE.PNODE
    
    var _isTouched = false
    var _isMoved = false
    var _isActivated = false
    
    var field : NSTextField?
    
    
    
    var _motherView : PCustomView?
    
    func setMotherView(target view : PCustomView)
    {
        _motherView = view
    }
    
    func initNodeData()
    {
        field = NSTextField(frame : self.frame)
        self.addSubview(field!)
        //self.superview 가 종속된 뷰를 가리킴 - 여기서는 PCustomView
        
        
    }
    
    func activate()
    {
        if _isActivated == false
        {
            _isActivated = true
            
        }
    }
    
    
    func deactivate()
    {
        
    }
    
    
    override func mouseDown(with event: NSEvent) {
        _isTouched = true
        
        self.setNeedsDisplay()
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.frame.origin.x += event.deltaX
        self.frame.origin.y -= event.deltaY //어째서 Y 변화량의 축이 다르지?
        
        _isMoved = true
        
        self.setNeedsDisplay()
    }
    
    override func mouseUp(with event: NSEvent) {
        _isTouched = false
        if(_isMoved == false)
        {
            _isActivated = !_isActivated
        }
        _isMoved = false
        
        self.setNeedsDisplay()
    }
    override func draw(_ dirtyRect: NSRect) {
        
        for x in self.subviews
        {
            x.draw(dirtyRect)
        }
        super.draw(dirtyRect)
    }
    
    //var trackingarea : NSTrackingArea?
    
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
    
    
    
    
    //ID
    //Position
    //Scale
    //TextSize
    //Alpha
    //Color
    //Zorder
    //
}


/*
class PTextNode : PNode, NSTextFieldDelegate
{
    var text : NSTextField?
    
    override func initNodeData() {
        let fra = self.frame
        let origin = CGRect(x: fra.origin.x + 100, y: fra.origin.y, width: fra.width / 1.5, height: fra.height / 1.5)
        
        text = NSTextField(frame: origin)
        //text?.delegate = self
    
        self.addSubview(text!)
    }
    
    
    
    override func draw(_ dirtyRect: NSRect)
    {
        let path = NSBezierPath(ovalIn: dirtyRect)
        
        if(self._isActivated == true)
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
        
        //text?.draw(dirtyRect)
    }
}


*/

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


*/





