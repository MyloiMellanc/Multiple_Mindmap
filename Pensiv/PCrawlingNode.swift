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
    let markView : NSView
    
    
    init(position touchPoint: CGPoint) {
        let nodeSize = PNode.getNodeSize(type: .CRAWLING)
        
        markView = NSView(frame: NSRect(x: PNode.gap, y: PNode.gap, width: nodeSize.0, height: nodeSize.1))
        
        markView.wantsLayer = true
        markView.layer = CAShapeLayer()
        markView.layer?.backgroundColor = NSColor.systemBlue.cgColor
        
        /*
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: PNode.baseHeight))
        path.addLine(to: CGPoint(x: PNode.baseWidth, y: PNode.baseHeight))
        path.addLine(to: CGPoint(x: PNode.baseWidth, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
 
        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.path = path
        layer.fillColor = NSColor.orange.cgColor
        layer.fillRule = kCAFillRuleEvenOdd
        layer.strokeColor = NSColor.black.cgColor
        layer.lineWidth = 7
        
        view.layer?.addSublayer(layer)
        */
        
        super.init(position: touchPoint, type : .CRAWLING)
        
        self.addSubview(markView)
        
        
    }
    
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ////////////////////////////////////////////////////////////////
    
    
    func collectConnectedMaps() -> Array<PTextItem>{
        self.superview?.PClearLinkPass()
        
        let nodeList = self.getSubNodeListWithPass()
        
        var mapList = Array<PTextItem>()
        for node in nodeList {
            if node.getType() == .TEXT {
                let textnode = node as! PTextNode
                let textItem = collectMap(root: textnode)
                
                mapList.append(textItem)
            }
        }
        
        return mapList
        
    }
    
    func collectNode(item : PTextItem, target : PTextNode) {
        let relatedNodes = target.getSubNodeListWithPass()
        
        for node in relatedNodes {
            if node.getType() == .TEXT {
                let textNode = node as! PTextNode
                let nodeItem = PTextItem(depth: item.depth + 1, text: textNode.getText())
                
                item.addSubNode(target: nodeItem)
                collectNode(item: nodeItem, target: textNode)
            }
        }
        
    }
    
    func collectMap(root : PTextNode) -> PTextItem {
        let textItem = PTextItem(depth: 0, text: root.getText())
        
        collectNode(item: textItem, target: root)
        
        
        return textItem
    }
    
    
    func clearMap() {
        
    }
    
    
    
    ////////////////////////////////////////////////////////////////
    
    
    func createNodeFromArray(depth : Int, width : CGFloat, parent : PNode, arr : Array<String>) {
        let depthDistance = CGFloat(depth) * 100.0
        
        let division = arr.count - 1
        let distance = width / CGFloat(division)
        let position_x_start = self.frame.origin.x - (width / 2.0) + (self.frame.size.width / 2.0)
        let position_y = self.frame.origin.y - depthDistance - 100.0
        
        for (n,text) in arr.enumerated() {
            let position = CGPoint(x: position_x_start + (distance * CGFloat(n)), y: position_y)
            
            let textnode = PTextNode(position: position, text: text)
            
            self.superview?.PAddNode(target: textnode)
            self.superview?.PCreateLink(node_1: parent, node_2: textnode)
        }
    }
    
    
    ////////////////////////////////////////////////////////////////
    
    
    
    let dataManager = Neo4jWrapper()
    
    func crawl() {
        let mapList = self.collectConnectedMaps()
        
        
        var arr = Array<String>()
        for node in mapList {
            arr.append(node.text)
        }
        
        
        self.createNodeFromArray(depth: 0, width: 300, parent: self, arr: arr)
    }
    
    @objc func crawlMapByThread() {
        
    }
    
    
    ////////////////////////////////////////////////////////////////
    
    
    var isRunning = false
    
    override func focus() {
        if self.isRunning == false {
            self.markView.layer?.backgroundColor = NSColor.orange.cgColor
            
            //스레드 시작
            
            //let thread = Thread(target: self, selector: Selector("crawl"), object: nil)
            //thread.start()
            //Thread.detachNewThreadSelector("crawl", toTarget: self, with: nil)
            
            print("Starting Crawling.")
            self.crawl()
            
            self.isRunning = true
        }
        else {
            
            
            //스레드 강제 종료
            
            
            self.markView.layer?.backgroundColor = NSColor.systemBlue.cgColor
            self.isRunning = false
        }
        
    }
    
    
    
    ////////////////////////////////////////////////////////////////
    
    
    
}








