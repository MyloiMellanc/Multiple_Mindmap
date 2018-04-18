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
    var textArray : Array<Array<String>>?
    
    private func getHighestDepthFromMap() -> Int {
        var max_depth = 0
        for item in self.maps! {
            let highestDepth = item.getHighestDepth()
            if highestDepth > max_depth {
                max_depth = highestDepth
            }
        }
        
        return max_depth
    }
    
    private func getTextsByDepth(depth : Int) -> Array<String> {
        var arr = Array<String>()
        
        for item in self.maps! {
            let text_arr = item.getTextsByDepth(depth: depth)
            
            arr.append(contentsOf: text_arr)
        }
        
        return arr
    }
    
    private func createTextArray() {
        let max_depth = self.getHighestDepthFromMap()
        
        self.textArray = Array<Array<String>>()
        
        for index in 0...max_depth {
            let arr = self.getTextsByDepth(depth: index)
            
            self.textArray?.insert(arr, at: index)
        }
    }
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////
    
    
    func startThread(parent : PNode, maps : Array<PTextItem>) {
        self.parent = parent
        self.maps = maps
        self.createTextArray()
        
        print(self.textArray!)
        
        //let thread = Thread(target: self, selector: Selector("run"), object: nil)
        //thread.start()
        //Thread.detachNewThreadSelector("crawl", toTarget: self, with: nil)
        
        
        //var nodes = self.createNodeFromArray(depth: 0, width: 300, parent: self.parent!, arr: arr)
        self.createRelatedMap()
    }
    
    private func createRelatedMap() {
        let max_depth = self.getHighestDepthFromMap()
        
        //각각의 블럭에서 생성할 노드 개수는 다음 깊이의 노드 수
        
        //깊이 0인 메인 블럭
        //var node_arr = createBaseMap()
        var first_arr = self.getTextsByDepth(depth: 0)
        let next_arr = self.getTextsByDepth(depth: 1)
        
        var text_arr = self.runQuery(str_1: first_arr[0], str_2: first_arr[1], limit: next_arr.count)
        var node_arr = self.createNodeFromArray(depth: 0, width: 400, parent: self.parent!, arr: text_arr)
        
        
        for index in 0..<node_arr.count {
            let texts = self.runQuery(str_1: text_arr[index], str_2: next_arr[index], limit: 2)
            
            self.createNodeFromArray(depth: 1, width: 100, parent: node_arr[index], arr: texts)
        }
        
    }
    
    private func runQuery(str_1 : String, str_2 : String, limit : Int) -> Array<String> {
        var arr = Array<String>()
        
        let query = """
                    match p=(a)-[*..3]-(b) where a.Name = '\(str_1)' AND b.Name = '\(str_2)'
                    with nodes(p) as nds limit 10
                    unwind nds as nd
                    return distinct nd.Name
                    """
        
        if dataManager.runQuery(query) == true {
            while let data = dataManager.fetchNextResult() {
                if arr.count < limit {
                    if (data != str_1) && (data != str_2) {
                        arr.append(data)
                    }
                }
            }
        }
        
        
        return arr
        
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
