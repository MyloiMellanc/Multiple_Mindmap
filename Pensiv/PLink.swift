//
//  PLine.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 7..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa



enum P_LINK_TYPE : Int {
    case FREE = 0
    case ARROW = 1
}


class PLink : Hashable, Equatable
{
    var hashValue: Int {
        get {
            return self.superview.hashValue + self.linkID.hashValue
        }
    }
    
    
    static func ==(lhs: PLink, rhs: PLink) -> Bool {
        return (lhs.getID() == rhs.getID())
    }
    
    
    var timer : Timer? = nil
    @objc func updateTimer() {
        //이차함수를 사용하여 만들 것
    }
    
    static var linkCount : Int = 0
    
    let linkID : Int
    let superview : NSView
    
    let type : P_LINK_TYPE
    
    func getID() -> Int {
        return self.linkID
    }
    
    func getType() -> P_LINK_TYPE {
        return self.type
    }
    
    init(view : NSView, type : P_LINK_TYPE, animate : Bool = false) {
        PLink.linkCount = PLink.linkCount + 1
        self.linkID = PLink.linkCount
        
        
        self.superview = view
        self.type = type
        
        if animate == true {
            
        }
    }
    
    
    
    func draw() {
        
    }
    
    
    func detachNode() {
        
    }
    
    func itContains(view : NSView, node1 : PNode, node2 : PNode) -> Bool {
        return false
    }
    
    func getNodes() -> (PNode, PNode) {
        return (PNode(position: CGPoint(), type: .ERROR), PNode(position: CGPoint(), type: .ERROR))
    }
    
    func getOtherNode(callBy node : PNode) -> PNode {
        print("Accessing Inappropriate LinkNode")
        return PNode(position: CGPoint(), type: .ERROR)
    }
    
    
    
    var passed = false
    
    func isPassed() -> Bool {
        return self.passed
    }
    
    func pass() {
        self.passed = true
    }
    
    func clearPass() {
        self.passed = false
    }
}



class PFreeLink : PLink
{
    let node_1 : PNode
    let node_2 : PNode
    

    init(view : NSView, node1 : PNode, node2 : PNode, animate : Bool = false) {
        var n1 = node1
        var n2 = node2
        
        if node1.getID() > node2.getID() {
            n1 = node2
            n2 = node1
            
        }
        else if node1.getID() == node2.getID() {
            print("Link Creation Error")
            exit(0)
        }
        
        self.node_1 = n1
        self.node_2 = n2
        
        
        super.init(view: view, type : .FREE, animate : animate)
    }
    
    override func draw() {
        self.superview.PDrawFreeLink(pos_1: self.node_1.centerPoint, pos_2: self.node_2.centerPoint)
    }
    
    override func detachNode() {
        self.node_1.detachLink(link: self)
        self.node_2.detachLink(link: self)
        
    }
    
    override func itContains(view: NSView, node1: PNode, node2: PNode) -> Bool {
        if (self.superview == view) && (self.node_1 == node1) && (self.node_2 == node2) {
            return true
        }
        else if (self.superview == view) && (self.node_1 == node2) && (self.node_2 == node1) {
            return true
        }
        
        return false
    }
    
    override func getNodes() -> (PNode, PNode) {
        return (self.node_1, self.node_2)
    }
    
    override func getOtherNode(callBy node: PNode) -> PNode {
        if node == self.node_1 {
            return self.node_2
        }
        else if node == self.node_2 {
            return self.node_1
        }
        else {
            print("Accessing Inappropriate LinkNode")
            return PNode(position: CGPoint(), type: .ERROR)
        }
    }
}


class PArrowLink : PLink
{
    let parentNode : PNode
    let childNode : PNode
    
    
    init(view : NSView, parent : PNode, child : PNode, animate : Bool = false) {
        self.parentNode = parent
        self.childNode = child
        
        super.init(view: view, type : .ARROW, animate : animate)
    }
    
    override func draw() {
        self.superview.PDrawArrowLink(pos_1: self.parentNode.centerPoint, pos_2: self.childNode.centerPoint)
    }
    
    override func detachNode() {
        self.parentNode.detachLink(link: self)
        self.childNode.detachLink(link: self)
        
    }
    
    override func itContains(view: NSView, node1: PNode, node2: PNode) -> Bool {
        if (self.superview == view) && (self.parentNode == node1) && (self.childNode == node2) {
            return true
        }
        else if (self.superview == view) && (self.parentNode == node2) && (self.childNode == node1) {
            return true
        }
        
        return false
    }
    
    override func getNodes() -> (PNode, PNode) {
        return (self.parentNode, self.childNode)
    }
    
    override func getOtherNode(callBy node: PNode) -> PNode {
        if node == self.parentNode {
            return self.childNode
        }
        else {
            print("Accessing Inappropriate LinkNode")
            return PNode(position: CGPoint(), type: .ERROR)
        }
    }
}





