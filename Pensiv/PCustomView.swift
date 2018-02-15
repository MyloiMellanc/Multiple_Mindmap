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



//노드들이 superview를 통해서 메인 뷰에 요청하는 매서드들
//superview가 NSView로 레퍼런스되어있어, 부득이하게 Extension으로 인터페이스를 생성해서 사용
extension NSView
{
    @objc func PSelectNode(target node : PNode, key event : NSEvent) {
        
    }
    
    @objc func PDrawLink(pos_1 pos1 : CGPoint, pos_2 pos2 : CGPoint) {
        
    }
    
    @objc func PCreateNode(target node : PNode, position pos : CGPoint) {
        //차후 크롤링 노드가 재귀적으로 새로운 노드를 생성할 때, 이 매서드를 통해 중앙 뷰에 전달한다
    }
    
    @objc func PCreateLink(node_1 node1 : PNode, node_2 node2 : PNode) {
        
    }
}




class PCustomDocumentView : NSView
{
    
    ////////////////////////////////////////////////////////////////
    
    
    //갖고있는 노드들을 관리, 순서 상관없으므로 집합으로 관리
    //모든 노드들은 본 리스트 컬렉션과 서브뷰 컬렉션에서 참조된다.
    var nodeList = Set<PNode>()
    
    
    
    func createTextNode(position : CGPoint, text : String) -> PTextNode {
        let textnode = PTextNode(position: position, text: text)
        
        self.nodeList.insert(textnode)
        self.addSubview(textnode)
        
        return textnode
    }
    
    
    
    ////////////////////////////////////////////////////////////////
    
    
    //맵 편집을 위한 활성화 노드 관리는 전부 본 뷰에서 담당한다
    //순서가 필요없으므로 집합으로 관리한다.
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
    
    
    
    ////////////////////////////////////////////////////////////////
    
    
    //노드간의 링크를 나타내는 객체는 생성될때 본 메인 뷰, 각 두 노드, 총 3곳에서 참조된다.
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
    
    
    
    ////////////////////////////////////////////////////////////////
    
    
    //노드가 마우스 이벤트를 받았을 떄, 메인 뷰로 다시 호출하는 매서드
    //활성화와 링크 생성에 관련됨
    override func PSelectNode(target node: PNode, key event : NSEvent) {
        //이미 활성화 되어있는지 여부, 특정 키 눌려있는지 여부, 그리고 둘다 눌려있다면 시프트가 적용됨
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
    
    
    ////////////////////////////////////////////////////////////////
    
    
    //렌더링 관련 매서드들
    //본 메인 뷰 드로잉 매서드가 먼저 호출된 뒤에 노드들의 드로잉 매서드가 호출되므로
    //노드 뒤에 가려지게 그려질 링크는 노드들보다 먼저 그려져야하므로, 본 메인 뷰에서 링크 드로잉을 담당한다.
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
        
        
        //서브 뷰의 드로잉은 여기서 처리하지 않고, 각자의 드로잉 매서드에서 처리된다
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////
    
    /*
     
     
     //해당 히트 테스트는 스크롤 뷰로 바꾼 뒤 정상적으로 작동하지 않음, 위치에 대한 조정이 필요
     //이 매서드 오버라이드를 없애면 정상적으로 작동
     
     override func hitTest(_ point: NSPoint) -> NSView? {
     for subview in (self.documentView?.subviews)!
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
     
     
     */
    
    ////////////////////////////////////////////////////////////////
    
    
    //메인 뷰의 인풋 이벤트 관련 매서드
    
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
        
        let pos = self.convert(event.locationInWindow, from: nil)
        
        if (event.clickCount == 1) && (event.modifierFlags.contains(.control)) {
            
        }
        else if (event.clickCount == 2) && (event.modifierFlags.contains(.option)) {
            let textnode = self.createTextNode(position: pos, text: "Text")
            textnode.focus()
        }
        else {
            //이 뷰를 다시 첫 리스폰더로 지정
            window?.makeFirstResponder(self)
            
            //활성화 초기화
            self.clearActivatedNode()
            print("Activated Clear")
        }
        
    }
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////
    
    //우클릭 박스생성 관련 매서드
    
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



//나중에 view controller 설정할 때, 노드처럼 넘버를 부여할 것
class PCustomView : NSScrollView
{
    
    var viewNumber : Int = 1
    //static var viewCount : Int = 0
    
    
    ////////////////////////////////////////////////////////////////
    
    
    //윈도우 창이 변경되었을 떄 호출
    override func viewDidEndLiveResize() {
        //Struct is copy-based value
        var frame = NSApplication.shared.windows.first?.frame
        frame?.origin = CGPoint(x: 0, y: 0)
        self.frame = frame!
    }
    
    override func viewWillDraw() {
        self.layer?.backgroundColor = CGColor.white
    }
    
    
    ////////////////////////////////////////////////////////////////
    
    
    
    // 해당 이벤트를 여기서 사용한다 라는 의미
    // 하지만 그냥 true를 리턴하면 모든 키 이벤트를 여기로 보내므로, 종료 단축키와 같은 것도 안됨
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
        
        //필요한 키들만 true를 리턴하게 만든다
    }
    
    
    override var acceptsFirstResponder: Bool {
        return true
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



