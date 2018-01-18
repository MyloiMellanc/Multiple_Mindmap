//
//  PCrawlingNode.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 1. 19..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa


class PCrawlingNode : PFunctionNode
{
    
    lazy private var _crawler = DemoWordCrawler()
    
    override func initNodeData() {
        
    }
    
    override func draw(_ dirtyRect : NSRect)
    {
        
    }
}
