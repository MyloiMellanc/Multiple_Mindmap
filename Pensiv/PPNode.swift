//
//  PPNode.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 1. 24..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa


class PPNode : NSTextField, NSTextViewDelegate
{
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
