//
//  PLine.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 7..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa



enum P_LINK_TYPE {
    case FREE
    case ARROW
}


class PLink : Hashable, Equatable
{
    var hashValue: Int {
        get {
            return superview.viewNumber.hashValue << 15 + node_1.nodeNumber.hashValue + node_2.nodeNumber.hashValue
        }
    }
    
    static func ==(lhs: PLink, rhs: PLink) -> Bool {
        return (lhs.superview == rhs.superview) && (lhs.node_1 == rhs.node_1) && (lhs.node_2 == rhs.node_2)
    }
    
    let superview : PCustomView
    
    let node_1 : PNode
    let node_2 : PNode
    
    init(view v : PCustomView, node1 n1 : PNode, node2 n2 : PNode) {
        self.superview = v
        
        var node1 = n1
        var node2 = n2
        
        if n2.nodeNumber < n1.nodeNumber {
            node1 = n2
            node2 = n1
        }
        else if n1.nodeNumber == n2.nodeNumber {
            print("Link Creation Error")
            exit(0)
        }
        
        self.node_1 = node1
        self.node_2 = node2
    }
    
    func getOppositeNode(node n : PNode) -> PNode {
        var node = self.node_2
        
        if n == self.node_2 {
            node = self.node_1
        }
        
        return node
    }
    
    
    func draw() {
        self.superview.PDrawLink(pos_1: self.node_1.centerPoint, pos_2: self.node_2.centerPoint)
    }
    
}


class PFreeLink : PLink
{
    override init(view v: PCustomView, node1 n1: PNode, node2 n2: PNode) {
        super.init(view: v, node1: n1, node2: n2)
    }
    
    
}







