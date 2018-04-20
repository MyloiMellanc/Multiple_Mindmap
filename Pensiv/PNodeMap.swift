//
//  PNodeMap.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2018. 3. 20..
//  Copyright © 2018년 MyloiMellanc. All rights reserved.
//

import Foundation



class PTextItem
{
    let depth : Int
    let text : String
    
    init(depth : Int, text : String) {
        self.depth = depth
        self.text = text
    }
    
    var linkList = Array<PLinkItem>()
    
    func addSubNode(target : PTextItem) {
        let linkItem = PLinkItem(target: target)
        
        self.linkList.append(linkItem)
    }
    
    func printMap() {
        print("\(self.depth) : \(self.text)")
        for link in self.linkList {
            link.textItem.printMap()
        }
    }
    
    func getHighestDepth() -> Int {
        var highestDepth = 0
        
        if self.linkList.count == 0 {
            highestDepth = self.depth
        }
        else {
            for link in self.linkList {
                let next_depth = link.textItem.getHighestDepth()
                if next_depth > highestDepth {
                    highestDepth = next_depth
                }
            }
        }
        
        return highestDepth
    }
    
    func getTextsByDepth(depth : Int) -> Array<String> {
        var arr = Array<String>()
        
        if self.depth == depth {
            arr.append(self.text)
        }
        else {
            for link in self.linkList {
                let next_arr = link.textItem.getTextsByDepth(depth: depth)

                
                arr.append(contentsOf: next_arr)
            }
        }
        
        return arr
    }
    
    func getTextItemsByDepth(depth : Int) -> Array<PTextItem> {
        var arr = Array<PTextItem>()
        
        if self.depth == depth {
            arr.append(self)
        }
        else {
            for link in self.linkList {
                let next_arr = link.textItem.getTextItemsByDepth(depth: depth)
                
                
                arr.append(contentsOf: next_arr)
            }
        }
        
        return arr
    }
    
    func createRelatedTexts(instance : PDataThread, limit : Int) {
        for link in self.linkList {
            link.createRelatedTexts(instance: instance, text: self.text, limit: limit)
        }
    }
}




class PLinkItem
{
    var relatedTextList = Array<String>()
    
    func createRelatedTexts(instance : PDataThread, text : String, limit : Int) {
        let related_texts = instance.getRelatedTexts(str_1: text, str_2: self.textItem.text, limit: limit)
        
        self.relatedTextList.append(contentsOf: related_texts)
    }
    
    
    let textItem : PTextItem
    
    init(target : PTextItem) {
        self.textItem = target
    }
    
    
    
}








