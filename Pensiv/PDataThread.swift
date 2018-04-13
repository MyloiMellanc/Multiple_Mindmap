//
//  PDataManager.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 1. 12..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa



class PDataThread
{
    static let pInstance = PDataThread()
    
    var thread : Thread?
    
    let dataManager = Neo4jWrapper()
    
    func initWrapper() {
        self.dataManager.initWrapper()
    }
    
    func connect() -> Bool {
        return self.dataManager.connect()
    }
    
    func disconnect() {
        self.dataManager.disconnect()
    }
    
    
    private init() {
        print("Singleton Thread is created.")
    }
    
    deinit {
        dataManager.disconnect()
    }
    
    ///////////////////////////////////////////////////////////////////////////
    
    
    
    var parent : PNode?
    var maps : Array<PTextItem>?
    
    func startThread(parent : PNode, maps : Array<PTextItem>) {
        self.parent = parent
        self.maps = maps
        
        //let thread = Thread(target: self, selector: Selector("run"), object: nil)
        //thread.start()
        //Thread.detachNewThreadSelector("crawl", toTarget: self, with: nil)
        self.run()
    }
    
    private func run() {
        var arr = Array<String>()
        
        let query = """
                    match p=(a)-[*..3]-(b) where a.Name = '리니지' AND b.Name = '로그라이크'
                    with nodes(p) as nds limit 4
                    unwind nds as nd
                    return distinct nd.Name
                    """
        
        if dataManager.runQuery(query) == true {
            while let data = dataManager.fetchNextResult() {
                arr.append(data)
            }
        }
        
        
        var nodes = self.createNodeFromArray(depth: 0, width: 300, parent: self.parent!, arr: arr)

        
    }
    
    private func createNodeFromArray(depth : Int, width : CGFloat, parent : PNode, arr : Array<String>) -> Array<PNode> {
        let depthDistance = CGFloat(depth) * 70.0
        
        let division = arr.count - 1
        let distance = width / CGFloat(division)
        let position_x_start = parent.frame.origin.x - (width / 2.0) + (parent.frame.size.width / 2.0)
        let position_y = parent.frame.origin.y - depthDistance - 100.0
        
        var nodes = Array<PNode>()
        
        for (n,text) in arr.enumerated() {
            let position = CGPoint(x: position_x_start + (distance * CGFloat(n)), y: position_y)
            
            let textnode = PTextNode(position: position, text: text)
            
            parent.superview?.PAddNode(target: textnode)
            parent.superview?.PCreateLink(node_1: parent, node_2: textnode)
            
            nodes.append(textnode)
        }
        
        return nodes
    }
    
}
