//
//  PLine.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 7..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa


class PLine : NSView
{
    let _type = P_CLASS_TYPE.PLINE
    
    var node_1 : PPNode?
    var node_2 : PPNode?
    
    init(target_1 : PPNode, target_2 : PPNode) {
        super.init(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
        node_1 = target_1
        node_2 = target_2
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        
        
        //해당 매서드와 배지어 패스를 통한 그리기는 이 객체 초기화시의 뷰 크기에 맞춰진다.
        //따라서 현재상황에서는 커스텀 뷰에서 자체적으로 모든 라인을 그려주어야 한다.
        
        
        
        
        
        
        let path = NSBezierPath()
        
        
        NSColor.red.setFill()
        path.fill()
        
        NSColor.black.setFill()
        path.stroke()
        
        let p = NSBezierPath()
        let a = NSPoint(x: 0, y: 0)
        let b = NSPoint(x: 500, y: 300)
        p.move(to: a)
        p.line(to: b)
        p.lineWidth = 50
        p.lineCapStyle = .roundLineCapStyle
        p.stroke()
        
    }
}
