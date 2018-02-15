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




enum P_NODE_TYPE {
    case TEXT
    case CRAWLING
}




class PNode : NSView    //PNode를 상속하는 모든 노드가 기본 뷰를 가질 예정으로, 미리 상속받음
{
    
    //노드 고유 인식 번호 부여 관련
    static var nodeCount : Int = 0
    
    var nodeNumber : Int
    
    ////////////////////////////////////////////////////////////////
    
    //노드 생성시 그래픽 기본값 관련
    //차후 팩토리 객체화할것
    static let baseWidth : CGFloat = 60.0
    static let baseHeight : CGFloat = 30.0
    
    static let gap : CGFloat = 5.0
    
    
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
    
    init(position touchPoint : CGPoint)
    {
        //Init Node Number 
        PNode.nodeCount = PNode.nodeCount + 1
        self.nodeNumber = PNode.nodeCount
        
        
        
        let framePoint = CGPoint(x: touchPoint.x - (PNode.baseWidth / 2 + PNode.gap), y: touchPoint.y - (PNode.baseHeight / 2 + PNode.gap) )
        let frameRect = NSRect(x: framePoint.x, y: framePoint.y, width: PNode.baseWidth + (PNode.gap * 2), height: PNode.baseHeight + (PNode.gap * 2))
        super.init(frame : frameRect)
        
        
        self.layer = CAShapeLayer()
        self.wantsLayer = true
        
        self.layer?.backgroundColor = CGColor.black
        
        let scale_animation = CASpringAnimation(keyPath: "transform.scale")
        scale_animation.duration = 0.6
        scale_animation.fromValue = 0
        scale_animation.toValue = 1
        
        let position_animation = CASpringAnimation(keyPath: "position")
        position_animation.duration = 0.6
        position_animation.fromValue = touchPoint
        position_animation.toValue = framePoint
        
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
    
    func detachLink(link : PLink) {
        self.linkList.remove(link)
    }
    
    ////////////////////////////////////////////////////////////////
    
    //마우스 터치 관련 매서드
    //노드를 드래그한 이후에도 mouseUp을 호출하지 않도록 토큰 사용
    var moved : Bool = false
    
    override func mouseDragged(with event: NSEvent) {
        self.frame.origin.x += event.deltaX
        self.frame.origin.y -= event.deltaY //어째서 Y 변화량의 축이 다르지?
        
        //y축이 인버트되어있음
        //print("\(event.deltaX), \(event.deltaY)")
        
        superview?.needsDisplay = true
        
        self.moved = true
    }
    
    
    //드래그가 아니라면, 해당 노드를 활성화하도록 CustomView에게 호출
    override func mouseUp(with event: NSEvent) {
        if self.moved == false {
            //superview?.PSelectNode(target: self, key : event)
            superview?.superview?.PSelectNode(target: self, key: event)
        }
        
        self.moved = false
    }
    
    ////////////////////////////////////////////////////////////////
    
    
    
    
    //오버라이드 전용 노드 편집 매서드
    func focus() {
        
    }
}








/*
    
    //var trackingarea : NSTrackingArea?
    
    /*
    override func updateTrackingAreas() {
        if (trackingarea != nil)
        {
            self.removeTrackingArea(trackingarea!)
        }
        
        let options : NSTrackingArea.Options = [.activeWhenFirstResponder, .mouseMoved]
        
        trackingarea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        
        self.addTrackingArea(trackingarea!)
    }*/
    
    
    
    
    //ID
    //Position
    //Scale
    //TextSize
    //Alpha
    //Color
    //Zorder
    //
}

*/


