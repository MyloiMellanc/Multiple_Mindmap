//
//  PCrawlingNode.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 1. 19..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa




class PCrawlingNode : PNode
{
    
    
    ////////////////////////////////////////////////////////////////
    
    
    
    override init(position touchPoint: CGPoint) {
        
        
        super.init(position: touchPoint)
    }
    
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ////////////////////////////////////////////////////////////////
    
    override func draw(_ dirtyRect: NSRect) {
        
    }
    
    
    
    ////////////////////////////////////////////////////////////////
    
    
    override func focus() {
        //스레드 가동
    }
    
    
    
    ////////////////////////////////////////////////////////////////
    
    
    
}








