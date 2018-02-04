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




class PNode : NSView    //PNode를 상속하는 모든 노드가 기본 뷰를 가질 예정으로, 미리 상속받음
{
    var nodeNumber : Int = 1
    
    //차후 팩토리 객체화할것
    static let baseWidth : CGFloat = 70.0
    static let baseHeight : CGFloat = 40.0
    
    static let gap : CGFloat = 10.0
    
    //마인드맵의 모든 노드들의 기본 인터페이스
    
    var centerPoint : CGPoint?
    
    
    
    //선택 활성화나, 서브메뉴 출력 관리(?)
    //정렬과 위치 관련 매서드를 나중에 추가할것.
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
    }
    
    init(position touchPoint : CGPoint)
    {
        centerPoint = touchPoint
        
        let framePoint = CGPoint(x: touchPoint.x - (PNode.baseWidth / 2 + PNode.gap), y: touchPoint.y - (PNode.baseHeight / 2 + PNode.gap) )
        let frameRect = NSRect(x: framePoint.x, y: framePoint.y, width: PNode.baseWidth + (PNode.gap * 2), height: PNode.baseHeight + (PNode.gap * 2))
        super.init(frame : frameRect)
        
        
        self.layer = CAShapeLayer()
        self.wantsLayer = true
        
        self.layer?.backgroundColor = CGColor.black
        
        let scale_animation = CASpringAnimation(keyPath: "transform.scale")
        scale_animation.duration = 0.6
        scale_animation.fromValue = 0
        scale_animation.toValue = 1
        
        let position_animation = CASpringAnimation(keyPath: "position")
        position_animation.duration = 0.6
        position_animation.fromValue = touchPoint
        position_animation.toValue = framePoint
        
        self.layer?.add(scale_animation, forKey: "scale")
        self.layer?.add(position_animation, forKey: "move")
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(with event: NSEvent) {
        print("pnode touch")
        
        superview?.PSelectNode(target: self)
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.frame.origin.x += event.deltaX
        self.frame.origin.y -= event.deltaY //어째서 Y 변화량의 축이 다르지?
        
        
        //self.setNeedsDisplay()
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
    
    func test()
    {
        
    }
    
}


class PTextField : NSTextField
{
    override func mouseDown(with event: NSEvent) {
        
        if event.clickCount == 2
        {
            self.isEditable = true
            self.becomeFirstResponder()
        }
        else
        {
            super.mouseDown(with: event)
        }
        
        //self.isEditable = true
        //self.isSelectable = true
        print("text touch")
        //super.mouseDown(with: event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }
    
    //해당 매서드는 true시 자동으로 first responder를 반납한다
    override func textShouldEndEditing(_ textObject: NSText) -> Bool {
        self.isEditable = false
        self.isSelectable = false
        
        return true
    }
}

class PTextNode : PNode
{
    var text : PTextField
    
    override func test()
    {
        print(1)
        
        window?.makeFirstResponder(nil)
        
    }
    
    override init(position touchPoint : CGPoint)
    {
        let frameRect = NSRect(x: PNode.gap, y: PNode.gap, width: PNode.baseWidth, height: PNode.baseHeight)
        
        text = PTextField(frame : frameRect)
        text.stringValue = "text"
        //super.init 전에 내부 변수를 모두 초기화해야함
        
        text.isEditable = false
        text.becomeFirstResponder()
        
        super.init(position : touchPoint)
        
        self.addSubview(text)   //super.init 이후에 self 사용가능
    }
    
    
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(with event: NSEvent) {
        //text.isEditable=true
        //text.mouseDown(with: event)
        
        print("Pnode touch")
        
        super.mouseDown(with: event)
        
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
    }
    
}


/*
 override func draw(_ dirtyRect: NSRect) {
 //text?.draw(dirtyRect)
 
 /*
 let a = NSBezierPath()
 a.move(to: NSPoint(x: 0, y: 0))
 a.line(to: NSPoint(x: 100, y: 100))
 a.lineWidth = 2.0
 NSColor.red.setFill()
 a.stroke()*/
 }
 */


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

*/


