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
    static let baseWidth : CGFloat = 60.0
    static let baseHeight : CGFloat = 30.0
    
    static let gap : CGFloat = 5.0
    
    
    
    
    var centerPoint : CGPoint
    
    
    
    //선택 활성화나, 서브메뉴 출력 관리(?)
    //정렬과 위치 관련 매서드를 나중에 추가할것.
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
    
    
    
    var moved : Bool = false
    
    override func mouseDragged(with event: NSEvent) {
        
        self.frame.origin.x += event.deltaX
        self.frame.origin.y -= event.deltaY //어째서 Y 변화량의 축이 다르지?
        
        self.centerPoint.x += event.deltaX
        self.centerPoint.y -= event.deltaY  //어째서 Y 변화량의 축이 다르지?
        
        //y축이 인버트되어있음
        //print("\(event.deltaX), \(event.deltaY)")
        
        superview?.needsDisplay = true
        
        self.moved = true
    }
    
    override func mouseUp(with event: NSEvent) {
        if self.moved == false {
            superview?.PSelectNode(target: self)
        }
        
        self.moved = false
    }
    
}







class PTextField : NSTextField
{
    
    init(frame frameRect : NSRect, text str : String)
    {
        super.init(frame: frameRect)
        self.stringValue = str
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func mouseUp(with event: NSEvent) {
        if event.clickCount == 2 {
            self.isEditable = true
            self.becomeFirstResponder()
        } else {
            super.mouseUp(with: event)
        }
    }
    
    //해당 매서드는 true시 자동으로 return시에 first responder를 반납한다
    override func textShouldEndEditing(_ textObject: NSText) -> Bool {
        self.isEditable = false
        self.isSelectable = false
        
        return true
    }
}









class PTextNode : PNode
{
    let textfield : PTextField
    
    override init(position touchPoint : CGPoint)
    {
        let frameRect = NSRect(x: PNode.gap, y: PNode.gap, width: PNode.baseWidth, height: PNode.baseHeight)
        
        textfield = PTextField(frame : frameRect, text : "Text")
        //super.init 전에 내부 변수를 모두 초기화해야함
        
        textfield.isEditable = false

        
        
        super.init(position : touchPoint)
        
        self.addSubview(textfield)   //super.init 이후에 self 사용가능
    }
    
    init(position touchPoint : CGPoint, text str : String)
    {
        let frameRect = NSRect(x: PNode.gap, y: PNode.gap, width: PNode.baseWidth, height: PNode.baseHeight)
        
        textfield = PTextField(frame : frameRect, text : str)
        //super.init 전에 내부 변수를 모두 초기화해야함
        
        textfield.isEditable = false
        
        
        
        super.init(position : touchPoint)
        
        self.addSubview(textfield)   //super.init 이후에 self 사용가능
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


/*
    
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


