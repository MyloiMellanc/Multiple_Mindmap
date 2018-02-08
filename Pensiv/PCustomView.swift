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
    @objc func PSelectNode(target node : PNode) {
        
    }
    
    @objc func PDrawLink(pos_1 pos1 : CGPoint, pos_2 pos2 : CGPoint) {
        
    }
    
    @objc func PCreateNode(text str : String, position pos : CGPoint) {
        
    }
    
}






class PCustomView : NSView
{
    
    var viewNumber : Int = 1
    
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
    
    
    
    
    var selectedNode : PNode? = nil
    
    func clearSelectedNode() {
        if self.selectedNode != nil {
            self.selectedNode?.layer?.backgroundColor = CGColor.black
        }
        
        self.selectedNode = nil
    }
    
    func activateNode(target node : PNode) {
        if self.selectedNode == nil {
            self.selectedNode = node
            self.selectedNode?.layer?.backgroundColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
        }
    }
    
    
    
    
    var linkTable = [PLink]()
    
    func createLink(node_1 node1 : PNode, node_2 node2 : PNode)
    {
        let link = PLink(view : self, node_1 : node1, node_2 : node2)
        self.linkTable.append(link)
        self.needsDisplay = true
    }
    
    //노드가 없으면 활성화하고, 이미 있으면 둘 사이를 링크로 연결한다.
    override func PSelectNode(target node: PNode) {
        
        //이미 활성화된 노드와 다르면
            //스킵, 혹은 라인 생성?
        //활성화 노드가 없다면,
            //해당 노드를 활성화시킨다
        if self.selectedNode == nil {
            self.activateNode(target: node)
            
        }
        else {
            //활성화된 노드를 클릭했다면, 활성화를 중단한다.
            //두개가 다르면 링크 연결
            if self.selectedNode != node {
                createLink(node_1: self.selectedNode!, node_2: node)
            }
            else {
                self.clearSelectedNode()
            }
        }
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
        
        for link in linkTable {
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
    
    
    
    
    
    var nodetable = [PNode]()
    
    
    
    
    
    /* 해당 이벤트를 여기서 사용한다 라는 의미
     하지만 그냥 true를 리턴하면 모든 키 이벤트를 여기로 보내므로, 종료 단축키와 같은 것도 안됨
     override func performKeyEquivalent(with event: NSEvent) -> Bool {
     return true
     }
     */
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    
    override func keyDown(with event: NSEvent) {
        switch (event.keyCode)
        {
        case 53:
            print("esc")
        default:
            print(event.characters!)
        }
        
        
        
        if 1 > 2
        {
            
        }
        else //이 뷰에서 사용하지 않는 키는 밑으로 보낸다
        {
            super.keyDown(with : event)
        }
    }
    
    
    override func mouseUp(with event: NSEvent) {
        //hit test 에 걸린 뷰가 존재한다면, 이 매서드는 호출되지 않는다.
        //따라서 이 매서드가 호출되었다면, 노드는 클릭되지 않은 것이다. 따라서 활성화 노드를 제거한다.
        
        //마우스가 정확히 같은 곳을 클릭했을 때, 이벤트의 클릭 카운트가 증가한다.
        //노드가 생성된 뒤, 마우스를 움직이지 않으면 노드를 클릭해도 노드색깔이 바뀌지 않는다.
        let eventOrigin = event.locationInWindow
        
        if event.clickCount == 2 {
            let pnode = PTextNode(position: eventOrigin)
            self.nodetable.append(pnode)
            self.addSubview(pnode)
            
            print("Create new PNode at (\(eventOrigin.x), \(eventOrigin.y))")
            
            if self.selectedNode != nil {
                createLink(node_1: self.selectedNode!, node_2: pnode)
            }
            
            pnode.textfield.mouseUp(with: event)
            //dataManager?.saveData(str: "ssss")
            
            
            
        }
        else
        {
            //clearSelectedNode()
            //이 뷰를 다시 첫 리스폰더로 지정
            window?.makeFirstResponder(self)
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



