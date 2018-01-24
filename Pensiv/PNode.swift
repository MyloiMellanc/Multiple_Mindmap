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
    let _type = P_CLASS_TYPE.PNODE
    
    var _isTouched = false
    var _isMoved = false
    var _isActivated = false
    
    
    /*
    init(dd d : Int)
    {
        super.init(frame: NSRect())
        
    }
    
    required init(coder aDecoder : NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    */
    
    var _motherView : PCustomView?
    
    func setMotherView(target view : PCustomView)
    {
        _motherView = view
    }
    
    func initNodeData()
    {
        
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



class PTextNode : PNode, NSTextFieldDelegate
{
    var text : NSTextField?
    
    override func initNodeData() {
        let fra = self.frame
        let origin = CGRect(x: fra.origin.x, y: fra.origin.y, width: fra.width / 1.5, height: fra.height / 1.5)
        
        text = NSTextField(frame: origin)
        
    
        self.addSubview(text!)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        text?.isEditable = true
        text?.isSelectable = true
        text?.becomeFirstResponder()
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
        
        let p = NSBezierPath()
        let a = NSPoint(x: 0, y: 0)
        let b = NSPoint(x: 100, y: 300)
        p.move(to: a)
        p.line(to: b)
        p.lineWidth = 5
        p.lineCapStyle = .roundLineCapStyle
        p.stroke()
        
        text?.draw(dirtyRect)
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









