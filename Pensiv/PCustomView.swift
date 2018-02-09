//
//  PCustomView.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 19..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa
import CoreData
import CoreGraphics
import QuartzCore



/*
 *
 *  빈곳을 클릭했을때 활성화 제거 -> 본 커스텀 뷰가 노드와 라인을 보유하여야 한다
 *  커스텀 뷰의 터치 매서드는 빈곳을 클릭했을 때만 호출되므로, 해당 매서드에 활성화 제거 매서드를 넣는다
 *
 *  두 노드간의 관계형성도 동일한 방식으로 수행
 *
 *
 */


extension NSView
{
    @objc func PSelectNode(target node : PNode, key event : NSEvent) {
        
    }
    
    @objc func PDrawLink(pos_1 pos1 : CGPoint, pos_2 pos2 : CGPoint) {
        
    }
    
    @objc func PCreateNode(text str : String, position pos : CGPoint) {
        
    }
}




//나중에 view controller 설정할 때, 노드처럼 넘버 만들것

class PCustomView : NSView
{
    
    var viewNumber : Int = 1
    //static var viewCount : Int = 0
    
    var dataManager : PDataManager?
    
    
    func initDataBase() {
        if let dele = NSApplication.shared.delegate as? AppDelegate {
            dataManager = PDataManager(mother : dele)
        }
    }
    
    
    override func viewDidEndLiveResize() {
        //Struct is copy-based value
        var frame = NSApplication.shared.windows.first?.frame
        frame?.origin = CGPoint(x: 0, y: 0)
        self.frame = frame!
    }
    
    override func viewWillDraw() {
        self.layer?.backgroundColor = CGColor.white
    }
    
    
    
    
    var activatedNodeList = Set<PNode>()
    
    func clearActivatedNode() {
        for node in activatedNodeList {
            node.layer?.backgroundColor = NSColor.black.cgColor
        }
        
        activatedNodeList.removeAll()
    }
    
    func toggleNode(target node : PNode, onoff : Bool) {
        if onoff == true {
            self.activatedNodeList.insert(node)
            node.layer?.backgroundColor = CGColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
        else {
            self.activatedNodeList.remove(node)
            node.layer?.backgroundColor = NSColor.black.cgColor
        }
        
        print("Activated Count : \(self.activatedNodeList.count)")
    }
    
    
    
    func deleteNode(target node : PNode) {
        for link in node.linkList {
            self.deleteLink(link: link)
        }
        
        node.removeFromSuperview()
        self.nodeList.remove(node)
    }
    
    
    
    
    var linkList = Set<PLink>()
    
    func createLink(node_1 node1 : PNode, node_2 node2 : PNode)
    {
        let link = PFreeLink(view : self, node1 : node1, node2 : node2)
        self.linkList.insert(link)
        node1.addLink(link: link)
        node2.addLink(link: link)
        
    }
    
    func searchLink(node_1 node1 : PNode, node_2 node2 : PNode) -> PLink? {
        for link in self.linkList {
            if (link.superview == self) && (link.node_1 == node1) && (link.node_2 == node2) {
                return link
            }
            else if (link.superview == self) && (link.node_2 == node1) && (link.node_1 == node2) {
                return link
            }
        }
        
        return nil
    }
    
    func deleteLink(link : PLink) {
        link.node_1.detachLink(link: link)
        link.node_2.detachLink(link: link)
        self.linkList.remove(link)
    }
    
    
    override func PSelectNode(target node: PNode, key event : NSEvent) {
        //이미 활성화 되어있는지 여부, 특정 키 눌려있는지 여부, 그리고 둘다 눌려있다면?
        //둘다 눌려있다면 걍 시프트가 먼저 적용됨
        if event.modifierFlags.contains(.shift) == true {
            if self.activatedNodeList.contains(node) == true {
                self.toggleNode(target: node, onoff: false)
            }
            else {
                self.toggleNode(target: node, onoff: true)
            }
            
        }
        else if event.modifierFlags.contains(.control) == true {
            if self.activatedNodeList.contains(node) {
                return
            }
            
            var create_count = 0
            for act_node in self.activatedNodeList {
                let link : PLink? = self.searchLink(node_1: act_node, node_2: node)
                if link == nil {
                    createLink(node_1: act_node, node_2: node)
                    create_count += 1
                }
                
            }
            
            if create_count == 0 {
                for act_node in self.activatedNodeList {
                    let link = self.searchLink(node_1: act_node, node_2: node)
                    self.deleteLink(link: link!)
                }
            }
            
            self.needsDisplay = true
        }
        else {
            self.clearActivatedNode()
            self.toggleNode(target: node, onoff : true)
        }
        
        window?.makeFirstResponder(self)
    }
    
    
    
    
    override func PDrawLink(pos_1 pos1: CGPoint, pos_2 pos2: CGPoint) {
        let a = NSBezierPath()
        a.move(to: pos1)
        a.line(to: pos2)
        a.lineWidth = 2.0
        a.stroke()
    }
    
    
    
    override func draw(_ dirtyRect: NSRect) {
        
        //Line들이 먼저 그려져야하므로, 모든 라인 드로우를 여기에서 담당
        for link in linkList {
            link.draw()
        }
        
        
        
        //서브 뷰의 드로잉은 여기서 처리하지 않고, 각자 알아서 하는 것 같다.
        
        //super.draw(dirtyRect)
        
    }
    
    
    
    
    
    
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        
        for subview in subviews
        {
            let converted_point = subview.convert(point, from: subview)
            let hittestview : NSView? = subview.hitTest(converted_point)
            if (hittestview != nil)
            {
                return hittestview
            }
        }
        
        return self
    }
    
    
    
    
    
    
    var nodeList = Set<PNode>()

    
    
    // 해당 이벤트를 여기서 사용한다 라는 의미
    // 하지만 그냥 true를 리턴하면 모든 키 이벤트를 여기로 보내므로, 종료 단축키와 같은 것도 안됨
     override func performKeyEquivalent(with event: NSEvent) -> Bool {
     return true
     
     //필요한 키들만 true를 리턴하게 만든다
     }
 
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    
    override func keyUp(with event: NSEvent) {
        //
        // 무조건 이 뷰가 first responder가 되어야 이 매서드를 사용할 수 있다.
        //
        if event.keyCode == 51 {    //DELETE
            for node in self.activatedNodeList {
                self.deleteNode(target: node)
            }
        }
        else if event.keyCode == 36 {   //ENTER
            if self.activatedNodeList.count == 1 {
                self.activatedNodeList.first?.focus()
            }
        }
        else {
            //이 뷰에서 사용하지 않는 키는 밑으로 보낸다
            super.keyUp(with: event)
        }
        
        self.needsDisplay = true
    }
    
    
    override func mouseUp(with event: NSEvent) {
        //hit test 에 걸린 뷰가 존재한다면, 이 매서드는 호출되지 않는다.
        //따라서 이 매서드가 호출되었다면, 노드는 클릭되지 않은 것이다. 따라서 활성화 노드를 제거한다.
        
        //마우스가 정확히 같은 곳을 클릭했을 때, 이벤트의 클릭 카운트가 증가한다.
        //노드가 생성된 뒤, 마우스를 움직이지 않으면 노드를 클릭해도 노드색깔이 바뀌지 않는다.
        let eventOrigin = self.convert(event.locationInWindow, to: nil)
        
        
        if (event.clickCount == 1) && (event.modifierFlags.contains(.control)) {
            
        }
        else if (event.clickCount == 2) && (event.modifierFlags.contains(.option)) {
            let pnode = PTextNode(position: eventOrigin)
            self.nodeList.insert(pnode)
            self.addSubview(pnode)
            
            
            print("Create new PNode at (\(eventOrigin.x), \(eventOrigin.y))")
            
            pnode.focus()
        }
        else {
            //이 뷰를 다시 첫 리스폰더로 지정
            window?.makeFirstResponder(self)
            
            //활성화 초기화
            self.clearActivatedNode()
            print("Activated Count : \(self.activatedNodeList.count)")
        }
        
    }
    
    
    
    var startPoint : CGPoint!
    var shapeLayer : CAShapeLayer!
    
    //드래그도 필연적으로 업다운 매서드를 호출시키게 된다.
    //다운은 단순 다운 선언. 업이 되엇을때 해결
    override func rightMouseDown(with event: NSEvent) {
        self.startPoint = self.convert(event.locationInWindow, from: nil)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = NSColor.clear.cgColor
        shapeLayer.strokeColor = NSColor.black.cgColor
        shapeLayer.lineDashPattern = [10, 5]
        self.layer?.addSublayer(shapeLayer)
        
        var dashAnimation = CABasicAnimation()
        dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        dashAnimation.duration = 0.75
        dashAnimation.fromValue = 0.0
        dashAnimation.toValue = 15.0
        dashAnimation.repeatCount = .infinity
        shapeLayer.add(dashAnimation, forKey: "linePhase")
    }
    
    override func rightMouseDragged(with event: NSEvent) {
        let point : NSPoint = self.convert(event.locationInWindow, from: nil)
        let path = CGMutablePath()
        
        path.move(to: self.startPoint)
        path.addLine(to: NSPoint(x : self.startPoint.x, y : point.y))
        path.addLine(to: point)
        path.addLine(to: NSPoint(x: point.x, y: self.startPoint.y))
        path.closeSubpath()
        self.shapeLayer.path = path
    }
    
    override func rightMouseUp(with event: NSEvent) {
        self.shapeLayer.removeFromSuperlayer()
        self.shapeLayer = nil
    }
    
    
 
}











/*
 override var isFlipped: Bool{
 get {
 return false
 }
 }*/



/*
 override func updateTrackingAreas() {
 if (trackingarea != nil)
 {
 self.removeTrackingArea(trackingarea!)
 }
 
 let options : NSTrackingArea.Options = [.activeWhenFirstResponder, .mouseMoved]
 
 trackingarea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
 
 self.addTrackingArea(trackingarea!)
 
 }
 */



