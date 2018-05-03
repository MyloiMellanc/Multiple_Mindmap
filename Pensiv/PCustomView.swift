//
//  PCustomView.swift
//  Pensiv
//
//  Created by Myloi Mellanc on 2017. 11. 19..
//  Copyright © 2017년 MyloiMellanc. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics
import QuartzCore


public extension CGFloat {
    ///Returns radians if given degrees
    var radians: CGFloat{return self * .pi / 180}
}

public extension CGPoint {
    ///Rotates point by given degrees
    func rotate(origin: CGPoint? = CGPoint(x: 0.0, y: 0.0), _ byDegrees: CGFloat) -> CGPoint {
        guard let origin = origin else {return self}
        
        let rotationSin = sin(byDegrees.radians)
        let rotationCos = cos(byDegrees.radians)
        
        let x = (self.x * rotationCos - self.y * rotationSin) + origin.x
        let y = (self.x * rotationSin + self.y * rotationCos) + origin.y
        
        return CGPoint(x: x, y: y)
    }
}

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
    //Announce superview that subview is touched
    @objc func PSelectNode(target node : PNode, key event : NSEvent) {
        
    }
    
    
    //Rendering Request by Link Instance
    @objc func PDrawFreeLink(pos_1 pos1 : CGPoint, pos_2 pos2 : CGPoint, progress : CGFloat = 1.0) {
        
    }
    
    @objc func PDrawArrowLink(pos_1 pos1 : CGPoint, pos_2 pos2 : CGPoint, progress : CGFloat = 1.0) {
        
    }
    
    @objc func PClearLinkPass() {
        
    }
    
    
    
    //Used for crawling map process
    @objc func PAddNode(target node : PNode) {
        
    }
    
    //Used for crawling map process
    @objc func PCreateLink(node_1 node1 : PNode, node_2 node2 : PNode) {
        
    }
}




class PCustomDocumentView : NSView
{
    ////////////////////////////////////////////////////////////////
    func initViewItem() {
        for link in self.linkList {
            link.detachNode()
        }
        self.linkList.removeAll()
        
        for node in self.nodeList {
            node.removeFromSuperview()
        }
        self.nodeList.removeAll()
    }
    
    
    ////////////////////////////////////////////////////////////////
    //MANAGE NODE
    
    //갖고있는 노드들을 관리, 순서 상관없으므로 집합으로 관리
    //모든 노드들은 본 리스트 컬렉션과 서브뷰 컬렉션에서 참조된다.
    var nodeList = Set<PNode>()
    
    
    
    //CREATION OF NEW NODE
    
    func createTextNode(position : CGPoint) -> PTextNode {
        let textnode = PTextNode(position: position)
        let id = textnode.getID()
        
        textnode.setText(str: String(id))
        
        self.nodeList.insert(textnode)
        self.addSubview(textnode)
        
        return textnode
    }
    
    func createTextNode(position : CGPoint, text : String) -> PTextNode {
        let textnode = PTextNode(position: position, text: text)
        
        self.nodeList.insert(textnode)
        self.addSubview(textnode)
        
        return textnode
    }
    
    
    
    func createCrawlingNode(position : CGPoint) -> PCrawlingNode {
        let crawlingnode = PCrawlingNode(position: position)
        
        self.nodeList.insert(crawlingnode)
        self.addSubview(crawlingnode)
        
        return crawlingnode
    }
    
    func getNodeByID(id : Int) -> PNode? {
        for node in self.nodeList {
            if node.getID() == id {
                return node
            }
        }
        
        return nil
    }
    
    override func PAddNode(target node: PNode) {
        self.nodeList.insert(node)
        self.addSubview(node)
    }
    
    ////////////////////////////////////////////////////////////////
    //CREATE MAP FROM DATA THREAD
    
    //Creating delay for node which will be created
    var delay : CFTimeInterval = 0.0
    
    
    private func createNodeFromItem(parent : PNode, item : PTextItem, direction : CGPoint, delay : CFTimeInterval = 0.0) {
        var position = parent.centerPoint
        
        position.x += direction.x
        position.y += direction.y
        
        let node = PTextNode(position: position, text: item.text, delay: self.delay)

        self.delay += 0.06
        
        self.PAddNode(target: node)
        
        self.PCreateLink(node_1: parent, node_2: node)
        
        ///////////////////////////////////////////////////////////////////////////
        
        if item.linkList.isEmpty != true {
            let base_degree = Int(log(Double(item.linkList.count)) / log(1.0116))
            let start_degree = -(CGFloat(base_degree) / 2.0)
            
            var degree_interval = 0
            if item.linkList.count != 1 {
                degree_interval = Int(Float(base_degree) / Float(item.linkList.count - 1))
            }
            
            for (index, link) in item.linkList.enumerated() {
                let degree : CGFloat = start_degree + CGFloat(degree_interval * index)
                let next_direction = direction.rotate(degree)
                
                self.createNodeFromItem(parent: node, item: link.textItem, direction: next_direction, delay: delay)
            }
        }
    }
    
    func createNodeFromMap(parent : PNode, map : Array<PTextItem>) {
        // 1 : 0, 2 : 60, 3 : 90, 4 : 100, 5 : 120, 6 : 144, 7 : 168 8 : 180
        // 1.0116
        let base_degree = Int(log(Double(map.count)) / log(1.0116))
        let start_degree = -(CGFloat(base_degree) / 2.0)
        
        var degree_interval = 0
        if map.count != 1 {
            degree_interval = Int(Float(base_degree) / Float(map.count - 1))
        }
        
        let base_direction = CGPoint(x: 0.0, y: -130.0)
        
        self.delay = 0.0
        
        for (index, item) in map.enumerated() {
            let degree : CGFloat = start_degree + CGFloat(degree_interval * index)
            let direction = base_direction.rotate(degree)

            self.createNodeFromItem(parent: parent, item: item, direction: direction)
        }
        
        self.delay = 0.0
    }
    
    
    ////////////////////////////////////////////////////////////////
    //MANAGE LINK
    
    //노드간의 링크를 나타내는 객체는 생성될때 본 메인 뷰, 각 두 노드, 총 3곳에서 참조된다.
    var linkList = Set<PLink>()
    
    
    //CREATION OF NEW LINK
    
    func createLink(node_1 node1 : PNode, node_2 node2 : PNode)
    {
        let link = PArrowLink(view : self, parent : node1, child : node2)
        self.linkList.insert(link)
        node1.addLink(link: link)
        node2.addLink(link: link)
    }
    
    override func PCreateLink(node_1 node1: PNode, node_2 node2: PNode) {
        let link = PArrowLink(view : self, parent : node1, child : node2)
        self.linkList.insert(link)
        node1.addLink(link: link)
        node2.addLink(link: link)
    }
    
    func createLinkByID(id_1 : Int, id_2 : Int) {
        let node_1 = self.getNodeByID(id: id_1)
        let node_2 = self.getNodeByID(id: id_2)
        if node_1 == nil || node_2 == nil {
            print("ID is didn't matched.")
            return
        }
        else {
            let link = PArrowLink(view: self, parent: node_1!, child: node_2!)
            self.linkList.insert(link)
            node_1?.addLink(link: link)
            node_2?.addLink(link: link)
        }
    }
    
    func searchLink(node_1 node1 : PNode, node_2 node2 : PNode) -> PLink? {
        for link in self.linkList {
            if link.itContains(view: self, node1: node1, node2: node2) == true {
                return link
            }
        }
        
        return nil
    }
    
    func deleteLink(link : PLink) {
        link.detachNode()
        self.linkList.remove(link)
    }
    
    
    
    
    override func PClearLinkPass() {
        for link in self.linkList {
            link.clearPass()
        }
    }
    
    
    ////////////////////////////////////////////////////////////////
    //MANAGE ACTIVATION STATE OF NODE
    
    //맵 편집을 위한 활성화 노드 관리는 전부 본 뷰에서 담당한다
    //순서가 필요없으므로 집합으로 관리한다.
    var activatedNodeList = Set<PNode>()
    
    func clearActivatedNode() {
        for node in activatedNodeList {
            node.untoggle()
        }
        
        activatedNodeList.removeAll()
    }
    
    func toggleNode(target node : PNode, onoff : Bool) {
        if onoff == true {
            self.activatedNodeList.insert(node)
            node.toggle()
        }
        else {
            self.activatedNodeList.remove(node)
            node.untoggle()
        }
        
        //print("Activated Count : \(self.activatedNodeList.count)")
    }
    
    
    func deleteNode(target node : PNode) {
        for link in node.linkList {
            self.deleteLink(link: link)
        }
        
        node.removeFromSuperview()
        self.nodeList.remove(node)
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////
    //Select node from Touch event of PNode
    
    //노드가 마우스 이벤트를 받았을 떄, 메인 뷰로 다시 호출하는 매서드
    //PNode의 다중 활성화 형성을 위해 본 클래스에서 담당
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
    //Rendering Link command called from PLink objects
    
    func rotatePoint(target: CGPoint, aroundOrigin origin: CGPoint, byDegrees: CGFloat) -> CGPoint {
        let dx = target.x - origin.x
        let dy = target.y - origin.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) // in radians
        let newAzimuth = azimuth + byDegrees * CGFloat(Float.pi / 180.0) // convert it to radians
        let x = origin.x + radius * cos(newAzimuth)
        let y = origin.y + radius * sin(newAzimuth)
        return CGPoint(x: x, y: y)
    }
    
    
    //렌더링 관련 매서드들
    //본 메인 뷰 드로잉 매서드가 먼저 호출된 뒤에 노드들의 드로잉 매서드가 호출되므로
    //노드 뒤에 가려지게 그려질 링크는 노드들보다 먼저 그려져야하므로, 본 메인 뷰에서 링크 드로잉을 담당한다.
    override func PDrawFreeLink(pos_1 pos1: CGPoint, pos_2 pos2: CGPoint, progress : CGFloat = 1.0) {
        let line = NSBezierPath()
        line.move(to: pos1)
        line.line(to: CGPoint(x: pos1.x + (pos2.x - pos1.x) * progress, y: pos1.y + (pos2.y - pos1.y) * progress))
        line.lineWidth = 2.0
        line.stroke()
    }
    
    
    override func PDrawArrowLink(pos_1 pos1: CGPoint, pos_2 pos2: CGPoint, progress : CGFloat = 1.0) {
        let line = NSBezierPath()
        line.move(to: pos1)
        
        let target = CGPoint(x: pos1.x + (pos2.x - pos1.x) * progress, y: pos1.y + (pos2.y - pos1.y) * progress)
        line.line(to: target)
        line.lineWidth = 2.0
        line.stroke()
        
        let sidePoint1 = CGPoint(x: pos1.x + (target.x - pos1.x) * 0.85 , y: pos1.y + (target.y - pos1.y) * 0.85)
        let sidePoint2 = CGPoint(x: pos1.x + (target.x - pos1.x) * 0.90 , y: pos1.y + (target.y - pos1.y) * 0.90)
        
        line.move(to: sidePoint2)
        line.line(to: rotatePoint(target: sidePoint1, aroundOrigin: sidePoint2, byDegrees: 20.0))
        line.stroke()
        
        line.move(to: sidePoint2)
        line.line(to: rotatePoint(target: sidePoint1, aroundOrigin: sidePoint2, byDegrees: -20.0))
        line.stroke()
    }
    
    
    //Line들이 먼저 그려져야하므로, 모든 라인 드로우를 여기에서 담당
    //서브 뷰의 드로잉은 여기서 처리하지 않고, 각자의 드로잉 매서드에서 처리된다
    
    //Link Animation
    
    var progress : CGFloat = 1.0
    
    func playLinkAnimation() {
        self.progress = 0.0
        self.needsDisplay = true
        self.displayIfNeeded()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        for link in linkList {
            link.draw(progress: self.progress)
        }
        
        if progress < 1.0 {
            self.progress += 0.002
            self.needsDisplay = true
            self.displayIfNeeded()
        }
        
    }
    
    
    ////////////////////////////////////////////////////////////////
    //Input Event of Custom View
    
    
    
    //INPUT EVENT
    
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
        else if event.modifierFlags.contains(.option) == true && event.keyCode == 31  {   //Alt + o
            let panel = NSOpenPanel()
            
            panel.title = "Select File"
            panel.allowsMultipleSelection = false
            panel.canChooseFiles = true
            panel.canChooseDirectories = false
            panel.canCreateDirectories = false
            panel.allowedFileTypes = ["xml"]
            panel.directoryURL = URL(fileURLWithPath: "/Users/mellanc/Desktop")
            
            let result = panel.runModal()
            if result == NSApplication.ModalResponse.OK {
                PFileManager.pInstance.load(view: self, filepath: panel.url!)
            }
        }
        else if event.modifierFlags.contains(.option) == true && event.keyCode == 1 { //Alt + s
            let panel = NSSavePanel()
            
            panel.message = "Save Map to xml File"
            panel.allowsOtherFileTypes = false
            panel.allowedFileTypes = ["xml"]
            panel.directoryURL = URL(fileURLWithPath: "/Users/mellanc/Desktop")
            
            let result = panel.runModal()
            if result == NSApplication.ModalResponse.OK {
                PFileManager.pInstance.save(filepath: panel.url!, nodes: self.nodeList, links: self.linkList)
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
        
        if (event.clickCount == 2) && (event.modifierFlags.contains(.control)) {
            let crawlingNode = createCrawlingNode(position: pos)
        }
        else if (event.clickCount == 2) && (event.modifierFlags.contains(.option)) {
            let textnode = self.createTextNode(position: pos)
            textnode.focus()
        }
        else {
            //이 뷰를 다시 첫 리스폰더로 지정
            window?.makeFirstResponder(self)
            
            //활성화 초기화
            self.clearActivatedNode()
            //print("Activated Clear")
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
    ////////////////////////////////////////////////////////////////
    //Control Size of Custom View
    
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
    //Set First Responder
    
    
    // 해당 이벤트를 여기서 사용한다 라는 의미
    // 하지만 그냥 true를 리턴하면 모든 키 이벤트를 여기로 보내므로, 종료 단축키와 같은 것도 안됨
   /* override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
        
        //필요한 키들만 true를 리턴하게 만든다
    }*/
    
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    
    
}






////////////////////////////////////////////////////////////////

/*
 //HIT Test Demo
 
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
