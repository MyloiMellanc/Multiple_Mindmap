//
//  PNode.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 7..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics


enum P_NODE_TYPE : Int {
    case ERROR = 0
    case TEXT = 1
    case CRAWLING = 2
}




class PNode : NSView    //PNode를 상속하는 모든 노드가 기본 뷰를 가질 예정으로, 미리 상속받음
{
    let type : P_NODE_TYPE
    
    func getType() -> P_NODE_TYPE {
        return self.type
    }
    
    
    //노드 고유 인식 번호 부여 관련
    static var nodeCount = 0
    static var IDTable = Set<Int>()
    
    static func initIDTable() {
        PNode.nodeCount = 0
        PNode.IDTable.removeAll()
    }
    
    static func getNewID() -> Int {
        repeat {
            PNode.nodeCount = PNode.nodeCount + 1
        } while PNode.IDTable.contains(PNode.nodeCount) == true
        
        PNode.IDTable.insert(PNode.nodeCount)
        
        return PNode.nodeCount
    }
    
    let nodeID : Int
    
    func getID() -> Int {
        return self.nodeID
    }
    
    
    
    ////////////////////////////////////////////////////////////////
    
    //노드 생성시 그래픽 기본값 관련

    static let gap : CGFloat = 3.0
    
    static func getNodeSize(type : P_NODE_TYPE) -> (CGFloat, CGFloat) {
        switch (type) {
        case .TEXT:
            return (60.0, 30.0)
        case .CRAWLING:
            return (80.0, 80.0)
        default:
            return (100.0, 100.0)
        }
    }
    
    ////////////////////////////////////////////////////////////////
    
    //노드의 Frame은 NSView에서 관리됨.
    //터치와 링크 드로잉에 중간값이 필요
    //차후에 문제가 생기면 다시 하드코딩으로 부여하는 것으로 변경
    var centerPoint : CGPoint {
        get {
            return CGPoint(x: self.frame.origin.x + self.frame.size.width / 2, y: self.frame.origin.y + self.frame.size.height / 2)
        }
    }
    
    
    ////////////////////////////////////////////////////////////////
    
    
    init(position touchPoint : CGPoint, type : P_NODE_TYPE, delay : CFTimeInterval = 0.0)
    {
        self.nodeID = PNode.getNewID()
        self.type = type
    
        let nodeSize = PNode.getNodeSize(type: type)
        
        let framePoint = CGPoint(x: touchPoint.x - (nodeSize.0 / 2 + PNode.gap), y: touchPoint.y - (nodeSize.1 / 2 + PNode.gap) )
        let frameRect = NSRect(x: framePoint.x, y: framePoint.y, width: nodeSize.0 + (PNode.gap * 2), height: nodeSize.1 + (PNode.gap * 2))
        super.init(frame : frameRect)
        
        
        self.wantsLayer = true
        self.layer = CAShapeLayer()
        
        self.layer?.backgroundColor = NSColor.black.cgColor
        
        
        if delay != 0 {
            let visible_animation = CABasicAnimation(keyPath: "transform.scale")
            visible_animation.duration = delay
            visible_animation.fromValue = 0
            visible_animation.toValue = 0
            
            self.layer?.add(visible_animation, forKey: "visible")
        }
        
        let scale_animation = CASpringAnimation(keyPath: "transform.scale")
        scale_animation.duration = 0.6
        scale_animation.fromValue = 0
        scale_animation.toValue = 1
        scale_animation.beginTime = CACurrentMediaTime() + delay
        
        let position_animation = CASpringAnimation(keyPath: "position")
        position_animation.duration = 0.6
        position_animation.fromValue = touchPoint
        position_animation.toValue = framePoint
        position_animation.beginTime = CACurrentMediaTime() + delay
        
        self.layer?.add(scale_animation, forKey: "scale")
        self.layer?.add(position_animation, forKey: "move")
    }
    
    init(id : Int, position touchPoint : CGPoint, type : P_NODE_TYPE, delay : CFTimeInterval = 0.0) {
        self.nodeID = id
        PNode.IDTable.insert(self.nodeID)
        
        self.type = type
        
        let nodeSize = PNode.getNodeSize(type: type)
        
        let framePoint = CGPoint(x: touchPoint.x - (nodeSize.0 / 2 + PNode.gap), y: touchPoint.y - (nodeSize.1 / 2 + PNode.gap) )
        let frameRect = NSRect(x: framePoint.x, y: framePoint.y, width: nodeSize.0 + (PNode.gap * 2), height: nodeSize.1 + (PNode.gap * 2))
        super.init(frame : frameRect)
        
        
        self.wantsLayer = true
        self.layer = CAShapeLayer()
        
        self.layer?.backgroundColor = NSColor.black.cgColor
        
        if delay != 0.0 {
            let visible_animation = CABasicAnimation(keyPath: "transform.scale")
            visible_animation.duration = delay
            visible_animation.fromValue = 0
            visible_animation.toValue = 0
        
            self.layer?.add(visible_animation, forKey: "visible")
        }
            
        let scale_animation = CASpringAnimation(keyPath: "transform.scale")
        scale_animation.duration = 0.6
        scale_animation.fromValue = 0
        scale_animation.toValue = 1
        scale_animation.beginTime = CACurrentMediaTime() + delay
        
        let position_animation = CASpringAnimation(keyPath: "position")
        position_animation.duration = 0.6
        position_animation.fromValue = touchPoint
        position_animation.toValue = framePoint
        position_animation.beginTime = CACurrentMediaTime() + delay
        
        self.layer?.add(scale_animation, forKey: "scale")
        self.layer?.add(position_animation, forKey: "move")
    }
    
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ////////////////////////////////////////////////////////////////
    
    //노드의 링크 관리
    //순서가 필요 없으므로 집합 자료구조를 사용
    var linkList = Set<PLink>()
    
    func addLink(link : PLink) {
        self.linkList.insert(link)
    }
    
    
    //used only by PLink
    func detachLink(link : PLink) {
        self.linkList.remove(link)
    }
    
    func getSubNodeListWithPass() -> Array<PNode> {
        var nodeList = Array<PNode>()
        
        for link in self.linkList {
            if link.isPassed() == false {
                link.pass()
                let node = link.getOtherNode(callBy: self)
                nodeList.append(node)
            }
        }
        
        return nodeList
    }
    
    
    ////////////////////////////////////////////////////////////////
    
    //마우스 터치 관련 매서드
    //노드를 드래그한 이후에도 mouseUp을 호출하지 않도록 토큰 사용
    var moved : Bool = false
    
    func moveNode(with event: NSEvent) {
        self.frame.origin.x += event.deltaX
        self.frame.origin.y -= event.deltaY //어째서 Y 변화량의 축이 다르지?
        
        if event.modifierFlags.contains(.shift) {
            for link in self.linkList {
                if link.isParent(node: self) == true {
                    link.getOtherNode(callBy: self).moveNode(with: event)
                }
            }
        }
        
        self.superview?.needsDisplay = true
    }
    
    override func mouseDragged(with event: NSEvent) {
        moveNode(with: event)
        
        self.moved = true
    }
    
    
    //드래그가 아니라면, 해당 노드를 활성화하도록 CustomView에게 호출
    override func mouseUp(with event: NSEvent) {
        if self.moved == false {
            self.superview?.PSelectNode(target: self, key: event)
        }
        
        self.moved = false
    }
    
    ////////////////////////////////////////////////////////////////
    
    //오버라이드 전용 노드 편집 매서드
    
    func toggle() {
        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    func untoggle() {
        self.layer?.backgroundColor = NSColor.black.cgColor
    }
    
    func focus() {
        
    }
    
}








