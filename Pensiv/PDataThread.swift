//
//  PDataThread.swift
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
    var superview : PCustomDocumentView?
    
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
    
    
    
    private func getTextItemsByDepth(depth : Int) -> Array<PTextItem> {
        var arr = Array<PTextItem>()
        
        for item in self.maps! {
            let text_arr = item.getItemsByDepth(depth: depth)
            
            arr.append(contentsOf: text_arr)
        }
        
        return arr
    }
    
    
    
    ///////////////////////////////////////////////////////////////////////////
    
    
    
    func getRelatedTexts(str_1 : String, str_2 : String, limit : Int) -> Array<String> {
        let query = """
        match p=(a)-[*..4]-(b) where a.Name = '\(str_1)' AND b.Name = '\(str_2)'
        with nodes(p) as nds limit 10
        unwind nds as nd
        return distinct nd.Name
        """
        
        var arr = Array<String>()
        
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
    
    
    func getRelatedTextItems(depth : Int, str_1 : String, str_2 : String, limit : Int) -> Array<PTextItem> {
        let texts = self.getRelatedTexts(str_1: str_1, str_2: str_2, limit: limit)
        
        var items = Array<PTextItem>()
        for text in texts {
            let text_item = PTextItem(depth: depth, text: text)
            items.append(text_item)
        }
        
        print(depth)
        print(texts)
        
        return items
    }
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////
    
    private func createRelatedTextsToLink(limit : Int) {
        for item in self.maps! {
            item.createRelatedTexts(instance: self, limit: limit)
        }
    }
    
    
    var relatedMap = Array<PTextItem>()
    
    
    func make(depth : Int, item : PTextItem, arr : Array<PTextItem>, limit : Int) {
        for text in arr {
            let results = self.getRelatedTextItems(depth: depth, str_1: item.text, str_2: text.text, limit: limit)
            
            for result in results {
                text.addSubNode(target: result)
            }
            
            for next in item.linkList {
                self.make(depth: depth + 1, item: next.textItem, arr: results, limit: limit)
            }
        }
    }
    
    private func createRelatedMap() {
        self.createRelatedTextsToLink(limit: 1)
        
        //첫 목록 생성
        let first_items = self.getRelatedTextItems(depth: 0, str_1: "리니지", str_2: "로그라이크", limit: 4)
        
        self.relatedMap.append(contentsOf: first_items)
        
        
        let items = self.getTextItemsByDepth(depth: 1)
        for item in items {
            self.make(depth: 1, item: item, arr: first_items, limit: 1)
        }
        
        
        
        
        self.superview?.createNodeFromMap(parent: self.parent!, map: self.relatedMap)
        
    }
    
    
    
    func startThread(parent : PNode, maps : Array<PTextItem>) {
        self.parent = parent
        self.maps = maps
        
        
        //let thread = Thread(target: self, selector: Selector("run"), object: nil)
        //thread.start()
        //Thread.detachNewThreadSelector("crawl", toTarget: self, with: nil)
        
        
        //var nodes = self.createNodeFromArray(depth: 0, width: 300, parent: self.parent!, arr: arr)
        self.createRelatedMap()
    }
}
