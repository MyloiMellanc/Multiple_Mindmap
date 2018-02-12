//
//  PTextNode.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 2. 13..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics




class PTextField : NSTextField
{
    
    ////////////////////////////////////////////////////////////////
    init(frame frameRect : NSRect, text str : String)
    {
        super.init(frame: frameRect)
        self.stringValue = str
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ////////////////////////////////////////////////////////////////
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////
    
    //해당 매서드는 true시 자동으로 return시에 first responder를 반납한다
    override func textShouldEndEditing(_ textObject: NSText) -> Bool {
        self.isEditable = false
        self.isSelectable = false
        
        return true
    }
    
    ////////////////////////////////////////////////////////////////
    
    
    
    
    /*
     override var acceptsFirstResponder: Bool {
     return true
     
     }
     
     override func keyUp(with event: NSEvent) {
     //이 매서드가 없다면, 이벤트는 리스폰더 체인을 거쳐 PCustomView로 넘어간다.
     //리스폰더 체인은 오버라이딩된 매서드의 여부로 도달을 확인하는 것 같다.
     super.keyUp(with : event) //이 매서드는 이벤트를 다시 체인으로 넘긴다.
     }*/
    
}









class PTextNode : PNode
{
    
    //추가적으로 텍스트필드를 갖고있다. 본 뷰의 서브뷰로 지정됨
    let textfield : PTextField
    
    
    ////////////////////////////////////////////////////////////////
    
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
    
    
    ////////////////////////////////////////////////////////////////
    
    
    
    //편집 매서드 오버라이드
    //텍스트 필드의 편집을 활성화한다
    override func focus() {
        textfield.isEditable = true
        textfield.becomeFirstResponder()
    }
}




