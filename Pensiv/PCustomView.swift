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



/*
 *
 *  빈곳을 클릭했을때 활성화 제거 -> 본 커스텀 뷰가 노드와 라인을 보유하여야 한다
 *  커스텀 뷰의 터치 매서드는 빈곳을 클릭했을 때만 호출되므로, 해당 매서드에 활성화 제거 매서드를 넣는다
 *
 *  두 노드간의 관계형성도 동일한 방식으로 수행
 *
 *
 */

enum P_NODE_TYPE {
    case TEXT
    case CRAWLING
}




extension NSView
{
    @objc func PSelectNode(target node : PNode) {
        
    }
    
    @objc func PFindEmptyPosition() -> CGPoint {
        return CGPoint()
    }
    
    @objc func PCreateNode(position touchPoint : CGPoint) {
        
    }
}



class PCustomView : NSView
{
    
    var viewNumber : Int = 1
    
    /*
    override var isFlipped: Bool{
        get {
            return false
        }
    }*/
   
    var nodetable = [PNode]()
    
   // var trackingarea : NSTrackingArea?
    
    
    var dataManager : PDataManager?
    
    func initDataBase()
    {
        if let dele = NSApplication.shared.delegate as? AppDelegate
        {
            dataManager = PDataManager(mother : dele)
        }
        
    }
    
    
    override func viewDidEndLiveResize() {
        
        //Struct is copy value
        var frame = NSApplication.shared.windows.first?.frame
        frame?.origin = CGPoint(x: 0, y: 0)
        self.frame = frame!
    }
    
    override func viewWillDraw() {
        self.layer?.backgroundColor = CGColor.white
    }
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
    
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
    
    var selectedNode : PNode? = nil
    
    
    override func PSelectNode(target node: PNode) {
        if node == nil {
            return
        }
        
        //이미 활성화된 노드와 다르면
            //스킵, 혹은 라인 생성?
        //활성화 노드가 없다면,
            //해당 노드를 활성화시킨다
        if self.selectedNode == nil {
            print("\(self.selectedNode?.nodeNumber) is activated")
            self.selectedNode = node
            self.selectedNode?.layer?.backgroundColor = CGColor(red: 255, green: 0, blue: 0, alpha: 1)
        }
        else if self.selectedNode == node { //활성화된 노드를 클릭했다면, 활성화를 중단한다.
            print("\(self.selectedNode?.nodeNumber) is deactivated")
            self.selectedNode?.layer?.backgroundColor = CGColor.black
            self.selectedNode = nil
        }
    }
    
    override func PFindEmptyPosition() -> CGPoint {
        return CGPoint()
    }
    
    override func PCreateNode(position touchPoint : CGPoint) {
        
    }
    
    func createNode()
    {
        //생성 및 서브뷰 등록
        //데이터베이스에 본 뷰넘버를 기반으로 저장
    }
    
    
    
    override func mouseDown(with event: NSEvent) {
        //hit test 에 걸린 뷰가 존재한다면, 이 매서드는 호출되지 않는다.
        //따라서 이 매서드가 호출되었다면, 노드는 클릭되지 않은 것이다. 따라서 활성화 노드는 제거된다.
       
        if selectedNode != nil
        {
            selectedNode?.test()
        }
        
        //self.selectedNode = nil
        
        
        let eventOrigin = event.locationInWindow
        
        
        //마우스가 정확히 같은 곳을 클릭했을 때, 이벤트의 클릭 카운트가 증가한다.
        
        //노드가 생성된 뒤, 마우스를 움직이지 않으면 노드를 클릭해도 노드색깔이 바뀌지 않는다.
        
        if(event.clickCount == 2)
        {
            let pnode = PTextNode(position: eventOrigin)
            self.addSubview(pnode)
            
            print("Create new PNode at (\(eventOrigin.x), \(eventOrigin.y))")
            
            
            pnode.text.mouseDown(with: event)
            //dataManager?.saveData(str: "ssss")
        }
        
    }
    
    
    //드래그도 필연적으로 업다운 매서드를 호출시키게 된다.
    //다운은 단순 다운 선언. 업이 되엇을때 해결
    override func rightMouseDown(with event: NSEvent) {
        print(11)
    }
    
    override func rightMouseDragged(with event: NSEvent) {
        print(22)
    }
    
    override func rightMouseUp(with event: NSEvent) {
        print(33)
    }
    
    
    
    override func draw(_ dirtyRect: NSRect) {
        
        //Line들이 먼저 그려져야하므로, 모든 라인 드로우를 여기에서 담당
        
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
 
}











