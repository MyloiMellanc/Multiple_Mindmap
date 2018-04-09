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
    var depth : Int
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
        for linkitem in self.linkList {
            linkitem.subNode.printMap()
        }
    }
    
}




class PLinkItem
{
    var relatedTextList = Array<String>()
    
    func addRelatedText(text : String) {
        self.relatedTextList.append(text)
    }
    
    
    let subNode : PTextItem
    
    init(target : PTextItem) {
        self.subNode = target
    }
    
    
    
}








