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
    
    var link_list = Array<PLinkItem>()
    
    func addSubNode(target : PTextItem) {
        let linkItem = PLinkItem(target: target)
        
        self.link_list.append(linkItem)
    }
    
    func printMap() {
        print("\(self.depth) : \(self.text)")
        for linkitem in self.link_list {
            linkitem.subNode.printMap()
        }
    }
    
}




class PLinkItem
{
    var relatedText_list = Array<String>()
    
    func addRelatedText(text : String) {
        self.relatedText_list.append(text)
    }
    
    
    let subNode : PTextItem
    
    init(target : PTextItem) {
        self.subNode = target
    }
    
    
    
}








